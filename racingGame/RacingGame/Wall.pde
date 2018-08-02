class Wall {
  
  public float x, y, h, w;
  public String num;
  int totalDotsKilled = 0;
  int min, max, speed;
  float start, stop;
  int type;
  boolean moveX;
  boolean increase;
  Wall(int n, float x, float y, float w, float h, int type) {
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.num = ""+n;
    this.type = type;
  }
  
  Wall(int n, float x, float y, float w, float h, int min, int max, boolean moveX, boolean increase, int speed, int type){
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
    this.type = type;
  }
  
  void show(int type){
    fill(0, 0, 255);
    if(type == 0){
      rect(x, y, w, h);
    } else if (type == 1){
      fill(173, 216, 230);
      rect(x, y, w, h);
    } else if (type == 2){
      fill(0);
      rect(x, y, w, h);
    } 
    
    fill(255, 0, 0);
    text(num, x, y + 10);
  }
}
