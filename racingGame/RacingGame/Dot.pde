class Dot {
  PVector pos;
  PVector vel;
  PVector acc;
  Brain brain;

  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;//true if this dot is the best dot from the previous generation
  int steps = 0;
  
  int atCheckpoint = 0;
  float fitness = 0;

  Dot() {
    brain = new Brain(1000);//new brain with 1000 instructions
    
    atCheckpoint = 1;
    //start the dots at the bottom of the window with a no velocity or acceleration
    pos = new PVector(20, height- 20);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }


  //-----------------------------------------------------------------------------------------------------------------
  //draws the dot on the screen
  void show() {
    //if this dot is the best dot from the previous generation then draw it as a big green dot
    if (isBest) {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 8, 8);
    } else if(atCheckpoint % 3 == 0) {//all other dots are just smaller black dots
      fill(0, 0, 0);
      ellipse(pos.x, pos.y, 2, 2);
    } else if(atCheckpoint % 3 == 1) {
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, 4, 4);
    } else {
      fill(0, 0, 255);
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
      } else if (dist(pos.x, pos.y, goal.x, goal.y) < 5) {//if reached goal
        reachedGoal = true;
      } else if (dist(pos.x, pos.y, goal2.x, goal2.y) < 5) {//if reached goal2
        reachedGoal = true;
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness
  void calculateFitness() {
    fitness = atCheckpoint * atCheckpoint;
    //fitness = fitness * fitness;
    //if(atCheckpoint == 0){
    //  float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
    //  fitness = 1.0/(distanceToGoal * distanceToGoal);
    //}else if(atCheckpoint == 5){
    //  float distanceToGoal = dist(pos.x, pos.y, goal2.x, goal2.y);
    //  fitness = 1.0/(distanceToGoal * distanceToGoal);
    //}else if (reachedGoal) {//if the dot reached the goal then the fitness is based on the amount of steps it took to get there
    //  fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
    //}
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  Dot newBaby() {
    Dot baby = new Dot();
    baby.brain = brain.clone();//babies have the same brain as their parents
    return baby;
  }
}
