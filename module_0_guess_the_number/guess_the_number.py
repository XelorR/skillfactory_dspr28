from random import randint

count = 0  # счетчик попыток
number = randint(1, 100)  # загадали число
print("Загадано число от 1 до 100")

while True:  # бесконечный цикл
    predict = int(input())  # предполагаемое число
    count += 1  # плюсуем попытку
    if number == predict:
        break  # выход из цикла, если угадали
    elif number > predict:
        print(f"Угадываемое число больше {predict} ")
    else:
        print(f"Угадываемое число меньше {predict} ")

print(f"Вы угадали число {number} за {count} попыток.")
