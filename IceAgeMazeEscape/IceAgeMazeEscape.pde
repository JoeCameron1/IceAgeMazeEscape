// Ice Age Maze Escape
// CS4303 Video Games Final Game Practical
// Author = Joseph Manfredi Cameron

// Main Game File

// -------------------
// IMPORT STATEMENTS
import java.util.Iterator;
import ddf.minim.*; // Minim library
// -------------------
// VARIABLES

// Audio with the Minim library
Minim minim;
AudioSample rockThrowSample;
AudioSample rockImpactSample;
AudioSample gameOverSample;
AudioSample newMazeSample;
AudioSample healthDamageSample;
AudioSample owSample;
AudioSample playerYesSample;
AudioSample collectGemSample;
AudioSample collectTrophySample;
AudioSample collectPowerUpSample;
AudioSample gemPowerSample;
AudioSample collectWeaponSample;
AudioSample showPathSample;
AudioSample explosionSample;
AudioPlayer mainMenuMusic;

// Menu Images
PImage gameMainMenuImage;
PImage gameControlsMenuImage;
PImage gameSummaryMenuImage;
PImage gameOverMenuImage;

// Game State Booleans
boolean gameMainMenu;
boolean gameControls;
boolean gameActive;
boolean gameSummary;
boolean gameOver;
int temperature;

// Player
Player player;
int playerHealth;
int playerHealthRate;
int playerCurrentFrame;
PImage playerImages[];
int trophiesCollected;
int weaponStash;
int inventory[];
int playerScore;

// Maze
private static final int ROWS = 48, COLUMNS = 27, CELL_SIZE = 25;
Maze maze;
int mazeStartX;
int mazeStartY;

// Trophy
Trophy trophy;
int trophyX;
int trophyY;
PImage trophyImage;
PImage gemTrophyImage;

// Snacks
ArrayList<Snack> snacks;
PImage snackImage;

// Weapons
ArrayList<Weapon> weapons;
PImage weaponImage;
PImage gemWeaponImage;

// Rocks
ArrayList<Rock> rocks;

// Enemies
ArrayList<Enemy> enemies;
PImage enemyImage;

// Gems
ArrayList<Gem> gems;
PImage gemImage;
int gemPowerTimer;

// Power Ups
ArrayList<PowerUp> powerUps;
PImage enemyPowerUpImage;
PImage pathPowerUpImage;
PImage gemEnemyPowerUpImage;
PImage gemPathPowerUpImage;
int pathPowerUpTimer;
boolean showPath;
PowerUp powerUpToAdd;

// Boolean for special game over message
boolean tipMessage;

// -------------------

void setup() {
  
  // Setup the screen
  size(1200, 725);
  
  // Setup Game State
  gameMainMenu = true;
  gameControls = false;
  gameActive = false;
  gameSummary = false;
  gameOver = false;
  
  // Setup Audio
  minim = new Minim(this);
  rockThrowSample = minim.loadSample("rockThrow.aif");
  rockImpactSample = minim.loadSample("rockImpact.aif");
  gameOverSample = minim.loadSample("gameOver.wav");
  newMazeSample = minim.loadSample("newMaze.aif");
  healthDamageSample = minim.loadSample("playerHealthDamage.wav");
  owSample = minim.loadSample("owSample.wav");
  playerYesSample = minim.loadSample("playerYes.wav");
  collectGemSample = minim.loadSample("collectGem.aif");
  collectTrophySample = minim.loadSample("collectTrophy.wav");
  collectPowerUpSample = minim.loadSample("collectPowerUp.aif");
  gemPowerSample = minim.loadSample("gemPower.aif");
  collectWeaponSample = minim.loadSample("collectWeapon.aif");
  showPathSample = minim.loadSample("showPath.wav");
  explosionSample = minim.loadSample("explosion.aif");
  mainMenuMusic = minim.loadFile("mainMenuMusic.aif");
  mainMenuMusic.loop();
  
  // Setup Images
  playerImages = new PImage[4];
  playerImages[0] = loadImage("assets/PlayerSprite/PlayerFront.png");
  playerImages[0].resize(10,10);
  playerImages[1] = loadImage("assets/PlayerSprite/PlayerBack.png");
  playerImages[1].resize(10,10);
  playerImages[2] = loadImage("assets/PlayerSprite/PlayerLeft.png");
  playerImages[2].resize(10,10);
  playerImages[3] = loadImage("assets/PlayerSprite/PlayerRight.png");
  playerImages[3].resize(10,10);
  
  trophyImage = new PImage();
  trophyImage = loadImage("assets/trophy.png");
  trophyImage.resize(20,20);
  
  gemTrophyImage = new PImage();
  gemTrophyImage = loadImage("assets/gemTrophy.png");
  gemTrophyImage.resize(20,20);
  
  snackImage = new PImage();
  snackImage = loadImage("assets/rasp.png");
  snackImage.resize(20,20);
  
  weaponImage = new PImage();
  weaponImage = loadImage("assets/weapon.png");
  weaponImage.resize(20,20);
  
  gemWeaponImage = new PImage();
  gemWeaponImage = loadImage("assets/gemWeapon.png");
  gemWeaponImage.resize(20,20);
  
  enemyImage = new PImage();
  enemyImage = loadImage("assets/enemy.png");
  enemyImage.resize(10,10);
  
  gemImage = new PImage();
  gemImage = loadImage("assets/gem.png");
  gemImage.resize(20,20);
  
  enemyPowerUpImage = new PImage();
  enemyPowerUpImage = loadImage("assets/enemyPowerUp.png");
  enemyPowerUpImage.resize(20,20);
  
  gemEnemyPowerUpImage = new PImage();
  gemEnemyPowerUpImage = loadImage("assets/gemEnemyPowerUp.png");
  gemEnemyPowerUpImage.resize(20,20);
  
  pathPowerUpImage = new PImage();
  pathPowerUpImage = loadImage("assets/pathPowerUp.png");
  pathPowerUpImage.resize(20,20);
  
  gemPathPowerUpImage = new PImage();
  gemPathPowerUpImage = loadImage("assets/gemPathPowerUp.png");
  gemPathPowerUpImage.resize(20,20);
  
  gameMainMenuImage = new PImage();
  gameMainMenuImage = loadImage("assets/menus/mainMenuScreen.png");
  
  gameControlsMenuImage = new PImage();
  gameControlsMenuImage = loadImage("assets/menus/gameControls.png");
  
  gameSummaryMenuImage = new PImage();
  gameSummaryMenuImage = loadImage("assets/menus/gameSummaryScreen.png");
  
  gameOverMenuImage = new PImage();
  gameOverMenuImage = loadImage("assets/menus/gameOverScreen.png");
}

// Here to properly shutdown audio
void stop() {
  mainMenuMusic.close();
  minim.stop();
  super.stop();
}

void draw() {
  
  if (gameMainMenu) {
    // MAIN MENU
    background(0);
    image(gameMainMenuImage, 0, 0);
  } else if (gameControls) {
    // GAME CONTROLS
    background(0);
    image(gameControlsMenuImage, 0, 0);
  } else if (gameActive) {
    // GAMEPLAY
    background(255);
    // -----------------------------------------------
    // Check for GameOver
    if (playerHealth <= 0) {
      // GET GAME OVER
      showGameOver();
    }
    
    // Check for no available gems if there is a protected trophy
    // If so, convey a tip message in the game over screen to help the player
    if ((trophy.isGemProtected()) && (gems.size() == 0) && (!player.isGemPower()) && (isPlayerGemInventoryEmpty())) {
      // GET GAME OVER
      tipMessage = true;
      showGameOver();
    }
    
    // Reduce gem power timer if player is using gem power
    // Else, stop the player's gem power when the timer hits zero
    if (gemPowerTimer > 0) {
      gemPowerTimer--;
    } else {
      player.stopGemPower();
    }
    
    // Reduce path power up timer if path is shown
    // Else, stop showing path when timer hits zero
    if (pathPowerUpTimer > 0) {
      pathPowerUpTimer--;
    } else {
      showPath = false;
    }
    // -----------------------------------------------
    // Maze
    maze.draw();
    // -----------------------------------------------
    // Show Path Power Up
    if (showPath) {
      AStarSearch pathFinder = new AStarSearch(maze.getMazeCells());
      ArrayList<AStarNode> thePath = pathFinder.search((int) (player.position.x/25), (int) (player.position.y/25), trophy.mazeX, trophy.mazeY);
      fill(0,0,255);
      for (AStarNode node: thePath)
        rect((node.getRow() * 25)+12, (node.getCol() * 25)+12, 5, 5);
    }
    // -----------------------------------------------
    // Trophy
    trophy.draw();
    if (isPlayerTrophyCollision()) {
      trophiesCollected++;
      getCollectTrophyPoints(); // Get points for collecting a trophy
      showGameSummary();
    }
    // -----------------------------------------------
    // Snacks
    Iterator snackIter = snacks.iterator();
    while (snackIter.hasNext()) {
      Snack snack = (Snack) snackIter.next();
      // Remove snacks that have been eaten
      if (snack.isEaten()) {
        snackIter.remove();
      }
      snack.draw();
    }
    // -----------------------------------------------
    // Gems
    Iterator gemIter = gems.iterator();
    while (gemIter.hasNext()) {
      Gem gem = (Gem) gemIter.next();
      // Remove gems that have been picked up
      if (gem.isPickedUp()) {
        gemIter.remove();
      }
      gem.draw();
    }
    // -----------------------------------------------
    // Power Ups
    Iterator puIter = powerUps.iterator();
    while (puIter.hasNext()) {
      PowerUp pu = (PowerUp) puIter.next();
      // Remove Collected Power Ups
      if (pu.isCollected()) {
        puIter.remove();
      }
      pu.draw();
    }
    // -----------------------------------------------
    // Weapons
    Iterator weaponIter = weapons.iterator();
    while (weaponIter.hasNext()) {
      Weapon weapon = (Weapon) weaponIter.next();
      // Remove weapons that have been picked up
      if (weapon.isPickedUp()) {
        weaponIter.remove();
      }
      weapon.draw();
    }
    // -----------------------------------------------
    // Enemies
    Iterator enemyIter = enemies.iterator();
    while (enemyIter.hasNext()) {
      Enemy enemy = (Enemy) enemyIter.next();
      
      //Remove destroyed enemies
      if (enemy.isDestroyed()) {
        enemyIter.remove();
      }
      
      // If an enemy can 'sense' a player, they attack
      if (!enemy.attacking) {
        float distToPlayer = dist(enemy.position.x, enemy.position.y, player.position.x, player.position.y);
        if (distToPlayer < 125) {
          enemy.attackPlayer();
        }
      }
      
      enemy.draw();
      enemy.integrate(player.position);
      
    }
    // -----------------------------------------------
    // Rocks
    Iterator rockIter = rocks.iterator();
    while (rockIter.hasNext()) {
      
      Rock rock = (Rock) rockIter.next();
      rock.draw();
      
      // Remove rocks that leave the screen or collide with enemies
      if (isRockEnemyCollision(rock)) {
        // Trigger Rock Impact Audio
        rockImpactSample.trigger();
        rockIter.remove();
      } else if ((rock.position.x <= 1) || (rock.position.x >= 1199) || (rock.position.y <= 1) || (rock.position.y >= 674)) {
        // Trigger Rock Impact Audio
        rockImpactSample.trigger();
        rockIter.remove();
      }
      
      // -----------
      // Remove projectiles that leave the maze boundaries
      int currentTileX = (int) (rock.position.x/25);
      int currentTileY = (int) (rock.position.y/25);
      
      // Moving left and not on the left border
      if ((rock.velocity.x < 0) && (currentTileX > 0)) {
        if (maze.getMazeCells()[currentTileX - 1][currentTileY].isWall()) {
          if (rock.position.x <= ((currentTileX*25)+3)) {
            // Trigger Rock Impact Audio
            rockImpactSample.trigger();
            rockIter.remove();
          }
        }
      }
      
      // Moving right and not on the right border
      if ((rock.velocity.x > 0) && (currentTileX < 47)) {
        if (maze.getMazeCells()[currentTileX + 1][currentTileY].isWall()) {
          if (rock.position.x >= ((currentTileX*25)+21)) {
            // Trigger Rock Impact Audio
            rockImpactSample.trigger();
            rockIter.remove();
          }
        }
      }
      
      // Moving up and not on the upper border
      if ((rock.velocity.y < 0) && (currentTileY > 0)) {
        if (maze.getMazeCells()[currentTileX][currentTileY - 1].isWall()) {
          if (rock.position.y <= ((currentTileY*25)+3)) {
            // Trigger Rock Impact Audio
            rockImpactSample.trigger();
            rockIter.remove();
          }
        }
      }
      
      // Moving down and not on the lower border
      if ((rock.velocity.y > 0) && (currentTileY < 26)) {
        if (maze.getMazeCells()[currentTileX][currentTileY + 1].isWall()) {
          if (rock.position.y >= ((currentTileY*25)+21)) {
            // Trigger Rock Impact Audio
            rockImpactSample.trigger();
            rockIter.remove();
          }
        }
      }
      // -----------
      
      rock.integrate();
      
    }
    // -----------------------------------------------
    // Player
    if (isPlayerSnackCollision()) {
      increasePlayerHealth(40); // Keeps play well balanced to give 40% health
    }
    if (isPlayerWeaponCollision()) {
      equipPlayerWithWeapon();
    }
    if (isPlayerGemCollision()) {
      equipPlayerWithGem();
    }
    if (isPlayerPowerUpCollision()) {
      equipPlayerWithPowerUp(powerUpToAdd);
    }
    if (isPlayerEnemyCollision()) {
      //Decrease Health
      decreasePlayerHealth(25);
    }
    player.draw();
    player.integrate();
    // Player Health Update
    if (playerCurrentFrame >= playerHealthRate) {
      playerHealth--;
      playerCurrentFrame = 0;
    } else {
      playerCurrentFrame++;
    }
    // -----------------------------------------------
    // Draw Game Statistics at the bottom of the screen
    fill(0, 0, 255);
    rect(0, 675, 1200, 10);
    rect(285, 685, 10, 40);
    rect(525, 685, 10, 40);
    rect(725, 685, 10, 40);
    rect(1090, 685, 10, 40);
    // Temperature and Health
    fill(0);
    stroke(0);
    textSize(24);
    textAlign(LEFT);
    text("Health: ", 5, height-10);
    // Health Bar
    if (playerHealth > 66) {
      fill(0,255,0);
    } else if (playerHealth > 33) {
      fill(255,191,0);
    } else {
      fill(255,0,0);
    }
    //fill(0,255,0);
    noStroke();
    rect(80, height-27, 2*playerHealth, 20);
    // Border Rectangle
    noFill();
    stroke(0);
    rect(80, height-27, 200, 20);
    // Temperature
    fill(0);
    stroke(0);
    text("Current Temp: " + temperature + " C", 300, height-10);
    // Player Score (Points)
    text("Score: " + playerScore, 550, height-10);
    // Inventory (Max 3 Items)
    text("Inventory: " + "1 =       | 2 =       | 3 =", 750, height-10);
    drawInventoryItems();
    // Rocks to Fire (Max 5 Rocks)
    textAlign(RIGHT);
    text("Rocks: " + weaponStash, width-10, height-10);
  } else if (gameSummary) {
    // SUMMARY OF GAME PROGRESS SO FAR
    background(255);
    image(gameSummaryMenuImage, 0, 0);
    fill(255);
    textAlign(CENTER);
    text("Current Total Score = " + playerScore + " Points", width/2, (height/2)-60);
    text("Trophies Collected So Far = " + trophiesCollected, width/2, (height/2)-30);
    text("Current Health: " + playerHealth + "%", width/2, height/2);
    text("Current Rocks in Posession: " + weaponStash, width/2, (height/2)+30);
    text("Next Temperature: " + (temperature-1), width/2, (height/2)+60);
    fill(0);
  } else if (gameOver) {
    // GAME OVER
    background(0);
    image(gameOverMenuImage, 0, 0);
    fill(255);
    textAlign(CENTER);
    // Display this tip if the player died from running out of gems with a gem-protected trophy present
    if (tipMessage) {
      text("You died because there were no longer any gems left to collect the gem-protected trophy.", width/2, 200);
      text("Tip: Always make sure you can use/collect a gem if there is a gem-protected trophy.", width/2, 230);
    }
    text("Total Score = " + playerScore + " Points", width/2, (height/2)-30);
    text("Total Trophies Collected = " + trophiesCollected, width/2, height/2);
    text("Coldest Temperature = " + temperature + " Celsius", width/2, (height/2)+30);
    fill(0);
  }
  
}

// This function draws the inventory items to the stats area
void drawInventoryItems() {
  if (inventory[0] == 1) {
    image(gemImage, 890, height-27);
  } else if (inventory[0] == 2) {
    image(enemyPowerUpImage, 890, height-27);
  } else if (inventory[0] == 3) {
    image(pathPowerUpImage, 890, height-27);
  }
  if (inventory[1] == 1) {
    image(gemImage, 960, height-27);
  } else if (inventory[1] == 2) {
    image(enemyPowerUpImage, 960, height-27);
  } else if (inventory[1] == 3) {
    image(pathPowerUpImage, 960, height-27);
  }
  if (inventory[2] == 1) {
    image(gemImage, 1035, height-27);
  } else if (inventory[2] == 2) {
    image(enemyPowerUpImage, 1035, height-27);
  } else if (inventory[2] == 3) {
    image(pathPowerUpImage, 1035, height-27);
  }
}

void keyPressed() {
  if (gameMainMenu) {
    if (key == ' ') {
      mainMenuMusic.pause(); // Stop main menu music when new game starts
      setupNewGame(); // Set up a new game
    } else if (key == '1') {
      showGameControls();
    }
  } else if (gameControls) {
    if (key == '1') {
      showMainMenu();
    }
  } else if (gameActive) {
    // Move
    if (key == CODED) {
      if (keyCode == UP) {
        if (player.velocity.y > 0.2) {
          player.velocity.y -= 0.1;
        } else {
          player.moveUp();
        }
        //player.moveUp();
      } else if (keyCode == DOWN) {
        if (player.velocity.y < -0.2) {
          player.velocity.y += 0.1;
        } else {
          player.moveDown();
        }
        //player.moveDown();
      } else if (keyCode == LEFT) {
        if (player.velocity.x > 0.2) {
          player.velocity.x -= 0.1;
        } else {
          player.moveLeft();
        }
        //player.moveLeft();
      } else if (keyCode == RIGHT) {
        if (player.velocity.x < -0.2) {
          player.velocity.x += 0.1;
        } else {
          player.moveRight();
        }
        //player.moveRight();
      }
    } else if (key == 'w') {
      // Add Rock only if there is enough in weapon stash
      if (weaponStash > 0) {
        Rock shot = new Rock(((int) player.position.x)+4, ((int) player.position.y)+6, 0, -4);
        rocks.add(shot);
        removeWeapon();
        // Trigger Rock Throw Sound
        rockThrowSample.trigger();
      }
    } else if (key == 's') {
      // Add Rock only if there is enough in weapon stash
      if (weaponStash > 0) {
        Rock shot = new Rock(((int) player.position.x)+4, ((int) player.position.y)+6, 0, 4);
        rocks.add(shot);
        removeWeapon();
        // Trigger Rock Throw Sound
        rockThrowSample.trigger();
      }
    } else if (key == 'a') {
      // Add Rock only if there is enough in weapon stash
      if (weaponStash > 0) {
        Rock shot = new Rock(((int) player.position.x)+4, ((int) player.position.y)+6, -4, 0);
        rocks.add(shot);
        removeWeapon();
        // Trigger Rock Throw Sound
        rockThrowSample.trigger();
      }
    } else if (key == 'd') {
      // Add Rock only if there is enough in weapon stash
      if (weaponStash > 0) {
        Rock shot = new Rock(((int) player.position.x)+4, ((int) player.position.y)+6, 4, 0);
        rocks.add(shot);
        removeWeapon();
        // Trigger Rock Throw Sound
        rockThrowSample.trigger();
      }
    } else if (key == '1') {
      if (inventory[0] == 1) {
        // Activate gem power for 3 seconds
        useGemPower();
        inventory[0] = 0;
      } else if (inventory[0] == 2) {
        // Kill all enemies in maze
        killAllEnemies();
        inventory[0] = 0;
      } else if (inventory[0] == 3) {
        // Show path to trophy for 5 seconds
        showPathToTrophy();
        inventory[0] = 0;
      }
    } else if (key == '2') {
      if (inventory[1] == 1) {
        // Activate gem power for 3 seconds
        useGemPower();
        inventory[1] = 0;
      } else if (inventory[1] == 2) {
        // Kill all enemies in maze
        killAllEnemies();
        inventory[1] = 0;
      } else if (inventory[1] == 3) {
        // Show path to trophy for 5 seconds
        showPathToTrophy();
        inventory[1] = 0;
      }
    } else if (key == '3') {
      if (inventory[2] == 1) {
        // Activate gem power for 3 seconds
        useGemPower();
        inventory[2] = 0;
      } else if (inventory[2] == 2) {
        // Kill all enemies in maze
        killAllEnemies();
        inventory[2] = 0;
      } else if (inventory[2] == 3) {
        // Show path to trophy for 5 seconds
        showPathToTrophy();
        inventory[2] = 0;
      }
    }
  } else if (gameSummary) {
    if (key == ' ') {
      setupNewLevel();
    } else if (key == '1') {
      // Start Main Menu Music
      mainMenuMusic.rewind();
      mainMenuMusic.loop();
      // Show Main Menu
      showMainMenu();
    }
  } else if (gameOver) {
    if (key == ' ') {
      setupNewGame();
    } else if (key == '1') {
      // Start Main Menu Music
      mainMenuMusic.rewind();
      mainMenuMusic.loop();
      // Show Main Menu
      showMainMenu();
    }
  }
}

void keyReleased() {
  if (gameActive) {
    if (key == CODED) {
      if (keyCode == UP) {
        player.stopUp();
      } else if (keyCode == DOWN) {
        player.stopDown();
      } else if (keyCode == LEFT) {
        player.stopLeft();
      } else if (keyCode == RIGHT) {
        player.stopRight();
      }
    }
  }
}

void showGameControls() {
  gameMainMenu = false;
  gameActive = false;
  gameSummary = false;
  gameOver = false;
  gameControls = true;
}

void showGameSummary() {
  gameMainMenu = false;
  gameActive = false;
  gameSummary = true;
  gameOver = false;
  gameControls = false;
  // Trigger collect trophy audio
  collectTrophySample.trigger();
}

void showMainMenu() {
  gameActive = false;
  gameSummary = false;
  gameControls = false;
  gameOver = false;
  gameMainMenu = true;
}

void showGameOver() {
  gameMainMenu = false;
  gameControls = false;
  gameActive = false;
  gameSummary = false;
  gameOver = true;
  // Play Game Over Audio Sample
  gameOverSample.trigger();
}

void setupNewGame() {
  // Update Game State
  gameMainMenu = false;
  gameControls = false;
  gameSummary = false;
  gameOver = false;
  gameActive = true;
  temperature = 0;
  tipMessage = false;
  // PowerUp Parameters
  gemPowerTimer = 0;
  showPath = false;
  pathPowerUpTimer = 0;
  // Setup Maze
  maze = new Maze(ROWS, COLUMNS); // Initial Maze
  new MazeConstructor(maze.getMazeCells()).constructMaze(); // Procedurally generate a maze
  // Setup Player with maze origin point
  player = new Player(mazeStartX*CELL_SIZE, mazeStartY*CELL_SIZE, 0, 0);
  playerHealth = 100; // Start player with full health
  playerHealthRate = 100;
  playerCurrentFrame = 0;
  trophiesCollected = 0;
  weaponStash = 5; // Start with a full stash of 5 rocks
  inventory = new int[3];
  playerScore = 0; // Players start a new game with a score of 0 points
  // Setup Rocks ArrayList
  rocks = new ArrayList<Rock>();
  // Setup Trophy
  placeTrophy(mazeStartX, mazeStartY, maze.getMazeCells());
  trophy = new Trophy(trophyX, trophyY);
  maze.getMazeCells()[trophyX][trophyY].occupyCell(); // Occupy Cell with trophy
  // Setup Snacks
  int numberOfSnacks = (int) random(3, 6); // Always between 3 and 5 snacks per maze
  snacks = new ArrayList<Snack>();
  for (int snackN = 0; snackN < numberOfSnacks; snackN++) {
    //Pick a random cell
    int snackCell = (int) random(0, maze.getValidCells().size());
    int snackX = maze.getValidCells().get(snackCell).getRow();
    int snackY = maze.getValidCells().get(snackCell).getColumn();
    snacks.add(new Snack(snackX, snackY));
    maze.getValidCells().get(snackCell).occupyCell(); // Finally, occupy the cell
  }
  // Setup Weapons
  int numberOfWeapons = (int) random(3, 6); // Always between 3 and 5 weapons per maze
  weapons = new ArrayList<Weapon>();
  for (int weaponN = 0; weaponN < numberOfWeapons; weaponN++) {
    //Pick a random cell
    int weaponCell = (int) random(0, maze.getValidCells().size());
    int weaponX = maze.getValidCells().get(weaponCell).getRow();
    int weaponY = maze.getValidCells().get(weaponCell).getColumn();
    weapons.add(new Weapon(weaponX, weaponY));
    maze.getValidCells().get(weaponCell).occupyCell(); // Finally, occupy the cell
  }
  // Setup Enemies
  int numberOfEnemies = (int) random(3, 7); // Always between 3 and 6 enemies per maze
  enemies = new ArrayList<Enemy>();
  for (int enemyN = 0; enemyN < numberOfEnemies; enemyN++) {
    //Pick a random cell
    int enemyCell = (int) random(0, maze.getSearchableCells().size());
    int enemyX = maze.getSearchableCells().get(enemyCell).getRow();
    int enemyY = maze.getSearchableCells().get(enemyCell).getColumn();
    enemies.add(new Enemy(enemyX*CELL_SIZE, enemyY*CELL_SIZE, 0, 0));
  }
  // Setup Gems
  int numberOfGems = (int) random(1, 3); // Always between 1 and 2 gems per maze
  gems = new ArrayList<Gem>();
  for (int gemN = 0; gemN < numberOfGems; gemN++) {
    //Pick a random cell
    int gemCell = (int) random(0, maze.getValidCells().size());
    int gemX = maze.getValidCells().get(gemCell).getRow();
    int gemY = maze.getValidCells().get(gemCell).getColumn();
    gems.add(new Gem(gemX, gemY));
    maze.getValidCells().get(gemCell).occupyCell(); // Finally, occupy the cell
  }
  // Setup Power Ups
  int numberOfPowerUps = (int) random(0, 2); // Always between either 0 or 1 power ups per maze
  powerUps = new ArrayList<PowerUp>();
  for (int powerUpN = 0; powerUpN < numberOfPowerUps; powerUpN++) {
    //Pick a random cell
    int powerUpCell = (int) random(0, maze.getValidCells().size());
    int powerUpX = maze.getValidCells().get(powerUpCell).getRow();
    int powerUpY = maze.getValidCells().get(powerUpCell).getColumn();
    powerUps.add(new PowerUp(powerUpX, powerUpY));
    maze.getValidCells().get(powerUpCell).occupyCell(); // Finally, occupy the cell
  }
  // Trigger new maze audio
  newMazeSample.trigger();
}

void setupNewLevel() {
  // Update Game State
  gameMainMenu = false;
  gameControls = false;
  gameSummary = false;
  gameOver = false;
  gameActive = true;
  // Decrease Temperature
  temperature--;
  // Reset PowerUp Parameters
  gemPowerTimer = 0;
  showPath = false;
  pathPowerUpTimer = 0;
  // Setup Maze
  maze = new Maze(ROWS, COLUMNS); // Initial Maze
  new MazeConstructor(maze.getMazeCells()).constructMaze(); // Procedurally generate a maze
  // Setup Player with maze origin point
  player = new Player(mazeStartX*CELL_SIZE, mazeStartY*CELL_SIZE, 0, 0);
  if (playerHealthRate == 1) {
    playerHealthRate = 1;
  } else {
    playerHealthRate--;
  }
  playerCurrentFrame = 0;
  // Setup Rocks ArrayList
  rocks = new ArrayList<Rock>();
  // Setup Trophy
  placeTrophy(mazeStartX, mazeStartY, maze.getMazeCells());
  trophy = new Trophy(trophyX, trophyY);
  maze.getMazeCells()[trophyX][trophyY].occupyCell(); // Occupy Cell with trophy
  // Setup Snacks
  int numberOfSnacks = (int) random(3, 6); // Always between 3 and 5 snacks per maze
  snacks = new ArrayList<Snack>();
  for (int snackN = 0; snackN < numberOfSnacks; snackN++) {
    //Pick a random cell
    int snackCell = (int) random(0, maze.getValidCells().size());
    int snackX = maze.getValidCells().get(snackCell).getRow();
    int snackY = maze.getValidCells().get(snackCell).getColumn();
    snacks.add(new Snack(snackX, snackY));
    maze.getValidCells().get(snackCell).occupyCell(); // Finally, occupy the cell
  }
  // Setup Weapons
  int numberOfWeapons = (int) random(3, 6); // Always between 3 and 5 weapons per maze
  weapons = new ArrayList<Weapon>();
  for (int weaponN = 0; weaponN < numberOfWeapons; weaponN++) {
    //Pick a random cell
    int weaponCell = (int) random(0, maze.getValidCells().size());
    int weaponX = maze.getValidCells().get(weaponCell).getRow();
    int weaponY = maze.getValidCells().get(weaponCell).getColumn();
    weapons.add(new Weapon(weaponX, weaponY));
    maze.getValidCells().get(weaponCell).occupyCell(); // Finally, occupy the cell
  }
  // Setup Enemies
  int numberOfEnemies = (int) random(3, 7); // Always between 3 and 6 enemies per maze
  enemies = new ArrayList<Enemy>();
  for (int enemyN = 0; enemyN < numberOfEnemies; enemyN++) {
    //Pick a random cell
    int enemyCell = (int) random(0, maze.getSearchableCells().size());
    int enemyX = maze.getSearchableCells().get(enemyCell).getRow();
    int enemyY = maze.getSearchableCells().get(enemyCell).getColumn();
    enemies.add(new Enemy(enemyX*CELL_SIZE, enemyY*CELL_SIZE, 0, 0));
  }
  // Setup Gems
  int numberOfGems = (int) random(1, 3); // Always between 1 and 2 gems per maze
  gems = new ArrayList<Gem>();
  for (int gemN = 0; gemN < numberOfGems; gemN++) {
    //Pick a random cell
    int gemCell = (int) random(0, maze.getValidCells().size());
    int gemX = maze.getValidCells().get(gemCell).getRow();
    int gemY = maze.getValidCells().get(gemCell).getColumn();
    gems.add(new Gem(gemX, gemY));
    maze.getValidCells().get(gemCell).occupyCell(); // Finally, occupy the cell
  }
  // Setup Power Ups
  int numberOfPowerUps = (int) random(0, 2); // Always between either 0 or 1 power ups per maze
  powerUps = new ArrayList<PowerUp>();
  for (int powerUpN = 0; powerUpN < numberOfPowerUps; powerUpN++) {
    //Pick a random cell
    int powerUpCell = (int) random(0, maze.getValidCells().size());
    int powerUpX = maze.getValidCells().get(powerUpCell).getRow();
    int powerUpY = maze.getValidCells().get(powerUpCell).getColumn();
    powerUps.add(new PowerUp(powerUpX, powerUpY));
    maze.getValidCells().get(powerUpCell).occupyCell(); // Finally, occupy the cell
  }
  // Trigger new maze audio
  newMazeSample.trigger();
}

// Increase Player Health by specified amount
void increasePlayerHealth(int healthIncrease) {
  if (healthIncrease > (100 - playerHealth)) {
    playerHealth = 100;
  } else {
    playerHealth += healthIncrease;
  }
  // Trigger Yes Audio
  playerYesSample.trigger();
}

// Decrease Player Health by specified amount
void decreasePlayerHealth(int healthDecrease) {
  playerHealth -= healthDecrease;
  // Trigger health damage audio
  healthDamageSample.trigger();
}

// Add a weapon to the player's weapon stash
void equipPlayerWithWeapon() {
  weaponStash++;
  // Trigger collect weapon audio
  collectWeaponSample.trigger();
}

// Remove a weapon from the player's weapon stash
void removeWeapon() {
  if (weaponStash > 0) {
    weaponStash--;
  }
}

// Returns true if inventory is full
boolean isInventoryFull() {
  return ((inventory[0] != 0) && (inventory[1] != 0) && (inventory[2] != 0));
}

// Returns true if player has no gems
boolean isPlayerGemInventoryEmpty() {
  return ((inventory[0] != 1) && (inventory[1] != 1) && (inventory[2] != 1));
}

// Add a gem to the player's inventory
void equipPlayerWithGem() {
  if (inventory[0] == 0) {
    inventory[0] = 1;
  } else if (inventory[1] == 0) {
    inventory[1] = 1;
  } else if (inventory[2] == 0) {
    inventory[2] = 1;
  }
  // Trigger Collect Gem Audio
  collectGemSample.trigger();
}

// Grant gem power to the player
void useGemPower() {
  player.grantGemPower();
  gemPowerTimer = 180; // 3 seconds of gem power
  // Trigger gem power audio to indicate use of gem power
  gemPowerSample.trigger();
}

// Place power up in player's inventory if it is valid to do so
void equipPlayerWithPowerUp(PowerUp p) {
  if (p.powerUpType == 1) {
    if (inventory[0] == 0) {
      inventory[0] = 2;
    } else if (inventory[1] == 0) {
      inventory[1] = 2;
    } else if (inventory[2] == 0) {
      inventory[2] = 2;
    }
  } else if (p.powerUpType == 2) {
    if (inventory[0] == 0) {
      inventory[0] = 3;
    } else if (inventory[1] == 0) {
      inventory[1] = 3;
    } else if (inventory[2] == 0) {
      inventory[2] = 3;
    }
  }
  // Trigger collect power up audio
  collectPowerUpSample.trigger();
}

// Kill all enemies currently in the maze
void killAllEnemies() {
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).destroyEnemy();
    getSlayEnemyPoints(); // Collect points for every enemy destroyed
  }
  // Trigger explosion audio to signify that all enemies have been killed
  explosionSample.trigger();
}

// Shows the path from the player's location to the trophy
void showPathToTrophy() {
  showPath = true;
  pathPowerUpTimer = 300; // Grants 5 seconds of the show path power up
  // Trigger show path audio
  showPathSample.trigger();
}

// Given a xy coordinate, this finds the furthest xy coordinate in the maze to place trophy
void placeTrophy(int x, int y, MazeCell[][] mazeCells) {
  float maxDistance = 0;
  ArrayList<MazeCell> validCells = new ArrayList<MazeCell>();
  //Find all maze cells that are not walls or occupied
  for(int i = 0; i < mazeCells.length; i++) {
    for(int j = 0; j < mazeCells[0].length; j++) {
      if ((!mazeCells[i][j].isWall()) && (!mazeCells[i][j].isOccupied())) {
        validCells.add(mazeCells[i][j]);
      }
    }
  }
  // Now, find the furthest cell from x and y
  for (int a = 0; a < validCells.size(); a++) {
    float distance = dist(x, y, validCells.get(a).getRow(), validCells.get(a).getColumn());
    if (distance > maxDistance) {
      maxDistance = distance;
      trophyX = validCells.get(a).getRow();
      trophyY = validCells.get(a).getColumn();
    }
  }
}

// Get the corresponding friction coefficient when given a temperature
float getFrictionCoefficient(int temperature) {
  float frictionCoefficient = 1;
  switch (temperature) {
    case 0:
      frictionCoefficient = 1;
      break;
    case -1:
      frictionCoefficient = 1.3;
      break;
    case -2:
      frictionCoefficient = 1.5;
      break;
    case -3:
      frictionCoefficient = 1.8;
      break;
    case -4:
      frictionCoefficient = 1.85;
      break;
    case -5:
      frictionCoefficient = 1.86;
      break;
    case -6:
      frictionCoefficient = 1.87;
      break;
    case -7:
      frictionCoefficient = 1.88;
      break;
    case -8:
      frictionCoefficient = 1.89;
      break;
    case -9:
      frictionCoefficient = 1.9;
      break;
    case -10:
      frictionCoefficient = 1.91;
      break;
    case -11:
      frictionCoefficient = 1.92;
      break;
    case -12:
      frictionCoefficient = 1.93;
      break;
    case -13:
      frictionCoefficient = 1.94;
      break;
    case -14:
      frictionCoefficient = 1.95;
      break;
    case -15:
      frictionCoefficient = 1.96;
      break;
    case -16:
      frictionCoefficient = 1.97;
      break;
    case -17:
      frictionCoefficient = 1.98;
      break;
    case -18:
      frictionCoefficient = 1.99;
      break;
    case -19:
      frictionCoefficient = 1.995;
      break;
    default:
      frictionCoefficient = 1.999;
  }
  return frictionCoefficient;
}

// Players get 10 points for every enemy slayed
void getSlayEnemyPoints() {
  playerScore += 10;
}

// Players get 100 points for every trophy collected
void getCollectTrophyPoints() {
  playerScore += 100;
}

// ---------------------------
// COLLISION DETECTION FUNCTIONS

// Player - Trophy Collisions
boolean isPlayerTrophyCollision() {
  if (trophy.isGemProtected()) {
    if (player.isGemPower()) {
      if ((player.position.x > (trophy.mazeX*CELL_SIZE)) &&
          (player.position.x < ((trophy.mazeX*CELL_SIZE)+25)) &&
          (player.position.y > (trophy.mazeY*CELL_SIZE)) &&
          (player.position.y < ((trophy.mazeY*CELL_SIZE)+25))
         ) {
        return true;
      }
    }
  } else {
    if ((player.position.x > (trophy.mazeX*CELL_SIZE)) &&
        (player.position.x < ((trophy.mazeX*CELL_SIZE)+25)) &&
        (player.position.y > (trophy.mazeY*CELL_SIZE)) &&
        (player.position.y < ((trophy.mazeY*CELL_SIZE)+25))
       ) {
      return true;
    }
  }
  return false;
}

// Player - Snack Collisions
boolean isPlayerSnackCollision() {
  for (int i = 0; i < snacks.size(); i++) {
    Snack s = snacks.get(i);
    if ((player.position.x > (s.mazeX*CELL_SIZE)) &&
        (player.position.x < ((s.mazeX*CELL_SIZE)+25)) &&
        (player.position.y > (s.mazeY*CELL_SIZE)) &&
        (player.position.y < ((s.mazeY*CELL_SIZE)+25))) {
          s.eatSnack();
          return true;
        }
  }
  return false;
}

// Player - Weapon Collisions
boolean isPlayerWeaponCollision() {
  for (int i = 0; i < weapons.size(); i++) {
    Weapon w = weapons.get(i);
    if (w.isGemProtected()) {
      if (player.isGemPower()) {
        if ((player.position.x > (w.mazeX*CELL_SIZE)) &&
            (player.position.x < ((w.mazeX*CELL_SIZE)+25)) &&
            (player.position.y > (w.mazeY*CELL_SIZE)) &&
            (player.position.y < ((w.mazeY*CELL_SIZE)+25)) &&
            (weaponStash < 5)) {
              w.pickupWeapon();
              return true;
        }
      }
    } else {
      if ((player.position.x > (w.mazeX*CELL_SIZE)) &&
        (player.position.x < ((w.mazeX*CELL_SIZE)+25)) &&
        (player.position.y > (w.mazeY*CELL_SIZE)) &&
        (player.position.y < ((w.mazeY*CELL_SIZE)+25)) &&
        (weaponStash < 5)) {
          w.pickupWeapon();
          return true;
        }
    }
  }
  return false;
}

// Player - Gem Collisions
boolean isPlayerGemCollision() {
  for (int i = 0; i < gems.size(); i++) {
    Gem g = gems.get(i);
    if ((player.position.x > (g.mazeX*CELL_SIZE)) &&
        (player.position.x < ((g.mazeX*CELL_SIZE)+25)) &&
        (player.position.y > (g.mazeY*CELL_SIZE)) &&
        (player.position.y < ((g.mazeY*CELL_SIZE)+25)) &&
        (!isInventoryFull())) {
          g.pickupGem();
          return true;
        }
  }
  return false;
}

// Player - PowerUp Collisions
boolean isPlayerPowerUpCollision() {
  for (int i = 0; i < powerUps.size(); i++) {
    PowerUp p = powerUps.get(i);
    if (p.isGemProtected()) {
      if (player.isGemPower()) {
        if ((player.position.x > (p.mazeX*CELL_SIZE)) &&
            (player.position.x < ((p.mazeX*CELL_SIZE)+25)) &&
            (player.position.y > (p.mazeY*CELL_SIZE)) &&
            (player.position.y < ((p.mazeY*CELL_SIZE)+25)) &&
            (!isInventoryFull())) {
              p.collectPowerUp();
              powerUpToAdd = p;
              return true;
        }
      }
    } else {
      if ((player.position.x > (p.mazeX*CELL_SIZE)) &&
          (player.position.x < ((p.mazeX*CELL_SIZE)+25)) &&
          (player.position.y > (p.mazeY*CELL_SIZE)) &&
          (player.position.y < ((p.mazeY*CELL_SIZE)+25)) &&
          (!isInventoryFull())) {
            p.collectPowerUp();
            powerUpToAdd = p;
            return true;
        }
    }
  }
  return false;
}

// Player - Enemy Collisions
boolean isPlayerEnemyCollision() {
  for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    if (dist(player.position.x, player.position.y, e.position.x, e.position.y) < 10) {
          e.destroyEnemy();
          return true;
        }
  }
  return false;
}

boolean isRockEnemyCollision(Rock r) {
  for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    if ((r.position.x > e.position.x) &&
        (r.position.x < (e.position.x + e.enemyWidth)) &&
        (r.position.y > e.position.y) &&
        (r.position.y < (e.position.y + e.enemyHeight))) {
          e.destroyEnemy(); // Destroy enemy as well
          getSlayEnemyPoints(); // Collect points for slaying enemy
          return true;
        }
  }
  return false;
}
