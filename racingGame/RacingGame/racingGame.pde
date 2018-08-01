PVector goal  = new PVector(600, 100);
PVector goal2 = new PVector(605, 650);
PlayerCar car;
Wall[] walls;
Population bots;
int numberOfWalls = 0;
int numberOfCheckpoints = 0;
Wall movingWalls[];
int numberOfMovingWalls = 0;

RestartPoint RP[];
int numberOfRPs = 0;

int generation = 1;

boolean stageOneComplete = true;
boolean stageTwoComplete = true;
void settings(){
    size(720, 720);
}

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
  
  stageOneComplete = true;
  stageTwoComplete = true;
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
  ellipse(goal.x, goal.y, 10, 10);
  ellipse(goal2.x, goal2.y, 10, 10);
  text(generation, 650, 20);
  
  stageOneComplete = true;
  for(int i = 0; i < bots.dots.length; i++){
    if(bots.dots[i].atRP == 0){
      stageOneComplete = false;
    }
  }
  if(car.atRP == 0){
    stageOneComplete = false;
  }
  if(stageOneComplete == true){
    walls[1].w = 100;
  }
  
  stageTwoComplete = true;
  for(int i = 0; i < bots.dots.length; i++){
    if(bots.dots[i].atRP == 1 || bots.dots[i].atRP == 0){
      stageTwoComplete = false;
    }
  }
  if(car.atRP == 1 || car.atRP == 0){
    stageTwoComplete = false;
  }
  if(stageTwoComplete == true){
    walls[9].x = 75;
  }
  
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
    println("stageonecomplete: " + stageOneComplete);
  } else {
    //if any of the dots are still alive then update and then show them
    bots.update();
    bots.show();
  }
}
/* END OF STEP */

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
  boolean b = hitWall(d.pos.x, d.pos.y, 1, 1, w);
  if(b){
    d.dead = true;
  }
}

PlayerCar carHitWall(PlayerCar c, Wall w){
  boolean b = hitWall(c.x, c.y, c.w, c.h, w);
  if(b){
    c.dead = true;
  }
  return c;
}

boolean hitWall(float objX, float objY, float objW, float objH, Wall w){
  
  boolean a =(objX + objW/2 <= w.x + w.w/2 && 
              objX - objW/2 >= w.x - w.w/2 && 
              objY + objH/2 <= w.y + w.h/2 && 
              objY - objH/2 >= w.y - w.h/2);
          return a;
}

boolean hitRP(float objX, float objY, float objW, float objH, RestartPoint w){
  
  boolean a =(objX + objW/2 <= w.x + w.w/2 && 
              objX - objW/2 >= w.x - w.w/2 && 
              objY + objH/2 <= w.y + w.h/2 && 
              objY - objH/2 >= w.y - w.h/2);
          return a;
}

void dotHitRP(Dot d, RestartPoint p){
  boolean b = hitRP(d.pos.x, d.pos.y, 1, 1, p);
  if(b){
    d.atRP = p.val;
  }
}

PlayerCar carHitRP(PlayerCar c, RestartPoint w){
  boolean b = hitRP(c.x, c.y, c.w, c.h, w);
  if(b){
    c.atRP = w.val;
  }
  return c;
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
  walls[0] = new Wall(0,50, 390, 15, 660,0);
  walls[1] = new Wall(1, 10, 60, 30, 15,0);
  walls[2] = new Wall(2, 90, 70, 15, 60,0);
  walls[3] = new Wall(3,100, 100, 100, 15,0);
  walls[4] = new Wall(4,200, 75, 15, 150,0);
  walls[5] = new Wall(5, 175, 150, 50, 15,0);
  walls[6] = new Wall(6, 150, 175, 15, 50,0);
  walls[7] = new Wall(7, 125, 200, 50, 15,0);
  walls[8] = new Wall(8, 100, 425, 15, 450, 0);
  walls[9] = new Wall(9, -75, 640, 50, 15, 0);
  walls[10] = new Wall(10, 200, 470, 15, 500,0);
  for(int i = 0; i < walls.length; i++){
    if(walls[i] == null){
      numberOfWalls = i;
      break;
    }
  }
}

void makeMovingWalls(){
  movingWalls[0] = new Wall(10, 50, 400, 15, 60, 50, 100, true, true, 1,0);
  movingWalls[1] = new Wall(11, 100, 600, 15, 60, 100, 200, true, true, 1,0);
  movingWalls[2] = new Wall(12, 198, 550, 15, 60, 100, 200, true, true, 1,0);
  movingWalls[3] = new Wall(13, 100, 450, 15, 60, 100, 200, true, true, 1,0);
  movingWalls[4] = new Wall(14, 100, 400, 15, 60, 100, 200, true, true, 2,0);
  movingWalls[5] = new Wall(15, 100, 350, 15, 60, 100, 200, true, true, 1,0);
  movingWalls[6] = new Wall(16, 198, 300, 15, 60, 100, 200, true, true, 2,0);
  movingWalls[7] = new Wall(17, 100, 275, 15, 60, 100, 200, true, true, 3,0);
  movingWalls[8] = new Wall(18, 100, 250, 15, 60, 100, 200, true, true, 3,0);
 
  for(int i = 0; i < movingWalls.length; i++){
    if(movingWalls[i] == null){
      numberOfMovingWalls = i;
      break;
    }
  }
}

void makeRPs(){
  RP[0] = new RestartPoint(90, 20, 1);
  RP[1] = new RestartPoint(100, 680, 2);
  RP[2] = new RestartPoint(180, 195, 3);
  
  for(int i = 0; i < RP.length; i++){
    if(RP[i] == null){
      numberOfRPs = i;
      break;
    }
  }
}
/*END OF MAKE OBSTACLES*/
  
