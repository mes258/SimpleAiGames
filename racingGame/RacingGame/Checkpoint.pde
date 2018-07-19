class Checkpoint{
   float x = 0;
   float y = 0;
   float w = 30;
   float h = 10;
   int val = 0;
   public Checkpoint(float x, float y, int v){
   this.x = x;
   this.y = y;
   this.val = v;
  }
  
  void show(){
    fill(50, 50, 50);
    rect(x, y, w, h);
    fill(255);
    text(val, this.x - 5 , this.y + 5 );
  }
  
}
