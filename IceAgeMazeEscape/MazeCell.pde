// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape MazeCell Class
// Author = Joseph Manfredi Cameron
// This class represents a single cell (square) within a maze

import java.beans.PropertyChangeSupport;

final class MazeCell {
  
  private final int row, column;
  private boolean isWall;
  boolean isOccupied;
  // Property change support used for updates
  private PropertyChangeSupport pcs;

  MazeCell(int row, int column)  {
    this(row, column, false);
  }

  MazeCell(int row, int column, boolean isWall) {
    this.row = row;
    this.column = column;
    this.isWall = isWall;
    isOccupied = false;
  }

  @Override
  public boolean equals(Object obj) {
    if(!(obj instanceof MazeCell)) {
      return false;
    }
    MazeCell otherCell = (MazeCell) obj;
    return row == otherCell.getRow() && column == otherCell.getColumn();
  }

  public void setPropertChangeSupport(PropertyChangeSupport pcs) {
    this.pcs = pcs;
  }

  private void firePropertyChange(String name, Object oldValue, Object newValue) {
    if(pcs != null) {
      pcs.firePropertyChange(name, oldValue, newValue);
    }
  }

  // Returns whether this cell is a wall or not
  public boolean isWall() {
    return isWall;
  }

  /// Make cell a wall
  public void setWall(boolean isWall) {
      Object old = this.isWall;
      this.isWall = isWall;
      firePropertyChange("Wall", old, isWall);
  }

  int getRow() {
    return row;
  }

  int getColumn() {
    return column;
  }

  @Override
  public int hashCode() {
    return 17*row + 31*column;
  }
  
  // Occupy the cell to indicate that something is already there
  void occupyCell() {
    isOccupied = true;
  }
  
  // Does the cell already have something on it?
  boolean isOccupied() {
    return isOccupied;
  }
  
}
