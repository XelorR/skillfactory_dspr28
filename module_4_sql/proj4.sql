-- first subquery for add numbers of seats for each class
WITH aircrafts_with_number_of_seats AS
  (SELECT COALESCE(eco.aircraft_code, bus.aircraft_code, com.aircraft_code) AS aircraft_code,
          eco.model,
          eco.range,
          eco.economy_seats,
          bus.business_seats,
          com.comfort_seats
   FROM
   -- sub-sub query to count economy class seats available
     (SELECT a.aircraft_code,
             a.model,
             a.range,
             count(s.seat_no) economy_seats
      FROM dst_project.aircrafts AS a
      LEFT JOIN dst_project.seats s ON a.aircraft_code = s.aircraft_code
      WHERE s.fare_conditions = 'Economy'
      GROUP BY 1,
               2,
               3) eco
   FULL OUTER JOIN
   -- sub-sub query to count business class seats available
     (SELECT a.aircraft_code,
             count(s.seat_no) business_seats
      FROM dst_project.aircrafts a
      LEFT JOIN dst_project.seats s ON a.aircraft_code = s.aircraft_code
      WHERE s.fare_conditions = 'Business'
      GROUP BY 1) bus ON eco.aircraft_code = bus.aircraft_code
   FULL OUTER JOIN
   -- sub-sub query to count comfort class seats available
     (SELECT a.aircraft_code,
             count(s.seat_no) comfort_seats
      FROM dst_project.aircrafts a
      LEFT JOIN dst_project.seats s ON a.aircraft_code = s.aircraft_code
      WHERE s.fare_conditions = 'Comfort'
      GROUP BY 1) com ON eco.aircraft_code = com.aircraft_code)

-- main query, generating main table
-- here is the final cols:
SELECT f.flight_no,
       f.scheduled_departure,
       f.scheduled_arrival,
       f.actual_arrival,
       f.actual_departure,
       f.scheduled_arrival - f.scheduled_departure AS planned_flight_time,
       f.actual_arrival - f.actual_departure AS actual_flight_time,
       f.status AS flight_status,
       ac.model AS aircraft_model,
       ac.economy_seats,
       ac.business_seats,
       ac.comfort_seats,
       ac.range AS aircraft_range,
       sqrt(
         power(dep_air.latitude - arr_air.latitude, 2)
         + power(dep_air.longitude - arr_air.longitude, 2))
         AS pifagor_shitty_distance_between_airports,
       dep_air.longitude AS departure_longitude,
       dep_air.latitude AS departure_latitude,
       arr_air.longitude AS arrival_longitude,
       arr_air.latitude AS arrival_latitude,
       dep_air.airport_name AS departure_airport,
       arr_air.airport_name AS arrival_airport,
       dep_air.city AS departure_city,
       arr_air.city AS arrival_city,
       dep_air.timezone AS departure_timezone,
       arr_air.timezone AS arrival_timezone,
       vb.economy_value,
       vb.business_value,
       vb.comfort_value,
       vb.total_value
FROM dst_project.flights f
LEFT JOIN aircrafts_with_number_of_seats ac ON f.aircraft_code = ac.aircraft_code
LEFT JOIN dst_project.airports dep_air ON f.departure_airport = dep_air.airport_code
LEFT JOIN dst_project.airports arr_air ON f.arrival_airport = arr_air.airport_code
-- last join is subquery which add 4 columns: 3 for each class and one for.. prices?
LEFT JOIN
  (SELECT eco.flight_id,
          sum(eco.economy_value) AS economy_value,
          sum(bus.business_value) AS business_value,
          sum(com.comfort_value) AS comfort_value,
          sum(eco.total_value) AS total_value
   FROM
   -- sub-sub query one: value of economy class
     (SELECT tf.ticket_no,
             tf.flight_id,
             sum(tf.amount) AS total_value,
             sum(b.total_amount) AS economy_value
      FROM dst_project.ticket_flights tf
      LEFT JOIN dst_project.tickets t ON t.ticket_no = tf.ticket_no
      LEFT JOIN dst_project.bookings b ON t.book_ref = b.book_ref
      WHERE tf.fare_conditions = 'Economy'
      GROUP BY 1,
               2) AS eco
   FULL OUTER JOIN
   -- sub-sub query 2: value of business class
     (SELECT tf.ticket_no,
             sum(b.total_amount) AS business_value
      FROM dst_project.ticket_flights tf
      LEFT JOIN dst_project.tickets t ON t.ticket_no = tf.ticket_no
      LEFT JOIN dst_project.bookings b ON t.book_ref = b.book_ref
      WHERE tf.fare_conditions = 'Business'
      GROUP BY 1) AS bus ON eco.ticket_no = bus.ticket_no
   FULL OUTER JOIN
   -- sub-sub query 3: value of comfort class
     (SELECT tf.ticket_no,
             sum(b.total_amount) AS comfort_value
      FROM dst_project.ticket_flights tf
      LEFT JOIN dst_project.tickets t ON t.ticket_no = tf.ticket_no
      LEFT JOIN dst_project.bookings b ON t.book_ref = b.book_ref
      WHERE tf.fare_conditions = 'Comfort'
      GROUP BY 1) AS com ON eco.ticket_no = com.ticket_no
   GROUP BY 1) vb ON vb.flight_id = f.flight_id
-- main table filter
WHERE departure_airport = 'AAQ'
  AND (date_trunc('month', scheduled_departure) in ('2017-01-01',
                                                    '2017-02-01',
                                                    '2017-12-01'))
  AND status not in ('Cancelled')