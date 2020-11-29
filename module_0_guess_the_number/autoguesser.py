# используем стандартную библиотеку для генерации случайных целых чисел
# использование numpy считаю избыточным и нецелесообразным
from random import randint


def autoguess(number: int, in_range: list):
    """
    Всегда указываем ровно в середину диапозона

    Если попали -- хорошо,
    если наша попытка меньше или больше заданного,
    отбрасываем соответствующую половину значений и указываем в середину оставшегося диапозона.
    Повтоярем до победного.

    Угадывает в среднем чуть менее чем за 6 попыток, но никогда не больше 7-и
    """

    print(f"Загадано число от {in_range[0]} до {in_range[-1]}")

    count = 0
    while True:

        guess = (max(in_range) - min(in_range)) // 2 + min(in_range)
        count += 1

        print(f"Попытка номер {count}: {guess}...", end="\t")

        if guess == number:
            print(f"Бинго!\n\nВы угадали число {number} за {count} попыток.")
            return count
        elif number > guess:
            print(f"Угадываемое число больше {guess}")
            in_range[0] = guess + 1  # двигаем нижнюю позицию диапозона
        else:
            print(f"Угадываемое число меньше {guess}")
            in_range[-1] = guess - 1  # двигаем верхнюю границу диапозона


# единичный пример использования
in_range = [1, 100]
number = randint(*in_range)  # загадали число в заданном диапозоне
autoguess(number, in_range)

# считаем среднюю производительность алгоритма
thousand_guesses = []
for _ in range(1000):
    thousand_guesses.append(autoguess(randint(1, 100), [1, 100]))

print(
    "\n\nВ среднем мы угадываем за",
    sum(thousand_guesses) / len(thousand_guesses),
    "попыток",
)
