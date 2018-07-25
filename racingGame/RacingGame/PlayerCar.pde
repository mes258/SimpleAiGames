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
  int atRP = 0;
  PlayerCar(int RP) {
    c = color(175);
    this.x = 20;
    this.y = height -20;
    this.atRP = RP;
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
    if(atRP == 0){
      x = 20; 
      y = height-20;
    }else if(atRP == 1){
      x = 100; 
      y = 20;
    }else if(atRP == 2){
      x = 120; 
      y = 650;
    }
    
    setBordersC();
  }
}
