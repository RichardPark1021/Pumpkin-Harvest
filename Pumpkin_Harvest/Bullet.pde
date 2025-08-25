class Bullet {
  //field
  float x, y;
  float w, h;
  float speed;
  float direction;
  PImage img_bullet;
  
  //Constructor
  Bullet(float x, float y, float direction, float speed) {
    this.x = x;
    this.y = y;
    w = 25;
    h = 25;
    this.speed = speed;
    this.direction = direction;
    img_bullet = loadImage("fireball.png");
  }
  
  void display() {
    image(img_bullet, x, y, w, h);
  }
  
  void move() {
    x += cos(direction) * speed;
    y += sin(direction) * speed;
  }
  
  boolean hits(float tx, float ty, float tw, float th) {
    return !(x + w / 2 < tx - tw / 2 || x - w / 2 > tx + tw / 2 || 
             y + h / 2 < ty - th / 2 || y - h / 2 > ty + th / 2);
  }
}
