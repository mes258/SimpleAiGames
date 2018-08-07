class Coin{
  
  float x,y;
  float w = 50;
  float h = 50;
  int val = 0;
  public Coin(float x, float y, int val){
    this.x = x;
    this.y = y;
    this.val = val;
  }
  
  void show(){
      //noStroke();
     fill(255, 215, 0);
     ellipse(x, y, 10, 10);
     fill(255, 0, 0);
     text(val, x, y + 10);
  }
}
