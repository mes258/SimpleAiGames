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

int numberOfStages = 3; //Number of stages in this level
boolean stageComplete[]; //stageComplete[i] is true if all dots and player are past stage i, otherwise false

Stage allStages[];
Stage currentStages[];
int numCurrentStages = 0;

/* END DATA TYPE SET UP */


/* ENVIRONMENT SETTINGS */
void settings(){
    size(700, 700);
}
/* END ENVIRONMENT SETTINGS */


/* SET UP GLOBAL VARIABLES AND GAME DATA */
void setup() {
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
  
  allStages = new Stage[10];
  for(int i = 0; i < 6; i++){
    allStages[i] = new Stage(i+1);
  }
  currentStages = new Stage[6];
  
  bots = new Population(2000);
}
int step = 0;
/* UPDATE EACH STEP */
void draw() { 
  step++;
  background(255);
  fill(255, 0, 0);
  text(generation, 650, 20);
  
  //checkCompletedStage();
  
  //STAGE TEST AREA
  getCurrentStages(car.atRP, bots.dots[0].atRP);
  for(int i = 0; i < numCurrentStages; i++){
    currentStages[i].show();
  }
  
  checkCollisions();
  
  
  //END STAGE TEST AREA
  

  if(step % 10 == 0){
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


//stage methods
  void getCurrentStages(int carRP, int dotRP){
    if(carRP != 0 && dotRP != 0){
      if(carRP == dotRP){
          currentStages[0] = allStages[carRP - 1];
          currentStages[1] = allStages[carRP];
          currentStages[2] = allStages[carRP + 1];
      }else if(carRP > dotRP){
        if(carRP - dotRP == 1){
          currentStages[0] = allStages[dotRP - 1];
          currentStages[1] = allStages[dotRP];
          currentStages[2] = allStages[carRP];
          currentStages[3] = allStages[carRP + 1];
        }else if(carRP - dotRP == 2){
          currentStages[0] = allStages[dotRP - 1];
          currentStages[1] = allStages[dotRP];
          currentStages[2] = allStages[dotRP + 1];
          currentStages[3] = allStages[carRP];
          currentStages[4] = allStages[carRP + 1];
        }else{
          currentStages[0] = allStages[dotRP - 1];
          currentStages[1] = allStages[dotRP];
          currentStages[2] = allStages[dotRP + 1];
          currentStages[3] = allStages[carRP - 1];
          currentStages[4] = allStages[carRP];
          currentStages[5] = allStages[carRP + 1];
        }
      }else if(dotRP > carRP){
        if(carRP - dotRP == 1){
          currentStages[0] = allStages[carRP];
          currentStages[1] = allStages[dotRP];
          currentStages[2] = allStages[dotRP + 1];
        }else if(carRP - dotRP == 2){
          currentStages[0] = allStages[carRP - 1];
          currentStages[1] = allStages[carRP];
          currentStages[2] = allStages[carRP + 1];
          currentStages[3] = allStages[dotRP];
          currentStages[4] = allStages[dotRP + 1];
        }else{
          currentStages[0] = allStages[carRP - 1];
          currentStages[1] = allStages[carRP];
          currentStages[2] = allStages[carRP + 1];
          currentStages[3] = allStages[dotRP - 1];
          currentStages[4] = allStages[dotRP];
          currentStages[5] = allStages[dotRP + 1];
        }
      }
    }else if(carRP == 0 && dotRP == 0){
      currentStages[0] = allStages[carRP];
      currentStages[1] = allStages[carRP + 1];
    }else if(carRP == 0){
      currentStages[0] = allStages[carRP];
      currentStages[1] = allStages[carRP + 1];
      if(dotRP - carRP == 1){
        currentStages[2] = allStages[dotRP + 1];
      }else if(dotRP - carRP == 2){
        currentStages[2] = allStages[dotRP];
        currentStages[3] = allStages[dotRP + 1];
      }else{
        currentStages[2] = allStages[dotRP - 1];
        currentStages[3] = allStages[dotRP];
        currentStages[4] = allStages[dotRP + 1];
      }
    }else if(dotRP == 0){
      currentStages[0] = allStages[dotRP];
      currentStages[1] = allStages[dotRP + 1];
      if(carRP - dotRP == 1){
        currentStages[2] = allStages[carRP + 1];
      }else if(carRP - dotRP == 2){
        currentStages[2] = allStages[carRP];
        currentStages[3] = allStages[carRP + 1];
      }else{
        currentStages[2] = allStages[carRP - 1];
        currentStages[3] = allStages[carRP];
        currentStages[4] = allStages[carRP + 1];
      }
    }
    
      
    for(int i = 0; i < currentStages.length; i++){
      if(currentStages[i] == null){
        numCurrentStages = i;
        break;
      }
    }
    checkStageCompletion(carRP, dotRP);
  }
  
  void checkStageCompletion(int carRP, int dotRP){
    for(int i = 0; i < allStages.length; i++){
      if(carRP > i){
        allStages[i].carCompleted = true;
      }
      if(dotRP > i){
        allStages[i].dotsCompleted = true;
      }
    }
  }
  
  void checkCollisions(){
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
    }
  }


//end of stage methods


/* MOVE WALLS */
void updateWall(Wall w){
  if(w.increase){                //increase is true;
    if(w.moveX){                    //moving x
      if(w.x < w.max){                //x is less than max
        w.x += w.speed;
      }else{                          //x is more than max
        w.increase = false;
        w.x -= w.speed;
      }
    }else{                          // moving y
      if(w.y < w.max){                //y is less than max
        w.y+= w.speed;
      }else{                          //y is more than max
        w.increase = false;
        w.y-= w.speed;
      }
    }
  }else{                      //increase is false
    if(w.moveX){                    //moving x
      if(w.x >= w.min){                //x is less than max
        w.x-= w.speed;
      }else{                          //x is more than max
        w.increase = true;
        w.x+= w.speed;
      }
    }else{                          // moving y
      if(w.y >= w.min){                //y is less than max
        w.y-= w.speed;
      }else{                          //y is more than max
        w.increase = true;
        w.y+= w.speed;
      }
    }
  }
}
/* END OF MOVE WALLS */

/* CHECK COLLISIONS */
void dotHitWall(Dot d, Wall w, int stage, int index){
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
  }
}

PlayerCar carHitWall(PlayerCar c, Wall w, int stage, int index){
  boolean b = overLap(c.x, c.y, c.w, c.h, w.x, w.y, w.w, w.h);
  if(w.type == 0 || w.type == 2){
    if(b){
      c.dead = true;
    }
  }else if(w.type == 1){
    if(b){
      currentStages[stage].walls[index+1].x = -500;
      currentStages[stage].walls[index+1].x = -500;
    }
  }
  return c;
}

void dotHitRP(Dot d, RestartPoint p){
  boolean b = overLap(d.pos.x, d.pos.y, 1, 1, p.x, p.y, p.w, p.h);
  if(b){
    d.atRP = p.val;
  }
}

PlayerCar carHitRP(PlayerCar c, RestartPoint p){
  boolean b = overLap(c.x, c.y, c.w, c.h, p.x, p.y, p.w, p.h);
  if(b){
    c.atRP = p.val;
  }
  return c;
}

boolean overLap(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2){
  return !((x2 > x1 + w1) || //obj2 is right of obj1
           (x2 + w2 < x1) || //obj2 is left of obj1
           (y2 + h2 < y1) || //obj2 is above obj1
           (y2 > y1 + h1)) ; //obj2 is below obj1
}
/* END OF CHECK COLLISIONS */

/* LISTEN FOR USER INPUT */
void keyPressed() {
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
void keyReleased() {
  int k = keyCode;
  if      (k == UP)     car.up    = false;
  else if (k == DOWN)   car.down  = false;
  else if (k == LEFT)   car.left  = false;
  else if (k == RIGHT)  car.right = false;
}
/* END LISTEN FOR USER INPUT */

/* MAKE OBSTACLES */
void makeWalls(){
  //         dist from: Left,Top,  w,  h
 
  //STAGE 1
  walls[0] = new Wall(0, 50, 70, 10, 630, 0);
  walls[1] = new Wall(1, 0, 60, 30, 10,0);
  walls[2] = new Wall(2, 95, 50, 10, 60,0);
  //STAGE 2
  walls[3] = new Wall(3, 60, 100, 80, 10,0);
  walls[4] = new Wall(4, 200, 0, 10, 150,0);
  walls[5] = new Wall(5, 150, 140, 60, 10,0);
  walls[6] = new Wall(6, 150, 140, 10, 35,0);
  walls[7] = new Wall(7, 125, 165, 35, 10,0);
  walls[8] = new Wall(8, 125, 165, 10, 35,0);
  walls[9] = new Wall(9, 100, 190, 35, 10,0);
  walls[10] = new Wall(10, 100, 190, 10, 460, 0);
  walls[11] = new Wall(11, -75, 630, 50, 10, 0);
  //STAGE 3
  walls[12] = new Wall(12, 200, 200, 10, 500,0);
  //STAGE 4 AND 5
  walls[13] = new Wall(13, 260, 0, 10, 650, 0);
  //Triggers and trigger walls - the trigger must be the wall directly before the wall it hides.
  walls[14] = new Wall(15, 210, 100, 50, 10, 1);
  walls[15] = new Wall(16, 210, 220, 50, 10, 0);
  walls[16] = new Wall(17, 210, 240, 50, 10, 1);
  walls[17] = new Wall(18, 210, 75, 50, 10, 0);
  walls[18] = new Wall(14, 210, 0, 50, 10, 1);
  walls[19] = new Wall(19, 210, 260, 50, 10, 0);
  //STAGE 6
  walls[20] = new Wall(20, 215, 340, 20, 30, 0);
  walls[21] = new Wall(21, 230, 390, 30, 10, 0);
  walls[22] = new Wall(22, 215, 420, 20, 30, 0);
  walls[23] = new Wall(23, 230, 470, 30, 10, 0);
  //walls[24] = new Wall(24, 215, 500, 20, 30, 0);
  walls[24] = new Wall(25, 230, 550, 30, 10, 0);
  //walls[26] = new Wall(26, 215, 580, 20, 30, 0);
  //walls[27] = new Wall(27, 230, 630, 30, 10, 0);

  for(int i = 0; i < walls.length; i++){
    if(walls[i] == null){
      numberOfWalls = i;
      break;
    }
  }
}




/*END OF MAKE OBSTACLES*/
  
