class Wall {
  
  public float x, y, h, w;
  public String num;
  int totalDotsKilled = 0;
  int min, max, speed;
  boolean moveX;
  boolean increase;
  Wall(int n, float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.num = ""+n;
  }
  
  Wall(int n, float x, float y, float w, float h, int min, int max, boolean moveX, boolean increase, int speed){
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.num = ""+n;
    this.max = max;
    this.min = min;
    this.moveX = moveX;
    this.increase = increase;
    this.speed = speed;
  }
  
  void show(){
    fill(0, 0, 255);
    rect(x, y, w, h);
    fill(255, 0, 0);
    text(num, x, y + 10);
  }
}
