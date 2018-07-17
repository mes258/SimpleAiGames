class Wall {
  
  public float x, y, h, w;
  int totalDotsKilled = 0;
  Wall(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
  }
  
  void show(){
    fill(0, 0, 255);
    rect(x, y, w, h);
  }
}
