// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape MazeConstructor Class
// Author = Joseph Manfredi Cameron
// This class is responsible for constructing a maze

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.HashSet;

final class MazeConstructor {
  
  private final MazeCell[][] cells;
  private final Random random;
  private final int[][] DIRECTIONS = {
    { 0 ,-2}, // North
    { 0 , 2}, // South
    { 2 , 0}, // East
    {-2 , 0}, // West
  };

  public MazeConstructor(MazeCell[][] cells) {
    this.cells = cells;
    random = new Random();
  }

  // Construct the maze using a method inspired by Prim's Algorithm (https://en.wikipedia.org/wiki/Maze_generation_algorithm)
  void constructMaze() {

    //Start with a grid full of maze cells that are walls
    for(int i = 0; i < cells.length; i++){
      for(int j = 0; j < cells[0].length ; j++){
        cells[i][j].setWall(true);
      }
    }

    //Pick a random cell
    int x = random.nextInt(cells.length);
    int y = random.nextInt(cells[0].length);
      
    // Get starting point for the player to be positioned in
    mazeStartX = x;
    mazeStartY = y;

    // Set this initial cell to the first valid cell
    cells[x][y].setWall(false);
      
    // Get adjacent cells
    Set<MazeCell> adjacentCells = new HashSet<>(getAdjacentCells(cells[x][y], true));
    // Keep getting and looking at cells until they have all been visited
    while (!adjacentCells.isEmpty()){
      // Select a random cell from the adjacent cells
      MazeCell randomAdjacentCell = adjacentCells.stream().skip(random.nextInt(adjacentCells.size())).findFirst().orElse(null);
      // Retrieve the adjacent non-wall cells of the random adjacent cell above
      List<MazeCell> adjacentNonWallCells = getAdjacentCells(randomAdjacentCell, false);
      // Make a route to the adjacent non-wall cells
      if(!adjacentNonWallCells.isEmpty()) {
        MazeCell routeCell = adjacentNonWallCells.get(random.nextInt(adjacentNonWallCells.size()));
        int connectingRow = (routeCell.getRow() + randomAdjacentCell.getRow())/2;
        int connectingCol = (routeCell.getColumn() + randomAdjacentCell.getColumn())/2;
        randomAdjacentCell.setWall(false);
        cells[connectingRow][connectingCol].setWall(false);
        routeCell.setWall(false);
      }
      // Get more adjacent cells for other cells around the maze to continue the search
      adjacentCells.addAll(getAdjacentCells(randomAdjacentCell, true));
      // Finally, remove this current cell as it has been visited
      adjacentCells.remove(randomAdjacentCell);
    }
  }

  // Retrieves all valid surrounding cells
  private List<MazeCell> getAdjacentCells(MazeCell cell, boolean isWall) {
    List<MazeCell> adjacentCellList = new ArrayList<>();
    for (int[] direction : DIRECTIONS) {
      int newRow = cell.getRow() + direction[0];
      int newCol = cell.getColumn() + direction[1];
      if (isValidPosition(newRow, newCol) && cells[newRow][newCol].isWall() == isWall) {
        adjacentCellList.add(cells[newRow][newCol]);
      }
    }
    return adjacentCellList;
  }
    
  // Returns true if the row and column values equal a valid position
  private boolean isValidPosition(int row, int col) {
    return ((row >= 0) && (row < cells.length) && (col >= 0) && (col < cells[0].length));
  }
  
}
