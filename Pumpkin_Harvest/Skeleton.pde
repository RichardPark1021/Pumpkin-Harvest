class Skeleton {
  float x, y;
  float w, h;
  float health;
  int numOfBullets;
  float bulletSpeed;
  PImage img_skeleton;
  ArrayList<Bullet> bullets;
  float speed = 3;
  float rotationAngle = 0;

  Skeleton(float x, float y) {
    w = 30;
    h = 30;
    this.x = x;
    this.y = y;
    health = 2;
    numOfBullets = 1;
    bulletSpeed = 6;
    img_skeleton = loadImage("skull.png");
    bullets = new ArrayList<Bullet>();
  }

  void display() {
    image(img_skeleton, x, y, w, h);
  }

  void moveToMouse(float targetX, float targetY) {
    float angleToMouse = atan2(targetY - y, targetX - x);
    x += cos(angleToMouse) * speed;
    y += sin(angleToMouse) * speed;
  }

  void rotateAroundBoss(float centerX, float centerY, int index) {
    rotationAngle += 0.03; // Adjust speed of rotation
    float angle = TWO_PI / numOfSkeletons * index + rotationAngle;
    x = centerX + cos(angle) * rotationRadius;
    y = centerY + sin(angle) * rotationRadius;
  }

  void shootBullets(float targetX, float targetY) {
    if (frameCount % 30 == 0) { // Shoot every second
      for (int i = 0; i < numOfBullets; i++) {
        float shotDirection = atan2(targetY - y, targetX - x);
        Bullet newBullet = new Bullet(x, y, shotDirection, bulletSpeed);
        bullets.add(newBullet);
      }
    }
  }

  void update() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      bullet.move();
      bullet.display();
      if (bullet.x < 0 || bullet.x > width || bullet.y < 0 || bullet.y > height) {
        bullets.remove(i);
      }
    }
  }
}
