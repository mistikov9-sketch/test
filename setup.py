#!/usr/bin/env python
# setup.py
import os
import time

def main():
    print("=" * 50)
    print("НАСТРОЙКА ASCII SNAKE")
    print("=" * 50)
    
    print("\nДобро пожаловать в ASCII Snake!")
    print("\nОсобенности игры:")
    print("• Классическая змейка в ASCII-графике")
    print("• Сохранение рекордов")
    print("• Простое управление (WASD)")
    print("• Пауза (P) и выход (Q)")
    
    print("\nУправление:")
    print("  W / ↑    - Вверх")
    print("  S / ↓    - Вниз")
    print("  A / ←    - Влево")
    print("  D / →    - Вправо")
    print("  P        - Пауза")
    print("  Q        - Выход")
    
    print("\nЦель игры:")
    print("Собирайте '@' чтобы расти и набирать очки.")
    print("Избегайте столкновений со стенами и самим собой!")
    
    print("\nДля запуска игры используйте команду:")
    print("  run ASCII_snake.mps")
    
    print("\n" + "=" * 50)
    input("\nНажмите Enter чтобы завершить установку...")
    print("\nУстановка завершена! Приятной игры!")

if __name__ == "__main__":
    main()
