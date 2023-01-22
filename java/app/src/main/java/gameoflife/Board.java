package gameoflife;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Board {
    private List<Boolean> cells;
    private int height;
    private int width;
    
    public Board(int height, int width) {
        this.height = height;
        this.width = width;
        this.cells = new ArrayList();

        Random random = new Random();
        for (int i = 0; i < this.height * this.width; i++) {
            this.cells.add(random.nextBoolean());
        }
    }

    public Board(Board other) {
        this.height = other.height;
        this.width = other.width;
        this.cells = new ArrayList(other.cells);
    }

    public int getHeight() {
        return this.height;
    }

    public int getWidth() {
        return this.width;
    }

    public boolean getCell(int row, int col) {
        if (row >= 0 && row < this.height && col >= 0 && col < this.width) {
            return this.cells.get((row * this.width) + col);
        }
        else {
            return false;
        }
    }

    public void setCell(int index, boolean value) {
        this.cells.set(index, value);
    }

    public void Draw() {
        for (var i = 0; i < this.height; i++) {
            for (var j = 0; j < this.width; j++) {
                if (this.cells.get((i * this.width) + j)) {
                    System.out.print("██");
                }
                else {
                    System.out.print("  ");
                }
            }
            System.out.println();
        }
    }
}