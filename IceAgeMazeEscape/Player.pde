// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Player Class
// Author = Joseph Manfredi Cameron
// This class represents the player's character in the maze

final class Player {
  
  // Player Speed
  private static final int PLAYER_SPEED = 1;
  
  PVector position;
  PVector velocity;
  
  boolean movingUp;
  boolean movingDown;
  boolean movingLeft;
  boolean movingRight;
  
  PImage currentImage;
  
  boolean gemPower;
  
  Player(int x, int y, float xVel, float yVel) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
    currentImage = playerImages[0];
    gemPower = false;
  }
  
  void draw() {
    if (gemPower) {
      fill(0,255,0);
      rect(position.x, position.y, 10, 10);
      image(currentImage, position.x, position.y);
    } else {
      image(currentImage, position.x, position.y);
    }
  }
  
  void integrate() {
    
    if (movingUp) {
      velocity.y = -PLAYER_SPEED;
      currentImage = playerImages[1];
    } else if (movingDown) {
      velocity.y = PLAYER_SPEED;
      currentImage = playerImages[0];
    } else {
      if ((velocity.y >= 0.01) || (velocity.y <= 0.01)) {
        velocity.y = (velocity.y/(2/getFrictionCoefficient(temperature)));
      } else {
        velocity.y = 0;
      }
    }
    
    if (movingLeft) {
      velocity.x = -PLAYER_SPEED;
      currentImage = playerImages[2];
    } else if (movingRight) {
      velocity.x = PLAYER_SPEED;
      currentImage = playerImages[3];
    } else {
      if ((velocity.x >= 0.01) || (velocity.x <= 0.01)) {
        velocity.x = (velocity.x/(2/getFrictionCoefficient(temperature)));
      } else {
        velocity.x = 0;
      }
    }
    
    // -----------------------
    // Screen Edge Collisions
    
    // Screen Right Edge Collision
    if ((velocity.x > 0) && (position.x >= 1190)) {
      position.x = 1190;
      velocity.x = 0;
    }
    
    // Screen Left Edge Collision
    if ((velocity.x < 0) && (position.x <= 0)) {
      position.x = 0;
      velocity.x = 0;
    }
    
    // Screen Lower Edge Collision
    if ((velocity.y > 0) && (position.y >= 660)) {
      position.y = 660;
      velocity.y = 0;
    }
    
    // Screen Upper Edge Collision
    if ((velocity.y < 0) && (position.y <= 0)) {
      position.y = 0;
      velocity.y = 0;
    }
    // -----------------------
    // Map Wall Collisions
    // Get player's current tile
    int currentTileX = (int) (position.x/25);
    int currentTileY = (int) (position.y/25);
    
    // In case the character ends up on the edges
    if (currentTileY == 27) {
      currentTileY = 26;
    }
    if (currentTileX == 48) {
      currentTileX = 47;
    }
    
    // Moving left and not on the left border
    if ((velocity.x < 0) && (currentTileX > 0)) {
      if (maze.getMazeCells()[currentTileX - 1][currentTileY].isWall()) {
        if (position.x <= ((currentTileX*25)+1)) {
          position.x = ((currentTileX*25)+12);
          velocity.x = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    }
    
    // Moving right and not on the right border
    if ((velocity.x > 0) && (currentTileX < 47)) {
      if (maze.getMazeCells()[currentTileX + 1][currentTileY].isWall()) {
        if (position.x >= ((currentTileX*25)+17)) {
          position.x = ((currentTileX*25)+12);
          velocity.x = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    }
    
    // Moving up and not on the upper border
    if ((velocity.y < 0) && (currentTileY > 0)) {
      if (maze.getMazeCells()[currentTileX][currentTileY - 1].isWall()) {
        if (position.y <= ((currentTileY*25)+1)) {
          position.y = ((currentTileY*25)+12);
          velocity.y = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    }
    
    // Moving down and not on the lower border
    if ((velocity.y > 0) && (currentTileY < 26)) {
      if (maze.getMazeCells()[currentTileX][currentTileY + 1].isWall()) {
        if (position.y >= ((currentTileY*25)+17)) {
          position.y = ((currentTileY*25)+12);
          velocity.y = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    }
    
    // Also check diagonal walls
    // Moving up and left, and not on the upper border or left border
    // Check top-left walls
    if ((velocity.x < 0) && (velocity.y < 0) && (currentTileX > 0) && (currentTileY > 0)) {
      if (maze.getMazeCells()[currentTileX - 1][currentTileY - 1].isWall()) {
        if ((position.x <= ((currentTileX*25)+1)) && (position.y <= ((currentTileY*25)+1))) {
          position.x = ((currentTileX*25)+12);
          velocity.x = 0;
          position.y = ((currentTileY*25)+12);
          velocity.y = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    } else if ((velocity.x < 0) && (velocity.y > 0) && (currentTileX > 0) && (currentTileY < 26)) {
      // Moving down and left, and not on the lower border or left border
      // Check lower-left walls
      if (maze.getMazeCells()[currentTileX - 1][currentTileY + 1].isWall()) {
        if ((position.x <= ((currentTileX*25)+1)) && (position.y >= ((currentTileY*25)+17))) {
          position.x = ((currentTileX*25)+12);
          velocity.x = 0;
          position.y = ((currentTileY*25)+12);
          velocity.y = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    } else if ((velocity.x > 0) && (velocity.y < 0) && (currentTileX < 47) && (currentTileY > 0)) {
      // Moving up and right, and not on the upper border or right border
      // Check upper-right walls
      if (maze.getMazeCells()[currentTileX + 1][currentTileY - 1].isWall()) {
        if ((position.x >= ((currentTileX*25)+17)) && (position.y <= ((currentTileY*25)+1))) {
          position.x = ((currentTileX*25)+12);
          velocity.x = 0;
          position.y = ((currentTileY*25)+12);
          velocity.y = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    } else if ((velocity.x > 0) && (velocity.y > 0) && (currentTileX < 47) && (currentTileY < 26)) {
      // Moving down and right, and not on the lower border or right border
      // Check lower-right walls
      if (maze.getMazeCells()[currentTileX + 1][currentTileY + 1].isWall()) {
        if ((position.x >= ((currentTileX*25)+17)) && (position.y >= ((currentTileY*25)+17))) {
          position.x = ((currentTileX*25)+12);
          velocity.x = 0;
          position.y = ((currentTileY*25)+12);
          velocity.y = 0;
          // Also decrease player health
          playerHealth = playerHealth - 5;
          // Trigger ow audio sample
          owSample.trigger();
        }
      }
    }
    
    // ------------------------------
    
    position.add(velocity);
    
  }
  
  void moveUp() {
    movingUp = true;
  }
  
  void moveDown() {
    movingDown = true;
  }
  
  void moveLeft() {
    movingLeft = true;
  }
  
  void moveRight() {
    movingRight = true;
  }
  
  void stopUp() {
    movingUp = false;
  }
  
  void stopDown() {
    movingDown = false;
  }
  
  void stopLeft() {
    movingLeft = false;
  }
  
  void stopRight() {
    movingRight = false;
  }
  
  boolean isGemPower() {
    return gemPower;
  }
  
  void grantGemPower() {
    gemPower = true;
  }
  
  void stopGemPower() {
    gemPower = false;
  }
  
}
