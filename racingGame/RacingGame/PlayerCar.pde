class PlayerCar{
  
  color c;
  float x;
  float y;
  float speed=3;
  int w = 10;
  int h = 10;
  boolean up, down, left, right;
  float topBorderC;
  float bottomBorderC;
  float rightBorderC;
  float leftBorderC;
  boolean dead;
  PlayerCar() {
    c = color(175);
    this.x = 10;
    this.y = 750;
    setBordersC() ;
  }
  
  void setBordersC() {
    topBorderC = y - w/2;
    bottomBorderC = y + w/2;
    rightBorderC = x + h/2;
    leftBorderC = x - h/2;
  }
  
  void display() {
    rectMode(CENTER);
    stroke(0);
    fill(c);
    rect(x, y, w, h);
  }
  
  void move() {
    if (up)    y -= speed;
    if (down)  y += speed;
    if (left)  x -= speed;
    if (right) x += speed;
  }
  
  void update() {
    if (!dead) {
      move();
      if (x< 5|| y<5 || x>width-5 || y>height-5) {
        dead = true;
      } 
    }
  }
  
  void reset(){
    dead = false;
    x = 10; 
    y = 750;
    setBordersC();
  }
}
