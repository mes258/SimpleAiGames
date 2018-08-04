class Dot {
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;

  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;//true if this dot is the best dot from the previous generation
  int steps = 0;
  
  int atRP = 0;
  
  int atCheckpoint = 0;
  float fitness = 0;

  Dot(int thisRP) {
    brain = new Brain(1000);//new brain with 1000 instructions
    this.atRP = thisRP;
    //atCheckpoint = 1;
    //start the dots at the bottom of the window with a no velocity or acceleration
    if(atRP == 0){
      pos = new PVector(20, height- 20);
      vel = new PVector(0, 0);
      acc = new PVector(0, 0);
    }else {
      pos = new PVector(allStages[atRP-1].RP.x + allStages[atRP-1].RP.w/2, allStages[atRP-1].RP.y + allStages[atRP-1].RP.h/2);
      vel = new PVector(0, 0);
      acc = new PVector(0, 0);
    }
  }


  //-----------------------------------------------------------------------------------------------------------------
  //draws the dot on the screen
  void show() {
    stroke(0);
    //if this dot is the best dot from the previous generation then draw it as a big green dot
    if (isBest) {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 8, 8);
    } else{
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, 4, 4);
    } 
  }

  //-----------------------------------------------------------------------------------------------------------------------
  //moves the dot according to the brains directions
  void move() {

    if (brain.directions.length > brain.step) {//if there are still directions left then set the acceleration as the next PVector in the direcitons array
      acc = brain.directions[brain.step];
      brain.step++;
    } else {//if at the end of the directions array then the dot is dead
      dead = true;
    }

    //apply the acceleration and move the dot
    vel.add(acc);
    vel.limit(6);//not too fast
    pos.add(vel);
  }

  //-------------------------------------------------------------------------------------------------------------------
  //calls the move function and check for collisions and stuff
  void update() {
    if (!dead && !reachedGoal) {
      move();
      if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -2) {//if near the edges of the window then kill it 
        dead = true;
        
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness
  
  void calculateFitness() {
   //if(atRP >= numberOfRPs){
   //  atRP = 0;
   //  fitness = 1000000000;
   //}else{
     RestartPoint t = allStages[atRP].RP;
     float distanceToGoal = dist(pos.x, pos.y, t.x + t.w/2, t.y + t.h/2);
     fitness = 1.0/(distanceToGoal * distanceToGoal) + atRP;
   //}
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  Dot newBaby() {
    Dot baby = new Dot(this.atRP);
    baby.brain = brain.clone();//babies have the same brain as their parents
    return baby;
  }
}
