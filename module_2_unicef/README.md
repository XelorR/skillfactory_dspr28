# Проект 2: разведывательный анализ данных на примере данных UNICEF

## Основные цели и задачи проекта

- научиться предобрабатывать данные
- отработать на практике определение значимости переменных
- потренроваться в выявлении и чистке выбросов и заполнении пропущенных значений
- подготовить данные для обучения модели

## Краткая информация о данных

Данные успеваемости по математике студентов двух школ. Имеется информация о различных аспектах жизни студента, на основании которой предлагается прогнозировать ео оценку.

Описание полей:

1. school`— аббревиатура школы, в которой учится ученик
2. sex`— пол ученика ('F' - женский, 'M' - мужской)
3. age`— возраст ученика (от 15 до 22)
4. address`— тип адреса ученика ('U' - городской, 'R' - за городом)
5. famsize`— размер семьи('LE3' &lt;= 3, 'GT3' &gt;3)
6. Pstatus`— статус совместного жилья родителей ('T' - живут вместе 'A' - раздельно)
7. Medu`— образование матери (0 - нет, 1 - 4 класса, 2 - 5-9 классы, 3 - среднее специальное или 11 классов, 4 - высшее)
8. Fedu`— образование отца (0 - нет, 1 - 4 класса, 2 - 5-9 классы, 3 - среднее специальное или 11 классов, 4 - высшее)
9. Mjob`— работа матери ('teacher' - учитель, 'health' - сфера здравоохранения, 'services' - гос служба, 'at_home' - не работает, 'other' - другое)
10. Fjob`— работа отца ('teacher' - учитель, 'health' - сфера здравоохранения, 'services' - гос служба, 'at_home' - не работает, 'other' - другое)
11. reason`— причина выбора школы ('home' - близость к дому, 'reputation' - репутация школы, 'course' - образовательная программа, 'other' - другое)
12. guardian`— опекун ('mother' - мать, 'father' - отец, 'other' - другое)
13. traveltime`— время в пути до школы (1 - &lt;15 мин., 2 - 15-30 мин., 3 - 30-60 мин., 4 - &gt;60 мин.)
14. studytime`— время на учёбу помимо школы в неделю (1 - &lt;2 часов, 2 - 2-5 часов, 3 - 5-10 часов, 4 - &gt;10 часов)
15. failures`— количество внеучебных неудач (n, если 1<=n<=3, иначе 0)
16. schoolsup`— дополнительная образовательная поддержка (yes или no)
17. famsup`— семейная образовательная поддержка (yes или no)
18. paid`— дополнительные платные занятия по математике (yes или no)
19. activities`— дополнительные внеучебные занятия (yes или no)
20. nursery`— посещал детский сад (yes или no)
21. higher`— хочет получить высшее образование (yes или no)
22. internet`— наличие интернета дома (yes или no)
23. romantic`— в романтических отношениях (yes или no)
24. famrel`— семейные отношения (от 1 - очень плохо до 5 - очень хорошо)
25. freetime`— свободное время после школы (от 1 - очень мало до 5 - очень мого)
26. goout`— проведение времени с друзьями (от 1 - очень мало до 5 - очень много)
27. health`— текущее состояние здоровья (от 1 - очень плохо до 5 - очень хорошо)
28. absences`— количество пропущенных занятий
29. score`— баллы по госэкзамену по математике

## Проведены следующие этапы работы над проектом

- чтение данных
- очистка выбросов
- оценка значимости переменных и отброс малозначимых
- заполнение пропусков
- написание выводов и загрузка на гитхаб

## Ответы на вопросы саморефлексии:

### 1\. Какова была ваша роль в команде?

Я делал всё. Читал, чистил, анализировал, заполнял пропуски. готовил данные для моделирования в дальнейшем.

### 2\. Какой частью своей работы вы остались особенно довольны?

Нагуглил и применил **KNNImputer**, доволен как слон :)

### 3\. Что не получилось сделать так, как хотелось? Над чем ещё стоит поработать?

Не удалось корректно применить импутер к номинативным переменным. Надо научиться корректно их преобразовывать в числа и обратно.

И времени много потратил. Что-то закопался.

### 4\. Что интересного и полезного вы узнали в этом модуле?

Определение уровня значимости посредством питона

### 5\. Что является вашим главным результатом при прохождении этого проекта?

Довольство собой

### 6\. Какие навыки вы уже можете применить в текущей деятельности?

"Угадывать" пропущенные значения в присланных данных

### 7\. Планируете ли вы дополнительно изучать материалы по теме проекта?

Конечно! Тема муторная, но уже сейчас может пригодиться в работе
