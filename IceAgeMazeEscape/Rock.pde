// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Rock Class
// Author = Joseph Manfredi Cameron
// This class represents a projectile rock object in the maze

final class Rock {
  
  PVector position;
  PVector velocity;
  
  Rock(int x, int y, float xVel, float yVel) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
  }
  
  void draw() {
    fill(128);
    ellipse(position.x, position.y, 5, 5);
  }
  
  void integrate() {
    position.add(velocity);
  }
  
}
