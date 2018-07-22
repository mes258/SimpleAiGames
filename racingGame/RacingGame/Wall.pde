class Wall {
  
  public float x, y, h, w;
  public String num;
  int totalDotsKilled = 0;
  Wall(int n, float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.num = ""+n;
  }
  
  void show(){
    fill(0, 0, 255);
    rect(x, y, w, h);
    fill(255, 0, 0);
    text(num, x, y + 10);
  }
}
