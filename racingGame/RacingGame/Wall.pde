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
    noStroke();
    fill(0, 0, 255);
    if(type == 0){ //regular blue walls
      rect(x, y, w, h);
    } else if (type == 1){ //Trigger Walls
      fill(173, 216, 230);
      rect(x, y, w, h);
    } else if (type == 2){ //Moving Walls
      fill(0);
      rect(x, y, w, h);
      //fill(255, 0, 0);
      //text(num, x, y + 10);
    } else if (type == 3){
      //hidden walls, not to be seen or to kill
    } else if (type == 4){ //Teleportation walls
      fill(255, 255, 0);
      rect(x, y, w, h);
    }else if (type == 5){//
      fill(255);
      rect(x, y, w, h);
    }else if (type == 6){
      fill(0, 255, 0);
      rect(x, y, w, h);
    }
    
    //fill(255, 0, 0);
    //text(num, x, y + 10);
  }
}
