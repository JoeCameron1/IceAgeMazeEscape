// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Gem Class
// Author = Joseph Manfredi Cameron
// This class represents a gem object in the maze

final class Gem {
  
  int mazeX, mazeY;
  boolean pickedUp;
  
  Gem(int x, int y) {
    mazeX = x;
    mazeY = y;
    pickedUp = false;
  }
  
  void draw() {
    image(gemImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
  }
  
  void pickupGem() {
    pickedUp = true;
  }
  
  boolean isPickedUp() {
    return pickedUp;
  }
  
}
