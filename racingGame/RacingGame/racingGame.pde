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
  for(int i = 0; i < 10; i++){
    allStages[i] = new Stage(i+1);
  }
  numberOfStages = 7;
  currentStages = new Stage[6];
  
  bots = new Population(2000);
  //car.atRP = 7;
}
int step = 0;
/* UPDATE EACH STEP */
void draw() { 
  step++;
  background(255);
  fill(255, 0, 0);
  text(generation, 650, 20);
  
  
  getCurrentStages(car.atRP, bots.dots[0].atRP);
  //getCurrentStages(5, 4);
  for(int i = 0; i < numCurrentStages; i++){
    currentStages[i].show();
  }
  
  checkCollisions();
  
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
PlayerCar carHitBug(PlayerCar c, Critter b){
  boolean a = overLap(b.pos.x, b.pos.y, 4, 4, c.x, c.y, c.w, c.h);
  if(a){
    c.dead = true;
  }
  return c;
}

void dotHitBug(Dot d, Critter b){
  boolean a = overLap(b.pos.x, b.pos.y, 4, 4, d.pos.x, d.pos.y, 4, 4);
  if(a){
    d.dead = true;
  }
}

void bugHitWall(Critter b, Wall w){
  boolean a = overLap(b.pos.x, b.pos.y, 1, 1, w.x, w.y, w.w, w.h);
  if(a){
    if(w.num.equals("1")){
      b.vel.y = b.vel.y * -1;
    }else if(w.num.equals("2")){
      b.vel.x = b.vel.x * -1;
    }
    
  }
}

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
  }else if(w.type == 4){
    if(b){
      d.pos.x = 300;
      d.pos.y = 620;
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
  }else if(w.type == 4){
    if(b){
      c.x = 300;
      c.y = 620;
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
