// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Snack Class
// Author = Joseph Manfredi Cameron
// This class represents a snack object in the maze

final class Snack {
  
  int mazeX, mazeY;
  boolean eaten;
  
  Snack(int x, int y) {
    mazeX = x;
    mazeY = y;
    eaten = false;
  }
  
  void draw() {
    image(snackImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
  }
  
  void eatSnack() {
    eaten = true;
  }
  
  boolean isEaten() {
    return eaten;
  }
  
}
