---
presentation:
  # presentation theme
  # === available themes ===
  # "beige.css"
  # "black.css"
  # "blood.css"
  # "league.css"
  # "moon.css"
  # "night.css"
  # "serif.css"
  # "simple.css"
  # "sky.css"
  # "solarized.css"
  # "white.css"
  # "none.css"
  theme: beige.css

  width: 1920
  height: 1080
  center: true
---

<!-- slide -->

# Проект Авиарейсы без потерь

### DSPR-28, Пётр Поляков

**Финальный запрос сохранён в прилагающемся файле proj4.sql**

Проект - вправо, решения задач модуля - вниз, Esc для обзора всех слайдов.

<!-- slide vertical=true -->

## 4.1

База данных содержит список аэропортов практически всех крупных городов России. В большинстве городов есть только один аэропорт. Исключение составляет:

```sql
select a.city, count(distinct a.airport_code)
from dst_project.airports a
group by 1
order by 2 desc
```

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

## 4.3

Вопрос 1. Сколько всего рейсов было отменено по данным базы?

```sql
select count(*)
from dst_project.flights
where status = 'Cancelled'
```

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

Вопрос 4. У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id). 

```sql
select flight_id, actual_arrival - scheduled_arrival
from dst_project.flights
where status = 'Arrived'
order by 2 desc
```

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

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

<!-- slide vertical=true -->

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


<!-- slide -->

### Структура датасета

Датасет содержит в единой таблице информацию по зимним месяцам 2017 года из Анапы.

#### Собранные поля можно условно поделить на четыре категории:

**Две основные:**

- информация о полётах
- информация о стоимости

**И две вспомогательные:**

- информация о аэропортах
- информация о самолётах

Наиболее значимые, на мой взгляд, поля, я пометил двумя восклицательными знаками ("!!") на дальнейших слайдах.

Описания полей - вниз. Недостающие данные - впарво.

<!-- slide vertical=true -->

### Информация о полётах (1/3)

В основном нам будут интересны именно производные от данных полей, но сами поля оставлены для оставлены на случай, если Вы захотите продолжительность самостоятельно в более подходящих Вам единицах. Feel free to kill

- **scheduled_departure** - запланированное время вылета
- **scheduled_arrival** - запланированное время прилёта
- **actual_arrival** - фактическое время вылета
- **actual_departure** - фактическое время прилёта

<!-- slide vertical=true -->

### Информация о полётах (2/3)

Производные от полей с предыдущего слайда. Более продолжительные полёты могут оказаться более топливоэффективными.

- !! **planned_flight_time** - запланированная продолжительность полёта
- !! **actual_flight_time** - фактическая продолжительность полёта

<!-- slide vertical=true -->

### Информация о стоимости

Отсюда можно посчитать прибыль. Больше = лучше. Соотносить с дальностью и продолжительностью полётов.

- !! **economy_value** - сумма в деньгах по бронированиям эконом класса
- !! **business_value** - сумма в деньгих по бронированиям бизнес класса
- !! **comfort_value** - сумма в деньгих по бронированиям комфорт класса
- !! **total_value** - стоимость мест

<!-- slide vertical=true -->

### Информация о аэропортах (1/2)

Географические координаты аэропортов. 

- !! **departure_longitude**
- !! **departure_latitude**
- !! **arrival_longitude**
- !! **arrival_latitude**
- **pifagor_shitty_distance_between_airports** - поле выражает в некотором роде дистанцию между аэропортами вылета и назначения (высчитано по теореме пифагора для плоскости, но Земля не плоская), может быть полезной информацией для алгоритма, но лучше посчитать с помощью pandas hoversine distance для той-же цели

<!-- slide vertical=true -->

### Информация о аэропортах (2/2)

Поля для идентификации и классификации аэропотов, по ним можно 

- **departure_airport** - аэропорт вылета. Везде Анапа, можно выбросить. Лежит для проверки и уверенности в данных
- **arrival_airport** - аэропорт прибытия, человеческим текстом для подтягивания дополнительной статистики
- **departure_city** - Анапа, можно выбросить, тут оно для проверки
- **arrival_city** - город прибытия, для подтягивания дополнительных данных
- **departure_timezone** - таймзона вылета, нужна для сравнения с таймзоной прилёта, можно получить дополнительные фичи для модели
- **arrival_timezone** - таймзона прибытия, может служить как для классификации по континентам (можно поделить по слешу колонку на две), так и для сравнения с таймзоной вылета

<!-- slide vertical=true -->

### Информация о самолётах (1/2)

- **flight_no** - присвоенный номер рейса. Поле, служащее для идентификации. Именно номера рейсов нам следует поделить на те, что следует отменить и те, что надо оставить
- **flight_status** - статус вылета, из датасета исключены отменённые
- **aircraft_model** - модель самолёта, можно использовать для присоединения дополнительной информации
- !! **aircraft_range** - максимальная дальность полёта. Это может оказаться важным при сравнении с фактической дальностью рейса. Поскольку значительная часть топлива тратится на взлёт, наиболее топливоэффективными окажутся рейсы, наиболее близкие к максимальной дальности

<!-- slide vertical=true -->

### Информация о самолётах (2/2)

- !! **economy_seats** - количество мест в эконом классе
- !! **business_seats** - количество мест в бизнес классе
- !! **comfort_seats** - количество мест в комфорт классе

<!-- slide -->

## Данные, которые можно добавить в нашу таблицу, но их нет в базе

- коэффициент влияния вращения земли на полёты на запад/восток. Очевидно, если считать не только расстояние, но и направление относительно вращения земли, можно получить разные расходы топлива при движениях на одинаковое расстояние на запад или на восток
- информацию по расходу топлива для каждой модели самолёта: расход на взлёт, расход на "крейсерской" скорости, тип топлива
- прайс лист стоимости имеющихся категорий топлива
- информация по населению городов, где находятся аэропорты
- координаты городов, для определения дистанции от города до аэропорта
- стоимость издержек по хранению и техническому обслуживанию - чистка ото льда, оплата ангаров, отопление, зарплаты обслуживающего персонала

<!-- slide -->

## Возможные способы оценки прибыльности рейсов

- высчитываем расход топлива из координат, коэффициента вращения земли, направления полёта относительно вращения... или берём у кого-то точные цифры, если есть
- считаем стоимость израсходованного топлива согласно полученному прайс листу, стоимость техобслуживания и хранения - получаем **расход**
- считаем сумму букирований, вычитаем налоги - получаем **доход**
- сравниваем расход с приходом, считаем _ROI_, cразу выбрасываем отрицательные цифры, дальше играемся с порогом, откидывая тех, кто "на грани"
- **получаем размеченную таблицу** на "выкинуть" и "оставить", обучаем алгоритмы машинного обучения на результатах
- при появлении новых рейсов по имеющимся параметрам **предсказываем обученной моделью, "выкинуть" или "оставить"**
- как другой вариант вариант - **учим регрессию по _ROI_ и предсказываем _ROI_**