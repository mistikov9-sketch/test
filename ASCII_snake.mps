# ASCII_snake.mps
import os
import sys
import random
import time
import json

MYSTIC_ROOT = os.path.abspath("MysticOS")

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def draw_board(board, score, high_score):
    clear_screen()
    print("=" * 40)
    print(f"ASCII SNAKE v1.0 | Счёт: {score} | Рекорд: {high_score}")
    print("=" * 40)
    for row in board:
        print(''.join(row))
    print("=" * 40)
    print("Управление: WASD | Выход: Q | Пауза: P")

def load_scores():
    scores_file = os.path.join(MYSTIC_ROOT, "system", "data", "Games", "ASCIISnake", "scores.mdcmps")
    if os.path.exists(scores_file):
        try:
            with open(scores_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        except:
            pass
    return {"high_score": 0, "games_played": 0}

def save_scores(high_score, games_played):
    scores_file = os.path.join(MYSTIC_ROOT, "system", "data", "Games", "ASCIISnake", "scores.mdcmps")
    os.makedirs(os.path.dirname(scores_file), exist_ok=True)
    with open(scores_file, 'w', encoding='utf-8') as f:
        json.dump({"high_score": high_score, "games_played": games_played}, f, indent=2)

def main():
    width, height = 20, 15
    scores = load_scores()
    high_score = scores.get("high_score", 0)
    games_played = scores.get("games_played", 0)
    
    while True:
        board = [['.' for _ in range(width)] for _ in range(height)]
        
        # Змейка
        snake = [(height//2, width//2)]
        direction = (0, 1)  # вправо
        
        # Еда
        food = (random.randint(0, height-1), random.randint(0, width-1))
        board[food[0]][food[1]] = '@'
        
        score = 0
        game_over = False
        paused = False
        
        print("ASCII Snake загружается...")
        time.sleep(1)
        
        while not game_over:
            if not paused:
                # Рисуем змейку
                for y, x in snake:
                    if 0 <= y < height and 0 <= x < width:
                        board[y][x] = 'O'
                
                # Рисуем голову
                head_y, head_x = snake[0]
                if 0 <= head_y < height and 0 <= head_x < width:
                    board[head_y][head_x] = '0'
                
                draw_board(board, score, high_score)
                
                # Очищаем клетки от старой змейки
                for y, x in snake:
                    if 0 <= y < height and 0 <= x < width:
                        board[y][x] = '.'
            
            # Управление
            try:
                import msvcrt
                if msvcrt.kbhit():
                    key = msvcrt.getch().decode('utf-8', errors='ignore').lower()
                else:
                    key = ''
            except:
                # Для Linux/Mac
                import select
                import tty
                import termios
                
                def getch():
                    fd = sys.stdin.fileno()
                    old_settings = termios.tcgetattr(fd)
                    try:
                        tty.setraw(sys.stdin.fileno())
                        ch = sys.stdin.read(1)
                    finally:
                        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
                    return ch
                
                key = getch().lower() if select.select([sys.stdin], [], [], 0.01)[0] else ''
            
            if key == 'q':
                print("\nВыход из игры...")
                time.sleep(1)
                return
            elif key == 'p':
                paused = not paused
                if paused:
                    print("\n=== ПАУЗА ===")
                else:
                    print("\n=== ПРОДОЛЖАЕМ ===")
                time.sleep(0.5)
                continue
            elif key == 'w' or key == 'ц':
                direction = (-1, 0)
            elif key == 's' or key == 'ы':
                direction = (1, 0)
            elif key == 'a' or key == 'ф':
                direction = (0, -1)
            elif key == 'd' or key == 'в':
                direction = (0, 1)
            
            if paused:
                time.sleep(0.1)
                continue
            
            # Двигаем змейку
            head_y, head_x = snake[0]
            new_y = head_y + direction[0]
            new_x = head_x + direction[1]
            
            # Проверка столкновения со стеной
            if new_y < 0 or new_y >= height or new_x < 0 or new_x >= width:
                game_over = True
                break
            
            # Проверка столкновения с собой
            if (new_y, new_x) in snake:
                game_over = True
                break
            
            # Добавляем новую голову
            snake.insert(0, (new_y, new_x))
            
            # Проверка еды
            if (new_y, new_x) == food:
                score += 10
                # Генерируем новую еду, не на змейке
                while True:
                    food = (random.randint(0, height-1), random.randint(0, width-1))
                    if food not in snake:
                        break
                board[food[0]][food[1]] = '@'
            else:
                # Убираем хвост, если не съели еду
                snake.pop()
            
            time.sleep(0.1)
        
        # Конец игры
        games_played += 1
        if score > high_score:
            high_score = score
            print(f"\nНОВЫЙ РЕКОРД: {score}!")
        
        save_scores(high_score, games_played)
        
        clear_screen()
        print("=" * 40)
        print("     GAME OVER!")
        print("=" * 40)
        print(f"Ваш счёт: {score}")
        print(f"Рекорд: {high_score}")
        print(f"Сыграно игр: {games_played}")
        print("=" * 40)
        print("\n1. Новая игра")
        print("2. Выход в меню")
        
        choice = input("\nВыберите: ")
        if choice != '1':
            break

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nИгра прервана.")
    except Exception as e:
        print(f"\nОшибка: {e}")
