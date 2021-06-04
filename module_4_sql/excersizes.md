# Предварительные задачи

## 4.1

База данных содержит список аэропортов практически всех крупных городов России. В большинстве городов есть только один аэропорт. Исключение составляет:

```sql
select a.city, count(distinct a.airport_code)
from dst_project.airports a
group by 1
order by 2 desc
```

## 4.2

Вопрос 1. Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах. Сколько всего статусов для рейсов определено в таблице?

```sql
select count(distinct status)
from dst_project.flights
```

Вопрос 2. Какое количество самолетов находятся в воздухе на момент среза в базе (статус рейса «самолёт уже вылетел и находится в воздухе»). 

```sql
select count(distinct flight_no)
from dst_project.flights
where status = 'Departed'
```

Вопрос 3. Места определяют схему салона каждой модели. Сколько мест имеет самолет модели (Boeing 777-300)? 

```sql
select count(distinct s.seat_no)
from dst_project.aircrafts a
join dst_project.seats s
    on a.aircraft_code = s.aircraft_code
where a.model = 'Boeing 777-300'
```

Вопрос 4. Сколько состоявшихся (фактических) рейсов было совершено между 1 апреля 2017 года и 1 сентября 2017 года? 

```sql
select count(flight_id)
from dst_project.flights
where (actual_arrival between '2017-04-01' and '2017-09-01')
    and status = 'Arrived'
```

## 4.3

Вопрос 1. Сколько всего рейсов было отменено по данным базы?

```sql
select count(*)
from dst_project.flights
where status = 'Cancelled'
```

Вопрос 2. Сколько самолетов моделей типа Boeing, Sukhoi Superjet, Airbus находится в базе авиаперевозок? 

Boeing:

```sql
select count(*)
from dst_project.aircrafts
where model like 'Boeing%'
```

Sukhoi Superjet:

```sql
select count(*)
from dst_project.aircrafts
where model like 'Sukhoi Superjet%'
```

Airbus:

```sql
select count(*)
from dst_project.aircrafts
where model like 'Airbus%'
```

Вопрос 3. В какой части (частях) света находится больше аэропортов? 

```sql
select 'Asia' continent, count(*) airports
from dst_project.airports
where timezone like 'Asia%'

UNION

select 'Europe' continent, count(*) airports
from dst_project.airports
where timezone like 'Europe%'

UNION

select 'Australia' continent, count(*) airports
from dst_project.airports
where timezone like 'Australia%'
```

Вопрос 4. У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id). 

```sql
select flight_id, actual_arrival - scheduled_arrival
from dst_project.flights
where status = 'Arrived'
order by 2 desc
```

## 4.4

Вопрос 1. Когда был запланирован самый первый вылет, сохраненный в базе данных?

```sql
select min(scheduled_arrival)
from dst_project.flights
```

Вопрос 2. Сколько минут составляет запланированное время полета в самом длительном рейсе? 

```sql
select scheduled_arrival - scheduled_departure
from dst_project.flights
order by 1 desc
```

Вопрос 3. Между какими аэропортами пролегает самый длительный по времени запланированный рейс?

```sql
select departure_airport, arrival_airport, scheduled_arrival - scheduled_departure
from dst_project.flights
order by 3 desc
limit 1
```

Вопрос 4. Сколько составляет средняя дальность полета среди всех самолетов в минутах? Секунды округляются в меньшую сторону (отбрасываются до минут).

```sql
select avg(actual_arrival - actual_departure)
from dst_project.flights
```

## 4.5

Вопрос 1. Мест какого класса у SU9 больше всего? 

```sql
select fare_conditions, count(*)
from dst_project.seats
where aircraft_code = 'SU9'
group by 1
order by 2 desc
```

Вопрос 2. Какую самую минимальную стоимость составило бронирование за всю историю? 

```sql
select min(total_amount)
from dst_project.bookings
```

Вопрос 3. Какой номер места был у пассажира с id = 4313 788533? 

```sql
select b.seat_no
from dst_project.tickets t join dst_project.boarding_passes b
    on t.ticket_no = b.ticket_no
where t.passenger_id = '4313 788533'
```

## 5.1

Вопрос 1. Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?

```sql
select count(*)
from dst_project.flights f join dst_project.airports a
    on f.arrival_airport = a.airport_code
where a.city = 'Anapa' and f.status = 'Arrived'
    and (f.actual_arrival between '2017-01-01' and '2017-12-31')
```

Вопрос 2. Сколько рейсов из Анапы вылетело зимой 2017 года?

```sql
select count(flight_id)
from dst_project.flights
where (departure_airport = 'AAQ')
  and (date_part('year', actual_departure) = 2017)
  and (date_part('month', actual_departure) in (12, 1, 2))
```

Вопрос 3. Посчитайте количество отмененных рейсов из Анапы за все время.

```sql
select count(*) from dst_project.flights
where status = 'Cancelled' and departure_airport = 'AAQ'
```

Вопрос 4. Сколько рейсов из Анапы не летают в Москву?

```sql
select count(f.flight_no)

from dst_project.flights f

join dst_project.airports arri
    on arri.airport_code = f.arrival_airport

where f.departure_airport = 'AAQ'
    and arri.city != 'Moscow'
```

Вопрос 5. Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?

```sql
select ac.model, count(seat_no) seat_count
from dst_project.aircrafts ac join dst_project.seats s
    on ac.aircraft_code = s.aircraft_code
where ac.model in (
    select distinct ac.model
    from dst_project.flights f
    join dst_project.airports ap
        on ap.airport_code = f.arrival_airport
    join dst_project.aircrafts ac
        on f.aircraft_code = ac.aircraft_code
    where ap.city = 'Anapa'
)
group by 1
```
