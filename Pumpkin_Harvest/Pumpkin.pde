class Pumpkin {
  // Fields
  float x, y;
  float w, h;
  float health;
  int numOfBullets;
  float bulletSpeed;
  PImage img_boss;
  ArrayList<Bullet> bullets;

  // Constructor
  Pumpkin() {
    w = 30;
    h = 30;
    x = width / 2;
    y = height - h / 2; // Initial spawn at the bottom
    health = 3;
    bulletSpeed = 5;
    numOfBullets = 1;
    img_boss = loadImage("pumpkin.png");
    bullets = new ArrayList<Bullet>();
  }

  // Display pumpkin
  void display() {
    image(img_boss, x, y, w, h);
  }

  // Shoot bullets straight up
  void shootBullets() {
    if (frameCount % 20 == 0) {  // Shoot every 30 frames
      for (int i = 0; i < numOfBullets; i++) {
        Bullet newBullet = new Bullet(x, y, -HALF_PI, bulletSpeed); // Shoots straight up
        bullets.add(newBullet);
      }
      playShootSound();
    }
  }

  // Update position to follow the mouse
  void update() {
    x = mouseX; // Move to mouse's X position
    y = mouseY; // Move to mouse's Y position

    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      bullet.move();  // Move each bullet
      bullet.display();  // Display each bullet
    }
    
    removeBullet();
  }
  
  // Remove bullets that go out of bounds
  void removeBullet() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      if (bullet.y < 0) { // Remove bullet if it goes above the screen
        bullets.remove(i);
      }
    }
  }
}
