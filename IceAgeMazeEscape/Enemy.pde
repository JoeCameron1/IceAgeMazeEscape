// Ice Age Maze Escaper - Final Game Practical Video Games CS4303
// Ice Age Maze Escape Enemy Class
// Author = Joseph Manfredi Cameron
// This class represents an enemy character with AI

final class Enemy {
  
  PVector position;
  PVector velocity;
  PVector linear;
  
  int enemyWidth;
  int enemyHeight;
  
  boolean destroyed; // Is this enemy destroyed? True = Yes. False = No.
  boolean attacking; // If the enemy can see or feel a close-by player, this is true
  
  // A* Stuff
  boolean findingPath = false;
  boolean pathFound = false;
  ArrayList<AStarNode> result;
  
  // For wandering
  int wanderingSquare, wanderX, wanderY;
  
  Enemy(int x, int y, int xVel, int yVel) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
    linear = new PVector(0, 0);
    enemyWidth = 10;
    enemyHeight = 10;
    destroyed = false;
    attacking = false;
    result = new ArrayList<AStarNode>();
    wanderingSquare = (int) random(0, maze.getSearchableCells().size());
    wanderX = ((int) maze.getSearchableCells().get(wanderingSquare).getRow());
    wanderY = ((int) maze.getSearchableCells().get(wanderingSquare).getColumn());
  }
  
  void draw() {
    image(enemyImage, position.x, position.y);
    // TOGGLE COMMENT FOR REPORT FIGURES
    //circle(position.x, position.y, 300);
  }
  
  void integrate(PVector targetPos) {
    
    //-------
    // A* Search
    
    AStarSearch pathFinder = new AStarSearch(maze.getMazeCells());
    ArrayList<AStarNode> thePath = null;
    
    // If things go wrong, we can salvage the situation here
    if (findingPath) {
      return;
    }
    
    pathFound = false;
    findingPath = true;
    
    if (attacking) {
      result = pathFinder.search((int) (position.x/25), (int) (position.y/25), (int) (targetPos.x/25), (int) (targetPos.y/25));
    } else {
      // Wander
      // Only need to wander to the same row or column, this helps preserve 'patrolling' behaviour
      if ((((int) (position.x/25)) != wanderX) && (((int) (position.y/25)) != wanderY)) {
        result = pathFinder.search((int) (position.x/25), (int) (position.y/25), wanderX, wanderY);
      } else {
        wanderingSquare = (int) random(0, maze.getSearchableCells().size());
        wanderX = ((int) maze.getSearchableCells().get(wanderingSquare).getRow());
        wanderY = ((int) maze.getSearchableCells().get(wanderingSquare).getColumn());
        result = pathFinder.search((int) (position.x/25), (int) (position.y/25), wanderX, wanderY);
      }
    }
    
    //if (result != null) {
      Collections.reverse(result);
      thePath = result;
      pathFound = true;
    //}
    
    // Draws the A* Route
    // Useful for visualisation
    //fill(0,0,255);
    //for (AStarNode node: thePath)
    //  rect(node.getRow() * 25, node.getCol() * 25, 5, 5);
    
    findingPath = false;
    
    //-------
    
    // Map Wall Collisions
    
    // Get enemy's current tile
    int currentTileX = (int) (position.x/25);
    int currentTileY = (int) (position.y/25);
    
    // In case the enemy goes to the outer edges
    if (currentTileY == 27) {
      currentTileY = 26;
    }
    if (currentTileX == 48) {
      currentTileX = 47;
    }
    
    // Moving left and not on the left border
    if ((velocity.x < 0) && (currentTileX > 0)) {
      if (maze.getMazeCells()[currentTileX - 1][currentTileY].isWall()) {
        if (position.x <= ((currentTileX*25)+5)) {
          position.x = ((currentTileX*25)+5);
          velocity.x = 1;
        }
      }
    }
    
    // Moving right and not on the right border
    if ((velocity.x > 0) && (currentTileX < 47)) {
      if (maze.getMazeCells()[currentTileX + 1][currentTileY].isWall()) {
        if (position.x >= ((currentTileX*25)+19)) {
          position.x = ((currentTileX*25)+19);
          velocity.x = -1;
        }
      }
    }
    
    // Moving up and not on the upper border
    if ((velocity.y < 0) && (currentTileY > 0)) {
      if (maze.getMazeCells()[currentTileX][currentTileY - 1].isWall()) {
        if (position.y <= ((currentTileY*25)+5)) {
          position.y = ((currentTileY*25)+5);
          velocity.y = 1;
        }
      }
    }
    
    // Moving down and not on the lower border
    if ((velocity.y > 0) && (currentTileY < 26)) {
      if (maze.getMazeCells()[currentTileX][currentTileY + 1].isWall()) {
        if (position.y >= ((currentTileY*25)+19)) {
          position.y = ((currentTileY*25)+19);
          velocity.y = -1;
        }
      }
    }
    
    // Must also check diagonal wall tiles as well
    // This to make sure enemies don't wander into diagonal walls
    
    // Check top left square
    // Moving up and left and not on the upper border or left border
    if ((velocity.x < 0) && (velocity.y < 0) && (currentTileX > 0) && (currentTileY > 0)) {
      if (maze.getMazeCells()[currentTileX - 1][currentTileY - 1].isWall()) {
        if ((position.x <= ((currentTileX*25)+5)) && (position.y <= ((currentTileY*25)+5))) {
          position.x = ((currentTileX*25)+5);
          velocity.x = 1;
          position.y = ((currentTileY*25)+5);
          velocity.y = 1;
        }
      }
    } else if ((velocity.x < 0) && (velocity.y > 0) && (currentTileX > 0) && (currentTileY < 26)) {
      if (maze.getMazeCells()[currentTileX - 1][currentTileY + 1].isWall()) {
        if ((position.x <= ((currentTileX*25)+5)) && (position.y >= ((currentTileY*25)+19))) {
          position.x = ((currentTileX*25)+5);
          velocity.x = 1;
          position.y = ((currentTileY*25)+19);
          velocity.y = -1;
        }
      }
    } else if ((velocity.x > 0) && (velocity.y < 0) && (currentTileX < 47) && (currentTileY > 0)) {
      if (maze.getMazeCells()[currentTileX + 1][currentTileY - 1].isWall()) {
        if ((position.x >= ((currentTileX*25)+19)) && (position.y <= ((currentTileY*25)+5))) {
          position.x = ((currentTileX*25)+19);
          velocity.x = -1;
          position.y = ((currentTileY*25)+5);
          velocity.y = 1;
        }
      }
    } else if ((velocity.x > 0) && (velocity.y > 0) && (currentTileX < 47) && (currentTileY < 26)) {
      if (maze.getMazeCells()[currentTileX + 1][currentTileY + 1].isWall()) {
        if ((position.x >= ((currentTileX*25)+19)) && (position.y >= ((currentTileY*25)+19))) {
          position.x = ((currentTileX*25)+19);
          velocity.x = -1;
          position.y = ((currentTileY*25)+19);
          velocity.y = -1;
        }
      }
    }
    
    //-------
    
    position.add(velocity);
    
    if (thePath.size() >= 3) {
      linear.x = (thePath.get(2).getRow() * 25) - position.x;
      linear.y = (thePath.get(2).getCol() * 25) - position.y;
    } else if ((thePath.size() < 3) && (thePath.size() > 1)) {
      linear.x = (thePath.get(1).getRow() * 25) - position.x;
      linear.y = (thePath.get(1).getCol() * 25) - position.y;
    } else if (thePath.size() <= 1) {
      linear.x = (thePath.get(0).getRow() * 25) - position.x;
      linear.y = (thePath.get(0).getCol() * 25) - position.y;
    }
    
    linear.normalize();
    linear.mult(0.1f);
    velocity.add(linear);
    
    if (velocity.mag() > 1f) {
      velocity.normalize();
      velocity.mult(1f);
    }
    
  }
  
  void destroyEnemy() {
    destroyed = true;
  }
  
  boolean isDestroyed() {
    return destroyed;
  }
  
  void attackPlayer() {
    attacking = true;
  }
  
}
