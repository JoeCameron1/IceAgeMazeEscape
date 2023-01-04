// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape PowerUp Class
// Author = Joseph Manfredi Cameron
// This class represents a power-up object in the maze

final class PowerUp {
  
  int mazeX, mazeY;
  int powerUpType;
  boolean collected;
  boolean gemProtected;
  
  PowerUp(int x, int y) {
    mazeX = x;
    mazeY = y;
    powerUpType = (int) random(1, 3); // There are 2 power-ups
    collected = false;
    int protectionChance = (int) random(1, 4); // 1 in 3 chance of protected power up
    if (protectionChance == 3) {
      gemProtected = true;
    } else {
      gemProtected = false;
    }
  }
  
  void draw() {
    if (gemProtected) {
      if (powerUpType == 1) {
        // Destroy all enemies in the maze
        image(gemEnemyPowerUpImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
      } else if (powerUpType == 2) {
        // Display shortest path to trophy
        image(gemPathPowerUpImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
      }
    } else {
      if (powerUpType == 1) {
        // Destroy all enemies in the maze
        image(enemyPowerUpImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
      } else if (powerUpType == 2) {
        // Display shortest path to trophy
        image(pathPowerUpImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
      }
    }
  }
  
  void collectPowerUp() {
    collected = true;
  }
  
  boolean isCollected() {
    return collected;
  }
  
  boolean isGemProtected() {
    return gemProtected;
  }
  
}
