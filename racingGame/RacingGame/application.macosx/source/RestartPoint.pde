class RestartPoint{
  
  float x = 0;
  float y = 0;
  float w = 50;
  float h = 50;
  int val = 0;
  
  public RestartPoint(float x, float y, int v){
    this.x = x;
    this.y = y;
    this.val = v;
  }
  
  void show(){
    fill(0, 50, 0);
    rect(x, y, w, h);
    fill(255);
    text(val, this.x + 20 , this.y + 30 );
  }
}
