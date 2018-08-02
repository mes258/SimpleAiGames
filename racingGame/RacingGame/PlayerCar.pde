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
      if (x< 0|| y<0 || x>width-10 || y>height-10) {
        dead = true;
      } 
    }
  }
  
  void reset(){
    dead = false;
    //if(atRP == 0){
      x = 20;
      y = height-20;
    //}else{
     // x = RP[atRP-1].x + RP[atRP-1].w/2 - w/2;
     // y =  RP[atRP-1].y + RP[atRP-1].h/2 -h/2;
   // }
    setBordersC();
  }
}
