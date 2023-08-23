from game_of_life import run_game

def main():
    generations = 500
    height = 50
    width = 100

    run_game(height, width, generations)

if __name__ == "__main__":
    main()
