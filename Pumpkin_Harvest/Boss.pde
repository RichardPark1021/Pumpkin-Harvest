class Boss {
  //field
  float x, y;
  float w, h;
  float health;
  int numOfBullets;
  float bulletSpeed;
  PImage img_boss;
  ArrayList<Bullet> bullets;

  float shotAngleIncrement;
  float directionOffset = 0;

  //Constructor
  Boss() {
    w = 50;
    h = 50;
    x = width/2;
    y = height/2;
    health = 20;
    bulletSpeed = 2;
    numOfBullets = 5;
    img_boss = loadImage("demon.png");
    bullets = new ArrayList<Bullet>();

    shotAngleIncrement = TWO_PI / numOfBullets;
  }

  //Methods
  void display() {
    image(img_boss, x, y, w, h);
  }

  void shootBullets() {
    if (frameCount % 30 == 0) {
      for (int i = 0; i < numOfBullets; i++) {
        float shotDirection = directionOffset + i * shotAngleIncrement;

        Bullet newBullet = new Bullet(x, y, shotDirection, bulletSpeed);
        bullets.add(newBullet);
      }
      directionOffset += HALF_PI;
    }
  }

  void update() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      bullet.move();  // Move each bullet
      bullet.display();  // Display each bullet
    }
    
    removeBullet();
  }
  
  void removeBullet() {
    for(int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      
      if(bullet.x < 0 || bullet.x > width || bullet.y < 0 || bullet.y > height) {
        bullets.remove(i);
      }
    }
  }
}
