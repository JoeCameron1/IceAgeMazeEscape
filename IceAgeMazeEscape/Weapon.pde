// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Weapon Class
// Author = Joseph Manfredi Cameron
// This class represents a weapon object in the maze

final class Weapon {
  
  int mazeX, mazeY;
  boolean pickedUp;
  boolean gemProtected;
  
  Weapon(int x, int y) {
    mazeX = x;
    mazeY = y;
    pickedUp = false;
    int protectionChance = (int) random(1, 4); // 1 in 3 chance of protected weapon
    if (protectionChance == 3) {
      gemProtected = true;
    } else {
      gemProtected = false;
    }
  }
  
  void draw() {
    if (gemProtected) {
      image(gemWeaponImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
    } else {
      image(weaponImage, (mazeX*CELL_SIZE)+2, (mazeY*CELL_SIZE)+2);
    }
  }
  
  void pickupWeapon() {
    pickedUp = true;
  }
  
  boolean isPickedUp() {
    return pickedUp;
  }
  
  boolean isGemProtected() {
    return gemProtected;
  }
  
}
