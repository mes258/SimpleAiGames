class StartingArea{
  
  float x,y;
  float w = 50;
  float h = 50;
  public StartingArea(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void show(){
    noStroke();
    fill(255, 165, 0);
    rect(x, y, w, h);
  }
}
