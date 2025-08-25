import processing.sound.*;

SoundFile shootSound;
SoundFile backgroundMusic;

PImage img_background;

Pumpkin pumpkin;
Boss boss;
Skeleton mouseFollower;
ArrayList<Skeleton> skeletons;
ArrayList<Bullet> bullets;
int numOfSkeletons = 4; // Change this to adjust skeleton count
float rotationRadius = 100;

int screenIndex = 0;
int startTime, endTime;
int time = 0;
boolean gameOver = false;
boolean gameWon = false;



void setup() {
  size(1200, 700);
  img_background = loadImage("background.png");

  shootSound = new SoundFile(this, "bullet.mp3");
  shootSound.amp(0.05);

  backgroundMusic = new SoundFile(this, "16_bit_space.ogg");
  backgroundMusic.amp(0.0);

  backgroundMusic.loop();

  startTime = millis();

  pumpkin = new Pumpkin();
  boss = new Boss();
  mouseFollower = new Skeleton(width / 2, height / 2);

  skeletons = new ArrayList<Skeleton>();
  for (int i = 0; i < numOfSkeletons; i++) {
    float angle = TWO_PI / numOfSkeletons * i;
    float x = width / 2 + cos(angle) * rotationRadius;
    float y = height / 2 + sin(angle) * rotationRadius;
    skeletons.add(new Skeleton(x, y));
  }

  bullets = new ArrayList<Bullet>();
}

void initScreen() {
  background(0);
  imageMode(CENTER);
  image(img_background, width / 2, height / 2, width, height);

  fill(255);
  textAlign(CENTER);
  textSize(50);
  text("Click to Start", width / 2, height / 2);

  textSize(25);
  text("Use the mouse to move. Avoid enemy bullets!", width / 2, height / 2 + 50);
}

void gameOverScreen() {
  background(0);
  imageMode(CENTER);
  image(img_background, width / 2, height / 2, width, height);

  fill(255);
  textAlign(CENTER);
  textSize(50);
  text("Game Over", width / 2, height / 2);

  textSize(25);
  text("You survived for " + time + " seconds", width / 2, height / 2 + 50);
}

void winScreen() {
  background(0);  // Optional: You can set the background color to black for the win screen
  imageMode(CENTER);
  image(img_background, width / 2, height / 2, width, height);

  fill(255);  // White text
  textAlign(CENTER);
  textSize(50);
  text("You Win!", width / 2, height / 2);

  textSize(25);
  text("You defeated the boss in " + time + " seconds", width / 2, height / 2 + 50);
}

void gameScreen() {
  background(255);
  imageMode(CENTER);
  image(img_background, width / 2, height / 2, width, height);

  pumpkin.display();
  pumpkin.shootBullets();
  pumpkin.update();

  boss.display();
  boss.shootBullets();
  boss.update();

  if (mouseFollower != null) {
    mouseFollower.moveToMouse(mouseX, mouseY);
    mouseFollower.shootBullets(mouseX, mouseY);
    mouseFollower.update();
    mouseFollower.display();
  }

  for (int i = 0; i < skeletons.size(); i++) {
    Skeleton s = skeletons.get(i);
    s.rotateAroundBoss(width / 2, height / 2, i);
    s.shootBullets(mouseX, mouseY);
    s.update();
    s.display();
  }

  if (pumpkin.health <= 0 && !gameOver) {
    endTime = millis();
    time = (endTime - startTime) / 1000;
    gameOver = true;
    screenIndex = 2;
  }
  
  if (boss.health <= 0 && !gameWon) {
    endTime = millis();
    time = (endTime - startTime) / 1000; 
    gameWon = true;  
    screenIndex = 3; 
  }

  // Pumpkin's bullets hit skeletons and boss
  for (int i = pumpkin.bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = pumpkin.bullets.get(i);

    // Hit boss
    if (bullet.hits(boss.x, boss.y, boss.w, boss.h)) {
      boss.health--;
      println("Boss hit! Health: " + boss.health);
      pumpkin.bullets.remove(i);
      continue;
    }

    if (mouseFollower != null && bullet.hits(mouseFollower.x, mouseFollower.y, mouseFollower.w, mouseFollower.h)) {
      mouseFollower.health--;
      println("MouseFollower skeleton hit! Health: " + mouseFollower.health);
      pumpkin.bullets.remove(i);
      if (mouseFollower.health <= 0) {
        println("MouseFollower defeated!");
        mouseFollower = null; // Remove it from the game
      }
      continue;
    }

    // Hit skeletons
    for (int j = skeletons.size() - 1; j >= 0; j--) {
      Skeleton s = skeletons.get(j);
      if (bullet.hits(s.x, s.y, s.w, s.h)) {
        s.health--;
        println("Skeleton hit! Health: " + s.health);
        pumpkin.bullets.remove(i);
        if (s.health <= 0) {
          skeletons.remove(j);
        }
        break;
      }
    }
  }

  // Boss bullets hit pumpkin
  for (int i = boss.bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = boss.bullets.get(i);
    if (bullet.hits(pumpkin.x, pumpkin.y, pumpkin.w, pumpkin.h)) {
      pumpkin.health--;
      println("Pumpkin hit by boss! Health: " + pumpkin.health);
      boss.bullets.remove(i);
      continue;
    }
  }

  // Skeleton bullets hit pumpkin
  for (Skeleton s : skeletons) {
    for (int i = s.bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = s.bullets.get(i);
      if (bullet.hits(pumpkin.x, pumpkin.y, pumpkin.w, pumpkin.h)) {
        pumpkin.health--;
        println("Pumpkin hit by skeleton! Health: " + pumpkin.health);
        s.bullets.remove(i);
        continue;
      }
    }
  }

  // Show player lives and time at the top-left
  fill(255);
  textSize(20);
  textAlign(LEFT, TOP);

  text("Lives: " + (int)pumpkin.health, 20, 20);

  int elapsedTime = (millis() - startTime) / 1000; // Time in seconds
  text("Time: " + elapsedTime + "s", 20, 50);
}

void draw() {
  if (screenIndex == 0) {
    initScreen();
  } else if (screenIndex == 1) {
    gameScreen();
  } else if (screenIndex == 2) {
    gameOverScreen();
  } else if (screenIndex == 3) {
    winScreen();
  }
}

void playShootSound() {
  shootSound.play();  // Play sound when called
}

void mousePressed() {
  if (screenIndex == 0) {
    screenIndex = 1;
    startTime = millis(); // start the timer
  } else if (screenIndex == 2) {
    // Reset everything if you want replay functionality
    resetGame();
    screenIndex = 0;
  }
}

void resetGame() {
  pumpkin = new Pumpkin();
  boss = new Boss();
  skeletons.clear();
  for (int i = 0; i < numOfSkeletons; i++) {
    float angle = TWO_PI / numOfSkeletons * i;
    float x = width / 2 + cos(angle) * rotationRadius;
    float y = height / 2 + sin(angle) * rotationRadius;
    skeletons.add(new Skeleton(x, y));
  }
  bullets.clear();
  startTime = millis();
  gameOver = false;
}
