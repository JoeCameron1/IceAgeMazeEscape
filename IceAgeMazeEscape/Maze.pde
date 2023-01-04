// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Maze Class
// Author = Joseph Manfredi Cameron
// This class represents a maze map

final class Maze {
  
  // Represents an entire maze
  private final MazeCell[][] entireMaze;

  public Maze(int rows, int columns) {
    entireMaze = new MazeCell[rows][columns];
    for(int row=0; row < entireMaze.length; row++) {
      for(int col=0; col < entireMaze[row].length; col++) {
        MazeCell mazeCell = new MazeCell(row, col);
        entireMaze[row][col] = mazeCell;
      }
    }
  }

  // Return all maze cells
  public MazeCell[][] getMazeCells() {
    return entireMaze;
  }
  
  // Return all cells where objects can be placed
  public ArrayList<MazeCell> getValidCells() {
    ArrayList<MazeCell> validCells = new ArrayList<MazeCell>();
    //Find all maze cells that are not walls or occupied
    for(int i = 0; i < entireMaze.length; i++) {
      for(int j = 0; j < entireMaze[0].length; j++) {
        if ((!entireMaze[i][j].isWall()) && (!entireMaze[i][j].isOccupied())) {
          validCells.add(entireMaze[i][j]);
        }
      }
    }
    return validCells;
  }
  
  // Return all cells that are searchable with A* search
  public ArrayList<MazeCell> getSearchableCells() {
    ArrayList<MazeCell> validCells = new ArrayList<MazeCell>();
    //Find all maze cells that are not walls
    for(int i = 0; i < entireMaze.length; i++) {
      for(int j = 0; j < entireMaze[0].length; j++) {
        if ((!entireMaze[i][j].isWall())) {
          validCells.add(entireMaze[i][j]);
        }
      }
    }
    return validCells;
  }
  
  void draw() {
    for (int x = 0; x < ROWS; x++) {
      for (int y = 0; y < COLUMNS; y++) {
        if (entireMaze[x][y].isWall()) {
          fill(0);
          rect(x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE);
        }
      }
    }
  }
  
}
