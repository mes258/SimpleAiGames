class PlayerCar{
  
  color c;
  float xpos;
  float ypos;
  float speed=1;
  int sizeW = 10;
  int sizeH = 10;
  boolean up, down, left, right;
  float topBorderC;
  float bottomBorderC;
  float rightBorderC;
  float leftBorderC;
  PlayerCar() {
    c = color(175);
    xpos = width/2;
    ypos = width/2;
    setBordersC() ;
  }
  
  void setBordersC() {
    topBorderC = ypos - sizeW/2;
    bottomBorderC = ypos + sizeW/2;
    rightBorderC = xpos + sizeH/2;
    leftBorderC = xpos - sizeH/2;
  }
  
  void display() {
    rectMode(CENTER);
    stroke(0);
    fill(c);
    rect(xpos, ypos, sizeW, sizeH);
  }
  
  void move() {
    if (up)    ypos -= speed;
    if (down)  ypos += speed;
    if (left)  xpos -= speed;
    if (right) xpos += speed;
  }
}
