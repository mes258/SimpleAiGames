class Critter{
  PVector pos;
  PVector vel;
  //PVector acc;
  int step = 0;
  

  public Critter(int randXMin, int randXMax, int randYMin, int randYMax){
    float randomx = random(randXMin, randXMax);
    float randomy = random(randYMin, randYMax);
    pos = new PVector(randomx, randomy);
    vel = new PVector(random(-2,2), random(-2,2));
    //acc = new PVector(1, 0);
  }
  
  void show() {
    fill(0, 255, 255);
    ellipse(pos.x, pos.y, 4, 4);
    this.move();
  }
  
  void move() {

    
    //apply the acceleration and move the dot
    //vel.add(acc);
    vel.limit(4);//not too fast
    pos.add(vel);
  }
}
