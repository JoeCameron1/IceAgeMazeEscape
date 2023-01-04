// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Trophy Class
// Author = Joseph Manfredi Cameron
// This class represents a trophy object in the maze

final class Trophy {
  
  int mazeX, mazeY;
  boolean gemProtected;
  
  Trophy(int x, int y) {
    mazeX = x;
    mazeY = y;
    int protectionChance = (int) random(1, 4); // 1 in 3 chance of protected trophy
    if (protectionChance == 3) {
      gemProtected = true;
    } else {
      gemProtected = false;
    }
  }
  
  void draw() {
    if (gemProtected) {
      image(gemTrophyImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
    } else {
      image(trophyImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
    }
  }
  
  boolean isGemProtected() {
    return gemProtected;
  }
  
}
