//PVector goal  = new PVector(600, 100);
//PVector goal2 = new PVector(605, 650);

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
  bots = new Population(2000);
  walls = new Wall[30];
  makeWalls();
  movingWalls = new Wall[30];
  makeMovingWalls();
  
  RP = new RestartPoint[10];
  makeRPs();
  
  stageComplete = new boolean[numberOfStages];
  for(int i = 0; i < numberOfStages; i++){
    stageComplete[i] = true;
  }
}
int step = 0;
/* UPDATE EACH STEP */
void draw() { 
  //Now based on distance to next RP
  //add more slopes (above RP 3)
  //slower, pre programmed dot that never dies
  
  step++;
  background(255);
  //draw goal
  fill(255, 0, 0);
  //ellipse(goal.x, goal.y, 10, 10);
  //ellipse(goal2.x, goal2.y, 10, 10);
  text(generation, 650, 20);
  
  checkCompletedStage();
  
  arc(500, 500, 50, 50, PI, 1.5* PI);
  
  
  for(int i = 0; i < numberOfRPs; i++){
    RP[i].show();
    car = carHitRP(car, RP[i]);
    for(int j = 0; j < bots.dots.length; j++){
      dotHitRP(bots.dots[j], RP[i]);
    }
  }
  
  for(int i = 0; i < numberOfMovingWalls; i++){
    updateWall(movingWalls[i]);
    movingWalls[i].show(movingWalls[i].type);
    car = carHitWall(car, movingWalls[i]);
    for(int j = 0; j < bots.dots.length; j++){
        dotHitWall(bots.dots[j], movingWalls[i]);
    }
  }
  
  
  for(int i = 0; i < numberOfWalls; i++){
    walls[i].show(walls[i].type);
    car = carHitWall(car, walls[i]);
    for(int j = 0; j < bots.dots.length; j++){
      dotHitWall(bots.dots[j], walls[i]);
    }
  }
    car.update();
    car.display();
  
  
  if (bots.allDotsDead()) {
    //genetic algorithm
    println("Generation: " + generation);
    bots.calculateFitness();
    bots.naturalSelection();
    //makeMovingWalls();
    bots.mutateDots();
    generation++;
   
    if(car.dead){
      car.reset();
    }
    println("car rp: " + car.atRP);

  } else {
    //if any of the dots are still alive then update and then show them
    bots.update();
    bots.show();
  }
}
/* END OF STEP */

/* CHECK STAGE COMPLETION */
void checkCompletedStage(){
  for(int j = 0; j < numberOfStages; j++){
    stageComplete[j] = true;
    for(int i = 0; i < bots.dots.length; i++){
      if(bots.dots[i].atRP == j){
        stageComplete[j] = false;
      }
    }
    if(car.atRP == j){
      stageComplete[j] = false;
    }
  
    if(stageComplete[0] == true){
      walls[1].w = 60;
    }
    if(stageComplete[1] == true){
      walls[11].x = 75;
    }else{
      walls[11].x = -75;
    }
  }
}

/* END STAGE COMPLETION CHECK */

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


void dotHitWall(Dot d, Wall w){
  boolean b = overLap(d.pos.x, d.pos.y, 1, 1, w.x, w.y, w.w, w.h);
  if(b){
    d.dead = true;
  }
}

PlayerCar carHitWall(PlayerCar c, Wall w){
  boolean b = overLap(c.x, c.y, c.w, c.h, w.x, w.y, w.w, w.h);
  if(b){
    c.dead = true;
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
  //walls[x] = new Wall(500, 500, 50, 100);
  //walls[8] = new Wall(8, 400, 400, 50, 50, PI, 1.5*PI,1);
  walls[0] = new Wall(0, 50, 70, 10, 630, 0);
  walls[1] = new Wall(1, 0, 60, 30, 10,0);
  walls[2] = new Wall(2, 95, 50, 10, 60,0);
  walls[3] = new Wall(3, 60, 100, 80, 10,0);
  walls[4] = new Wall(4, 200, 0, 10, 150,0);
  walls[5] = new Wall(5, 150, 140, 60, 10,0);
  walls[6] = new Wall(6, 150, 140, 10, 35,0);
  walls[7] = new Wall(7, 125, 165, 35, 10,0);
  walls[8] = new Wall(8, 125, 165, 10, 35,0);
  walls[9] = new Wall(9, 100, 190, 35, 10,0);
  
  walls[10] = new Wall(10, 100, 190, 10, 460, 0);
  walls[11] = new Wall(11, -75, 640, 50, 10, 0);
  walls[12] = new Wall(12, 200, 200, 10, 500,0);
  
  for(int i = 0; i < walls.length; i++){
    if(walls[i] == null){
      numberOfWalls = i;
      break;
    }
  }
}

void makeMovingWalls(){
  movingWalls[0] = new Wall(10, 50, 400, 10, 60, 50, 100, true, true, 1,0);
  movingWalls[1] = new Wall(11, 100, 600, 10, 60, 100, 200, true, true, 1,0);
  movingWalls[2] = new Wall(12, 198, 550, 10, 60, 100, 200, true, true, 1,0);
  movingWalls[3] = new Wall(13, 100, 450, 10, 60, 100, 200, true, true, 1,0);
  movingWalls[4] = new Wall(14, 100, 400, 10, 60, 100, 200, true, true, 2,0);
  movingWalls[5] = new Wall(15, 100, 350, 10, 60, 100, 200, true, true, 1,0);
  movingWalls[6] = new Wall(16, 198, 300, 10, 60, 100, 200, true, true, 2,0);
  movingWalls[7] = new Wall(17, 100, 275, 10, 60, 100, 200, true, true, 3,0);
  movingWalls[8] = new Wall(18, 100, 250, 10, 60, 100, 200, true, true, 3,0);
 
  for(int i = 0; i < movingWalls.length; i++){
    if(movingWalls[i] == null){
      numberOfMovingWalls = i;
      break;
    }
  }
}

void makeRPs(){
  RP[0] = new RestartPoint(75, 0, 1);
  RP[1] = new RestartPoint(80, 650, 2);
  RP[2] = new RestartPoint(160, 150, 3);
  
  for(int i = 0; i < RP.length; i++){
    if(RP[i] == null){
      numberOfRPs = i;
      break;
    }
  }
}
/*END OF MAKE OBSTACLES*/
  
