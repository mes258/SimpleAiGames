import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RacingGame extends PApplet {

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
  
  public void show(int type){
    noStroke();
    fill(0, 0, 255);
    if(type == 0){
      rect(x, y, w, h);
    } else if (type == 1){
      fill(173, 216, 230);
      rect(x, y, w, h);
    } else if (type == 2){
      fill(0);
      rect(x, y, w, h);
    } else if (type == 3){
      
    } else if (type == 4){
      fill(255, 255, 0);
      rect(x, y, w, h);
    }else if (type == 5){
      fill(255);
      rect(x, y, w, h);
    }
    
    //fill(255, 0, 0);
    //text(num, x, y + 10);
  }
}
class Brain {
  PVector[] directions;//series of vectors which get the dot to the goal (hopefully)
  int step = 0;


  Brain(int size) {
    directions = new PVector[size];
    randomize();
  }

  //--------------------------------------------------------------------------------------------------------------------------------
  //sets all the vectors in directions to a random vector with length 1
  public void randomize() {
    for (int i = 0; i< directions.length; i++) {
      float randomAngle = random(2*PI);
      directions[i] = PVector.fromAngle(randomAngle);
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------
  //returns a perfect copy of this brain object
  public Brain clone() {
    Brain clone = new Brain(directions.length);
    for (int i = 0; i < directions.length; i++) {
      clone.directions[i] = directions[i].copy();
    }
    return clone;
  }

  //----------------------------------------------------------------------------------------------------------------------------------------

  //mutates the brain by setting some of the directions to random vectors
  public void mutate() {
    float mutationRate = 0.05f;//chance that any vector in directions gets changed
    for (int i =0; i< directions.length; i++) {
      float rand = random(1);
      if (rand < mutationRate) {
        //set this direction as a random direction 
        float randomAngle = random(2*PI);
        directions[i] = PVector.fromAngle(randomAngle);
      }
    }
  }
}
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
  
  public void show() {
    stroke(0);
    fill(0, 255, 255);
    ellipse(pos.x, pos.y, 4, 4);
    this.move();
  }
  
  public void move() {

    
    //apply the acceleration and move the dot
    //vel.add(acc);
    vel.limit(4);//not too fast
    pos.add(vel);
  }
}
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
  public void show() {
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
  public void move() {

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
  public void update() {
    if (!dead && !reachedGoal) {
      move();
      if (pos.x< 2|| pos.y<2 || pos.x>width-2 || pos.y>height -2) {//if near the edges of the window then kill it 
        dead = true;
        
      }
    }
  }


  //--------------------------------------------------------------------------------------------------------------------------------------
  //calculates the fitness
  
  public void calculateFitness() {
   //if(atRP >= numberOfRPs){
   //  atRP = 0;
   //  fitness = 1000000000;
   //}else{
     RestartPoint t = allStages[atRP].RP;
     float distanceToGoal = dist(pos.x, pos.y, t.x + t.w/2, t.y + t.h/2);
     fitness = 1.0f/(distanceToGoal * distanceToGoal) + atRP;
   //}
  }

  //---------------------------------------------------------------------------------------------------------------------------------------
  //clone it 
  public Dot newBaby() {
    Dot baby = new Dot(this.atRP);
    baby.brain = brain.clone();//babies have the same brain as their parents
    return baby;
  }
}
class PlayerCar{
  
  int c;
  float x;
  float y;
  float speed=3;
  int w = 10;
  int h = 10;
  boolean up, down, left, right;
  float topBorderC;
  float bottomBorderC;
  float rightBorderC;
  float leftBorderC;
  boolean dead;
  int atRP = 0;
  int numberOfDeaths;
  
  PlayerCar(int RP) {
    c = color(175);
    this.x = 20;
    this.y = height -20;
    this.atRP = RP;
    setBordersC() ;
  }
  
  public void setBordersC() {
    topBorderC = y - w/2;
    bottomBorderC = y + w/2;
    rightBorderC = x + h/2;
    leftBorderC = x - h/2;
  }
  
  public void display() {
    stroke(0);
    fill(c);
    rect(x, y, w, h);
  }
  
  public void move() {
    if (up)    y -= speed;
    if (down)  y += speed;
    if (left)  x -= speed;
    if (right) x += speed;
  }
  
  public void update() {
    if (!dead) {
      move();
      if (x< 0|| y<0 || x>width-10 || y>height-10) {
        if(!dead){
          numberOfDeaths++;
        }
        dead = true;
      } 
    }
  }
  
  public void reset(){
    dead = false;
    if(atRP == 0){
      x = 20;
      y = height-20;
    }else{
      x = allStages[atRP-1].RP.x + allStages[atRP-1].RP.w/2;
      y = allStages[atRP-1].RP.y + allStages[atRP-1].RP.h/2;
    }
    setBordersC();
  }
}
class Population {
  Dot[] dots;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;//the index of the best dot in the dots[]

  int minStep = 1000;

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot(0);
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------
  //show all dots
  public void show() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].show();
    }
    dots[0].show();
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  //update all dots 
  public void update() {
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].brain.step > minStep) {//if the dot has already taken more steps than the best dot has taken to reach the goal
        dots[i].dead = true;//then it dead
      } else {
        dots[i].update();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------
  //calculate all the fitnesses
  public void calculateFitness() {
    for (int i = 0; i< dots.length; i++) {
      dots[i].calculateFitness();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------
  //returns whether all the dots are either dead or have reached the goal
  public boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead && !dots[i].reachedGoal) { 
        return false;
      }
    }
    return true;
  }



  //-------------------------------------------------------------------------------------------------------------------------------------

  //gets the next generation of dots
  public void naturalSelection() {
    Dot[] newDots = new Dot[dots.length];//next gen
    setBestDot();
    calculateFitnessSum();

    //the champion lives on 
    newDots[0] = dots[bestDot].newBaby();
    newDots[0].isBest = true;
    for (int i = 1; i< newDots.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();

      //get baby from them
      newDots[i] = parent.newBaby();
    }

    dots = newDots.clone(); 
    gen++;
  }


  //---------------dots.-----------------------------------------------------------------------------------------------------------------------
  //you get it
  public void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dots.length; i++) {
      fitnessSum += dots[i].fitness;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  //chooses dot from the population to return randomly(considering fitness)

  //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
  //then go through all the dots and add their fitness to a running sum and if that sum is greater than the random value generated that dot is chosen
  //since dots with a higher fitness function add more to the running sum then they have a higher chance of being chosen
  public Dot selectParent() {
    float rand = random(fitnessSum);


    float runningSum = 0;
    
    for(int i = 0; i < dots.length * 0.75f; i++){
      runningSum += dots[0].fitness;
    }
    
    for (int i = 0; i< dots.length; i++) {
      runningSum+= dots[i].fitness;
      if (runningSum > rand) {
        return dots[i];
      }
    }

    //should never get to this point

    return null;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  public void mutateDots(){
    for(int i = 1; i < dots.length; i++){
      dots[i].brain.mutate();
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  //finds the dot with the highest fitness and sets it as the best dot
  public void setBestDot() {
    float max = 0;
    int maxIndex = 0;
    int maxSteps = 0;
    int maxRP = 0;
    for (int i = 0; i< dots.length; i++) {
      if(dots[i].atRP > maxRP || dots[i].atRP == maxRP){
        if (dots[i].fitness > max) {
          max = dots[i].fitness;
          maxIndex = i;
          maxSteps = dots[i].steps;
        }else if(dots[i].fitness == max && dots[i].steps < maxSteps){
          max = dots[i].fitness;
          maxIndex = i;
         maxSteps = dots[i].steps;
        }
      }
    }

    bestDot = maxIndex;
    
    //dots[bestDot].fitness += 10;
    println("fitness: ", dots[bestDot].fitness);
    println("RP: ", dots[bestDot].atRP);
    println("");
    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      println("step:", minStep);
      
    }
  }
}
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
  
  public void show(){
    fill(0, 50, 0);
    rect(x, y, w, h);
    fill(255);
    text(val, this.x + 20 , this.y + 30 );
  }
}
class Stage {

  int stageNum = 0;

  Wall[] walls; //All walls
  int numWalls = 0; 

  RestartPoint RP; //Restart Point

  boolean dotsCompletedPrevious = false;
  boolean carCompletedPrevious = false;

  boolean hasMovingWalls = false;

  Critter[] bugs;
  boolean hasBugs = false;


  Stage(int stageNum) {
    this.stageNum = stageNum;
    walls = new Wall[50];
    bugs = new Critter[15];
    makeStage(stageNum);
  }

  public void show() {

    if (hasBugs) {
      for (int i = 0; i < bugs.length; i++) {
        bugs[i].show();
      }
    }
    if (hasMovingWalls) {
      for (int i = 0; i < numWalls; i ++) {
        if (walls[i].type == 2) {
          moveWalls(walls[i]);
        }
      }
    }
    if (dotsCompletedPrevious && carCompletedPrevious) {
      walls[0].type = 0;
      walls[1].type = 0;
    }else{
      walls[0].type = 3;
      walls[1].type = 3;
    }
    for (int i = 0; i < numWalls; i++) {
      walls[i].show(walls[i].type);
    }
    RP.show();
  }

  public void makeStage(int n) {
    //Wall types: 0 = normal wall, 1 = trigger wall, 2 = moving wall, 3 = hidden wall, 4 = teleporter, 5 = bug bounce wall
    if (n == 1) {               //STAGE 1
      RP  = new RestartPoint(75, 0, 1);
      walls[0] = new Wall(-1, -65, 50, 30, 10, 3);
      walls[1] = new Wall(-2, -65, 0, 10, 50, 3);

      walls[2] = new Wall(0, 50, 70, 10, 630, 0);
      walls[3] = new Wall(1, 0, 60, 30, 10, 0);
      walls[4] = new Wall(2, 95, 50, 10, 60, 0);
      walls[5] = new Wall(3, 60, 100, 80, 10, 0);
    } else if (n == 2) {         //STAGE 2
      RP = new RestartPoint(80, 650, 2);
      walls[0] = new Wall(-1, 65, 50, 30, 10, 3);
      walls[1] = new Wall(-2, 65, 0, 10, 50, 3);

      walls[2] = new Wall(0, 50, 100, 10, 630, 0);
      walls[3] = new Wall(2, 95, 50, 10, 60, 0);
      walls[4] = new Wall(3, 60, 100, 80, 10, 0);
      walls[5] = new Wall(4, 200, 0, 10, 150, 0);
      walls[6] = new Wall(5, 150, 140, 60, 10, 0);
      walls[7] = new Wall(6, 150, 140, 10, 35, 0);
      walls[8] = new Wall(7, 125, 165, 35, 10, 0);
      walls[9] = new Wall(8, 125, 165, 10, 35, 0);
      walls[10] = new Wall(9, 100, 190, 35, 10, 0);
      walls[11] = new Wall(10, 100, 190, 10, 460, 0);
      walls[12] = new Wall(10, 50, 400, 10, 60, 50, 100, true, true, 1, 2);
      hasMovingWalls = true;
    } else if (n == 3) {         //STAGE 3
      RP = new RestartPoint(160, 150, 3);

      walls[0] = new Wall(-3, 70, 640, 30, 10, 3);
      walls[1] = new Wall(-4, 70, 640, 10, 60, 3);

      walls[2] = new Wall(12, 200, 200, 10, 500, 0);
      walls[3] = new Wall(5, 150, 140, 60, 10, 0);
      walls[4] = new Wall(6, 150, 140, 10, 35, 0);
      walls[5] = new Wall(7, 125, 165, 35, 10, 0);
      walls[6] = new Wall(8, 125, 165, 10, 35, 0);
      walls[7] = new Wall(9, 100, 190, 35, 10, 0);
      walls[8] = new Wall(10, 100, 190, 10, 460, 0);

      walls[9] = new Wall(11, random(101, 175), 580, 10, 60, 101, 199, true, false, 1, 2);
      walls[10] = new Wall(12, random(101, 175), 550, 10, 60, 101, 199, true, true, 1, 2);
      walls[11] = new Wall(13, random(101, 175), 450, 10, 60, 101, 199, true, true, 1, 2);
      walls[12] = new Wall(14, random(101, 175), 400, 10, 60, 102, 198, true, true, 2, 2);
      walls[13] = new Wall(15, random(101, 175), 350, 10, 60, 101, 199, true, true, 1, 2);
      walls[14] = new Wall(16, random(101, 175), 250, 10, 60, 102, 198, true, true, 2, 2);
      walls[15] = new Wall(17, random(101, 175), 300, 10, 60, 103, 162, true, true, 3, 2);
      walls[16] = new Wall(18, random(101, 175), 200, 10, 60, 103, 197, true, true, 3, 2);
      hasMovingWalls = true;
    } else if (n == 4) {
      RP = new RestartPoint(210, 10, 4);
      walls[0] = new Wall(-5, 150, 170, 10, 30, 3);
      walls[1] = new Wall(-6, 150, 200, 60, 10, 3);

      walls[2] = new Wall(2, 200, 0, 10, 150, 0);
      walls[3] = new Wall(3, 150, 140, 60, 10, 0);
      walls[4] = new Wall(4, 150, 140, 10, 35, 0);
      walls[5] = new Wall(5, 260, 0, 10, 330, 0);
      walls[6] = new Wall(6, 200, 200, 10, 130, 0);
      //Triggers and trigger walls
      walls[7] = new Wall(15, 210, 100, 50, 10, 1);
      walls[8] = new Wall(16, 210, 220, 50, 10, 0);
      walls[9] = new Wall(17, 210, 240, 50, 10, 1);
      walls[10] = new Wall(18, 210, 75, 50, 10, 0);
      walls[11] = new Wall(14, 210, 0, 50, 10, 1);
      walls[12] = new Wall(19, 210, 260, 50, 10, 0);
    } else if (n == 5) {
      RP = new RestartPoint(210, 280, 5);
      walls[0] = new Wall(-7, 210, 0, 50, 10, 3);
      walls[1] = new Wall(-8, 200, 150, 10, 50, 3);

      walls[2] = new Wall(2, 200, 200, 10, 130, 0);
      walls[3] = new Wall(3, 260, 0, 10, 330, 0);
      walls[4] = new Wall(4, 200, 0, 10, 150, 0);
    } else if (n == 6) {
      RP = new RestartPoint(210, 650, 6);
      walls[0] = new Wall(-9, 210, 270, 50, 10, 3);
      walls[1] = new Wall(-10, -200, 270, 50, 10, 3);

      walls[2] = new Wall(13, 260, 270, 10, 380, 0);
      walls[3] = new Wall(20, 215, 340, 20, 30, 0);
      walls[4] = new Wall(21, 230, 390, 30, 10, 0);
      walls[5] = new Wall(22, 215, 420, 20, 30, 0);
      walls[6] = new Wall(23, 230, 470, 30, 10, 0);
      walls[7] = new Wall(25, 230, 550, 30, 10, 0);
      walls[8] = new Wall(24, 215, 500, 20, 30, 200, 250, true, true, 1, 2);
      walls[9] = new Wall(26, 215, 580, 20, 30, 200, 250, true, true, 1, 2);
      walls[10] = new Wall(27, 230, 630, 30, 10, 200, 240, true, true, 1, 2);
      hasMovingWalls = true;
      walls[11] = new Wall(2, 200, 270, 10, 430, 0);
    } else if (n == 7) {
      RP = new RestartPoint(630, 650, 7);
      walls[0] = new Wall(-11, 210, 640, 50, 10, 3);
      walls[1] = new Wall(-12, 200, 640, 10, 60, 3);
  
      
      walls[2] = new Wall(2, 260, 640, 440, 10, 0);
      walls[3] = new Wall(3, 270, 686, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      walls[4] = new Wall(4, 270, 674, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      walls[5] = new Wall(5, 270, 662, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      walls[6] = new Wall(6, 270, 650, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      hasMovingWalls = true;
      
    } else if (n == 8) {
      RP = new RestartPoint(270, 200, 8);
      walls[0] = new Wall(13, 620, 640, 10, 60, 3);
      walls[1] = new Wall(-12, -210, 620, 50, 20, 3);

      walls[2] = new Wall(1, 270, 240, 100, 10, 5);
      walls[3] = new Wall(2, 370, 251, 10, 340, 5);
      walls[4] = new Wall(1, 270, 590, 100, 50, 5);
      walls[5] = new Wall(2, 260, 251, 10, 340, 5);
      
      walls[6] = new Wall(29, 370, 250, 10, 400, 0);
      walls[7] = new Wall(30, 320, 240, 60, 10, 0);
      walls[8] = new Wall(80, 680, 650, 20, 50, 4);
      walls[9] = new Wall(31, 260, 200, 10, 440, 0);
      walls[10] = new Wall(11, 270, 640, 100, 10, 0);
      walls[11] = new Wall(12, 630, 640, 120, 10, 0);
      

      hasBugs = true;

      for (int i = 0; i < bugs.length; i++) {
        bugs[i] = new Critter(275, 365, 255, 585);
      }
    
    } else if (n == 9) {
      RP = new RestartPoint(540, 0, 9);
      walls[0] = new Wall(-13, 260, 250, 70, 10, 3);
      walls[1] = new Wall(-14, -650, 55, 10, 10, 3);
      
      walls[2] = new Wall(1, 590, 0, 10, 60, 0);
      walls[3] = new Wall(3, 320, 50, 10, 200, 0);
      walls[4] = new Wall(4, 330, 50, 210, 10, 0);
      walls[5] = new Wall(5, 260, 0, 10, 250, 0);
      
      
    } else if (n == 10) {
      RP = new RestartPoint(650, 590, 10);
      walls[0] = new Wall(-13, 590, 60, 110, 10, 3);
      walls[1] = new Wall(-14, 530, 0, 10, 60, 3);
      
    //Border Walls [12 - 21]
      walls[12] = new Wall(9, 550, 240, 150, 10, 0);
      walls[13] = new Wall(1, 590, 0, 10, 60, 0);
      walls[14] = new Wall(3, 320, 50, 10, 200, 0);
      walls[15] = new Wall(4, 330, 50, 210, 10, 0);
      walls[16] = new Wall(5, 330, 240, 50, 10, 0);
      walls[17] = new Wall(6, 370, 250, 10, 400, 0);
      walls[18] = new Wall(7, 370, 640, 330, 10, 0);
      walls[19] = new Wall(10, 500, 300, 10, 350, 0);
      walls[20] = new Wall(8, 590, 60, 110, 10, 0);
      walls[21] = new Wall(8, 590, 60, 110, 10, 0);
      
      
    //Obstacles
      //Moving Walls [23-31]
      //First part
      walls[32] = new Wall(20, (int)random(300, 500), 60, 10, 20, 380, 580, true, true, (int)random(2,7), 2);
      walls[23] = new Wall(20, (int)random(300, 600), 80, 10, 20, 380, 690, true, false, (int)random(2,7), 2);
      walls[24] = new Wall(20, (int)random(300, 600), 100, 10, 20, 380, 690, true, true, (int)random(2,7), 2);
      walls[25] = new Wall(20, (int)random(300, 600), 120, 10, 20, 380, 690, true, true, (int)random(2,7), 2);
      walls[26] = new Wall(20, (int)random(300, 600), 140, 10, 20, 380, 690, true, true, (int)random(2,7), 2);
      walls[27] = new Wall(20, (int)random(300, 600), 160, 10, 20, 380, 690, true, false, (int)random(1,4), 2);
      walls[28] = new Wall(20, (int)random(300, 600), 180, 10, 20, 380, 690, true, true, (int)random(2,7), 2);
      walls[29] = new Wall(20, (int)random(300, 600), 200, 10, 20, 380, 690, true, false, (int)random(2,7), 2);
      walls[30] = new Wall(20, (int)random(300, 600), 220, 10, 20, 380, 690, true, true, (int)random(2,7), 2);
      
      //Second part
      walls[31] = new Wall(20, 380, (int)random(301, 640), 20, 10, 300, 630, false, true, (int)random(2,7), 2);
      walls[32] = new Wall(20, 400, (int)random(301, 640), 20, 10, 300, 630, false, true, (int)random(2,7), 2);
      walls[33] = new Wall(20, 420, (int)random(301, 640), 20, 10, 300, 630, false, false, (int)random(2,7), 2);
      walls[34] = new Wall(20, 440, (int)random(301, 640), 20, 10, 300, 630, false, true, (int)random(2,7), 2);
      walls[35] = new Wall(20, 460, (int)random(301, 640), 20, 10, 300, 630, false, false, (int)random(2,7), 2);
      walls[36] = new Wall(20, 480, (int)random(301, 520), 20, 10, 300, 570, false, true, (int)random(2,7), 2);
      
      
      
      //Teleportation areas [22]
      walls[22] = new Wall(81, 330, 60, 50, 180, 4);
      
      //Dot Zones [2 - 11]
      walls[2] = new Wall(2, 530, 0, 10, 59, 5);
      walls[3] = new Wall(2, 320, 50, 10, 200, 5);
      walls[4] = new Wall(1, 330, 50, 209, 10, 5);
      walls[5] = new Wall(1, 330, 240, 49, 10, 5);
      walls[6] = new Wall(2, 370, 251, 10, 400, 5);
      walls[7] = new Wall(1, 370, 640, 330, 10, 5);
      walls[8] = new Wall(1, 591, 60, 110, 10, 5);
      walls[9] = new Wall(2, 700, 60, 10, 590, 5);
      walls[10] = new Wall(1, 540, -10, 50, 10, 5);
      walls[11] = new Wall(2, 590, 0, 10, 69, 5);
      
      
     
      //Triggers and trigger walls
      walls[37] = new Wall(15, 480, 580, 20, 60, 1);
      walls[38] = new Wall(16, 500, 290, 50, 10, 0);
      walls[39] = new Wall(17, 480, 580, 20, 60, 1);
      walls[40] = new Wall(18, 550, 240, 10, 60, 0);
      
      
      
      
      hasMovingWalls = true;
      hasBugs = true;
      //Bugs: 
      for (int i = 0; i < bugs.length; i++) {
        bugs[i] = new Critter(385, 695, 70, 640);
      }
      
      
    } 
    //11 and 12 ARE BUFFERS FOR WINNING AFTER TEN LEVELS
    else if (n == 11) {
      RP = new RestartPoint(150, -590, 11);
      walls[0] = new Wall(-13, -550, 590, 10, 10, 3);
      walls[1] = new Wall(-14, -550, 590, 10, 10, 3);

      walls[2] = new Wall(50, -260, 0, 10, 700, 0);
      //walls[2] = new Wall(3, 370, 570, 250, 10, 0);
      //walls[3] = new Wall(4, 610, 580, 10, 60, 0);
    } else if (n == 12) {
      RP = new RestartPoint(50, -590, 12);
      walls[0] = new Wall(-13, -550, 590, 10, 10, 3);
      walls[1] = new Wall(-14, -550, 590, 10, 10, 3);

      walls[2] = new Wall(50, -260, 0, 10, 700, 0);
      //walls[2] = new Wall(3, 550, 590, 10, 90, 3);
      //walls[3] = new Wall(4, 550, 590, 80, 10, 3);
    } 


    for (int i = 0; i < walls.length; i++) {
      if (walls[i] == null) {
        numWalls = i;
        break;
      }
    }
  }

  public void moveWalls(Wall w) {
    if (w.increase) {                //increase is true;
      if (w.moveX) {                    //moving x
        if (w.x < w.max) {                //x is less than max
          w.x += w.speed;
        } else {                          //x is more than max
          w.increase = false;
          w.x -= w.speed;
        }
      } else {                          // moving y
        if (w.y < w.max) {                //y is less than max
          w.y+= w.speed;
        } else {                          //y is more than max
          w.increase = false;
          w.y-= w.speed;
        }
      }
    } else {                      //increase is false
      if (w.moveX) {                    //moving x
        if (w.x >= w.min) {                //x is less than max
          w.x-= w.speed;
        } else {                          //x is more than max
          w.increase = true;
          w.x+= w.speed;
        }
      } else {                          // moving y
        if (w.y >= w.min) {                //y is less than max
          w.y-= w.speed;
        } else {                          //y is more than max
          w.increase = true;
          w.y+= w.speed;
        }
      }
    }
  }
}
/* DECLARE DATA TYPES FOR GAME */
PlayerCar car; //Players object
Wall[] walls; //Still Walls
Population bots; //Dots
int numberOfWalls = 0; 

Wall movingWalls[]; //Moving Walls
int numberOfMovingWalls = 0;

RestartPoint RP[]; //Restart Points
int numberOfRPs = 0;

int generation = 1; //Current generation, updated everytime all dots die


boolean stageComplete[]; //stageComplete[i] is true if all dots and player are past stage i, otherwise false

Stage allStages[];
int numberOfStages = 0;
Stage currentStages[];
int numCurrentStages = 0;

int winner = -1;//-1 = none, 0 = user, 1 = dots

int numHitTeleporter = 0;

/* END DATA TYPE SET UP */


/* ENVIRONMENT SETTINGS */
public void settings(){
    size(700, 700);
}
/* END ENVIRONMENT SETTINGS */


/* SET UP GLOBAL VARIABLES AND GAME DATA */
public void setup() {
  frameRate(200);
  car = new PlayerCar(0);
  
  walls = new Wall[30];
  //makeWalls();
  movingWalls = new Wall[30];
  //makeMovingWalls();
  RP = new RestartPoint[10];
  //makeRPs();
  stageComplete = new boolean[numberOfStages];
  for(int i = 0; i < numberOfStages; i++){
    stageComplete[i] = true;
  }
  
  allStages = new Stage[13];
  for(int i = 0; i < 13; i++){
    allStages[i] = new Stage(i+1);
  }
  numberOfStages = 13;
  currentStages = new Stage[allStages.length];
  
  bots = new Population(2000);
  //car.atRP = 0;
}
int step = 0;
/* UPDATE EACH STEP */
public void draw() { 
  step++;
  background(255);
  fill(255, 0, 0);
  textSize(12);
  text("Generation: " + generation, 605, 15);
  text("Your Deaths: " + car.numberOfDeaths, 605, 35);
  if(car.atRP > bots.dots[0].atRP){
    text("You're Winning!!", 605, 55);
  }else if(car.atRP < bots.dots[0].atRP){
    text("You're Losing!!", 605, 55);
  }else if(car.atRP == bots.dots[0].atRP){
    text("It's a tie!!", 605, 55);
  }
  numHitTeleporter = 0;
  textSize(26); 
  if(winner == 0){
    text("YOU WIN!!", 400, 25);
  }else if(winner == 1){
    text("THE DOTS WIN!!", 400, 15);
  }
  textSize(14);
  
  getCurrentStages(car.atRP, bots.dots[0].atRP);
  for(int i = 0; i < numCurrentStages; i++){
    currentStages[i].show();
  }
  
  
  checkCollisions();
  
  if(step % 5 == 0){
    if(car.dead){
        car.reset();
    }
  }
  
  /* CHECK IF GENERATION IS OVER, ELSE UPDATE */
  if (bots.allDotsDead()) {
    println("carRP: " + car.atRP);
    //genetic algorithm
    bots.calculateFitness();
    bots.naturalSelection();
    //makeMovingWalls();
    bots.mutateDots();
    generation++;
    //if(car.dead){
    //  car.reset();
    //}
  } else {
    //if any of the dots are still alive then update and then show them
    bots.update();
    bots.show();
    car.update();
    car.display();
  }
  /* END GENERATION CHECK */
}
/* END OF STEP */
  public void getCurrentStages(int carRP, int dotRP){
    for(int i = 0; i < numCurrentStages; i++){
      currentStages[i] = null;
    }
    int diff = carRP - dotRP;
    int absDiff = abs(diff);
    if(diff > 0){
      for(int i = 0; i < diff; i++){
        currentStages[i] = allStages[dotRP + i];
      }
      currentStages[diff] = allStages[carRP];
      currentStages[diff + 1] = allStages[carRP + 1];
    } else if(diff < 0){
      for(int i = 0; i < absDiff; i++){
        currentStages[i] = allStages[carRP + i];
      }
      currentStages[absDiff] = allStages[dotRP];
      currentStages[absDiff+ 1] = allStages[dotRP + 1];
    }else if(diff == 0){
        currentStages[0] = allStages[carRP];
        currentStages[1] = allStages[carRP + 1];
     
    }
    
    for(int i = 0; i < currentStages.length; i++){
      if(currentStages[i] == null){
        numCurrentStages = i;
        break;
      }
    }
    checkStageCompletion(carRP, dotRP);
  }
  
  public void checkStageCompletion(int carRP, int dotRP){
    for(int i = 0; i < allStages.length; i++){
      if(carRP >= i){
        allStages[i].carCompletedPrevious = true;
      }else{
        allStages[i].carCompletedPrevious = false;
      }
      if(dotRP >= i){
        allStages[i].dotsCompletedPrevious = true;
      }else{
        allStages[i].dotsCompletedPrevious = false;
      }
    }
  }
  
  public void checkCollisions(){
    for(int i = 0; i < numCurrentStages; i++){
      //Check RPs
      car = carHitRP(car, currentStages[i].RP);
      for(int j = 0; j < bots.dots.length; j++){
        dotHitRP(bots.dots[j], currentStages[i].RP);
      }
      //Check Walls
      for(int k = 0; k < currentStages[i].numWalls; k++){
        car = carHitWall(car, currentStages[i].walls[k], i, k);
        for(int j = 0; j < bots.dots.length; j++){
          dotHitWall(bots.dots[j], currentStages[i].walls[k], i, k);
        }
      }
      if(currentStages[i].hasBugs){
        for(int j = 0; j < currentStages[i].bugs.length; j++){
          car = carHitBug(car, currentStages[i].bugs[j]);
          for(int l = 0; l < bots.dots.length; l++){
            dotHitBug(bots.dots[l], currentStages[i].bugs[j]);
          }
          for(int k = 0; k < currentStages[i].numWalls; k++){
            bugHitWall(currentStages[i].bugs[j], currentStages[i].walls[k]);
          }
        }
      }
    }
  }

/* CHECK COLLISIONS */
public PlayerCar carHitBug(PlayerCar c, Critter b){
  boolean a = overLap(b.pos.x, b.pos.y, 4, 4, c.x, c.y, c.w, c.h);
  if(a){
    if(!c.dead){
         c.numberOfDeaths ++;
      }
    c.dead = true;
  }
  return c;
}

public void dotHitBug(Dot d, Critter b){
  boolean a = overLap(b.pos.x, b.pos.y, 4, 4, d.pos.x, d.pos.y, 4, 4);
  if(a){
    d.dead = true;
  }
}

public void bugHitWall(Critter b, Wall w){
  boolean a = overLap(b.pos.x, b.pos.y, 1, 1, w.x, w.y, w.w, w.h);
  if(a){
    if(w.num.equals("1")){
      b.vel.y = b.vel.y * -1;
    }else if(w.num.equals("2")){
      b.vel.x = b.vel.x * -1;
    }
    
  }
}

public void dotHitWall(Dot d, Wall w, int stage, int index){
  boolean b = overLap(d.pos.x, d.pos.y, 1, 1, w.x, w.y, w.w, w.h);
  if(w.type == 0 || w.type == 2){
    if(b){
      d.dead = true;
    }
  }else if(w.type == 1){
    if(b){
      currentStages[stage].walls[index+1].x = -500;
      currentStages[stage].walls[index+1].x = -500;
    }
  }else if(w.type == 4){
    if(b){
      d.pos.x = 300;
      d.pos.y = 620;
      numHitTeleporter++;
      if(numHitTeleporter > 200){
        for(int i = 0; i < bots.dots.length; i++){
          bots.dots[i].atRP = 7;
        }
      }
      
    }
    
  }
}

public PlayerCar carHitWall(PlayerCar c, Wall w, int stage, int index){
  boolean b = overLap(c.x, c.y, c.w, c.h, w.x, w.y, w.w, w.h);
  if(w.type == 0 || w.type == 2){
    if(b){
      if(!c.dead){
         c.numberOfDeaths ++;
      }
      c.dead = true;
    }
  }else if(w.type == 1){
    if(b){
      currentStages[stage].walls[index+1].x = -500;
      currentStages[stage].walls[index+1].x = -500;
    }
  }else if(w.type == 4){
    if(b){
      c.atRP = 7;
      c.x = 300;
      c.y = 620;
    }
  }
  return c;
}

public void dotHitRP(Dot d, RestartPoint p){
  boolean b = overLap(d.pos.x, d.pos.y, 1, 1, p.x, p.y, p.w, p.h);
  if(b){
    for(int i = 0; i < bots.dots.length; i++){
      if(bots.dots[i].atRP + 1 == p.val){
         bots.dots[i].atRP = p.val;
      }
      if(bots.dots[i].atRP == 10){
         winner = 1;
         bots.dots[i].atRP = 0;
      }
     
    }
    //d.atRP = p.val;
  }
}

public PlayerCar carHitRP(PlayerCar c, RestartPoint p){
  boolean b = overLap(c.x, c.y, c.w, c.h, p.x, p.y, p.w, p.h);
  if(b){
    c.atRP = p.val;
  }
  if(c.atRP == 10){
    winner = 0;
    c.atRP = 0;
    c.dead = true;
  }
  return c;
}

public boolean overLap(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2){
  return !((x2 > x1 + w1) || //obj2 is right of obj1
           (x2 + w2 < x1) || //obj2 is left of obj1
           (y2 + h2 < y1) || //obj2 is above obj1
           (y2 > y1 + h1)) ; //obj2 is below obj1
}
/* END OF CHECK COLLISIONS */

/* LISTEN FOR USER INPUT */
public void keyPressed() {
  int k = keyCode;
  if (k == ENTER | k == RETURN)
    car.speed = car.speed + 1;
  else if (k == ' ')  
    car.speed = car.speed - 1;
  else if (k == UP)     car.up    = true;
  else if (k == DOWN)   car.down  = true;
  else if (k == LEFT)   car.left  = true;
  else if (k == RIGHT)  car.right = true;
}
public void keyReleased() {
  int k = keyCode;
  if      (k == UP)     car.up    = false;
  else if (k == DOWN)   car.down  = false;
  else if (k == LEFT)   car.left  = false;
  else if (k == RIGHT)  car.right = false;
}
/* END LISTEN FOR USER INPUT */
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RacingGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
