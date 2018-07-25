PVector goal  = new PVector(600, 100);
PVector goal2 = new PVector(605, 650);
PlayerCar car;
Wall[] walls;
Checkpoint[] cp;
Population bots;
int numberOfWalls = 0;
int numberOfCheckpoints = 0;
Wall movingWalls[];
int numberOfMovingWalls = 0;

RestartPoint RP[];
int numberOfRPs = 0;

int generation = 1;
void settings(){
    size(720, 720);
}

void setup() {

  frameRate(200);
  car = new PlayerCar(0);
  bots = new Population(2000);
  walls = new Wall[30];
  makeWalls();
  cp = new Checkpoint[200];
  makeCheckpoints();
  movingWalls = new Wall[30];
  makeMovingWalls();
  
  RP = new RestartPoint[10];
  makeRPs();
  
}
int step = 0;
void draw() { 
  step++;
  background(255);
  //draw goal
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, 10, 10);
  ellipse(goal2.x, goal2.y, 10, 10);
  text(generation, 650, 20);
  
  for(int i = 0; i < numberOfRPs; i++){
    RP[i].show();
    car = carHitRP(car, RP[i]);
    for(int j = 0; j < bots.dots.length; j++){
      dotHitRP(bots.dots[j], RP[i]);
    }
  }
  
  for(int i = 0; i < numberOfMovingWalls; i++){
    updateWall(movingWalls[i]);
    movingWalls[i].show();
    car = carHitWall(car, movingWalls[i]);
    for(int j = 0; j < bots.dots.length; j++){
        dotHitWall(bots.dots[j], movingWalls[i]);
    }
  }
  
  
  for(int i = 0; i < numberOfWalls; i++){
    walls[i].show();
    car = carHitWall(car, walls[i]);
    for(int j = 0; j < bots.dots.length; j++){
      dotHitWall(bots.dots[j], walls[i]);
    }
  }
  
  for(int i = 0; i < numberOfCheckpoints; i++){
    cp[i].show();
    for(int j = 0; j < bots.dots.length; j++){
      dotHitCP(bots.dots[j], cp[i]);
    }
  }
    car.update();
    car.display();
  
  
  if (bots.allDotsDead()) {
    //genetic algorithm
    bots.calculateFitness();
    bots.naturalSelection();
    makeMovingWalls();
    bots.mutateDots();
    generation++;
    if(car.dead){
      car.reset();
    }
  } else {
    //if any of the dots are still alive then update and then show them
    bots.update();
    bots.show();
  }
}

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
void dotHitCP(Dot d, Checkpoint c){
  boolean b = hitCP(d.pos.x, d.pos.y, 1, 1, c);
  if(b){
      d.atCheckpoint = c.val;
    d.steps = step;
  }
}

boolean hitCP(float objX, float objY, float objW, float objH, Checkpoint c){
  
  boolean a =(objX + objW/2 <= c.x + c.w/2 && 
              objX - objW/2 >= c.x - c.w/2 && 
              objY + objH/2 <= c.y + c.h/2 && 
              objY - objH/2 >= c.y - c.h/2);
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
void makeWalls(){
  //         dist from: Left,Top,  w,  h
  //walls[x] = new Wall(500, 500, 50, 100);
  walls[0] = new Wall(0,50, 390, 15, 660);
  walls[1] = new Wall(1, 10, 60, 30, 15);
  walls[2] = new Wall(2, 90, 70, 15, 60);
  walls[3] = new Wall(3,100, 100, 100, 15);
  walls[4] = new Wall(4,200, 75, 15, 150);
  walls[5] = new Wall(5,150, 150, 100, 15);
  walls[6] = new Wall(6,100, 400, 15, 500);
  walls[7] = new Wall(7, 200, 470, 15, 500);
  numberOfWalls = 8;
}

void makeMovingWalls(){
  movingWalls[0] = new Wall(10, 50, 400, 15, 60, 50, 100, true, true, 1);
  movingWalls[1] = new Wall(11, 100, 400, 15, 60, 100, 200, true, true, 1);
  movingWalls[2] = new Wall(12, 100, 550, 15, 60, 100, 200, true, true, 1);
  movingWalls[3] = new Wall(13, 100, 450, 15, 60, 100, 200, true, true, 1);
  movingWalls[4] = new Wall(14, 100, 600, 15, 60, 100, 200, true, true, 2);
  movingWalls[5] = new Wall(15, 100, 250, 15, 60, 100, 200, true, true, 2);
  movingWalls[6] = new Wall(16, 100, 300, 15, 60, 100, 200, true, true, 3);
  movingWalls[7] = new Wall(17, 100, 275, 15, 60, 100, 200, true, true, 3);
  
  
  numberOfMovingWalls = 8;
}

void makeCheckpoints(){
  for(int i = 0; i < 40; i++){
     cp[i] = new Checkpoint(20, (i+1)*15 + 50, 39-i);
  }
  cp[40] = new Checkpoint(40, 50, 40);
  cp[41] = new Checkpoint(55, 35, 41);
  cp[42] = new Checkpoint(75, 25, 42);
  cp[43] = new Checkpoint(90, 20, 43);
  cp[44] = new Checkpoint(105, 25, 44);
  cp[45] = new Checkpoint(125, 35, 45);
  cp[46] = new Checkpoint(135, 45, 46);
  
  cp[47] = new Checkpoint(145, 55, 47);
  cp[48] = new Checkpoint(155, 65, 48);
  cp[49] = new Checkpoint(160, 75, 49);
  cp[50] = new Checkpoint(165, 85, 50);
  cp[51] = new Checkpoint(170, 100, 51);
  cp[52] = new Checkpoint(165, 110, 52);
  
  cp[53] = new Checkpoint(155, 115, 53);
  cp[54] = new Checkpoint(135, 120, 54);
  cp[55] = new Checkpoint(120, 125, 55);
  cp[56] = new Checkpoint(105, 130, 56);
  cp[57] = new Checkpoint(90, 135, 57);
  cp[58] = new Checkpoint(80, 140, 58);
 
  for(int i = 59; i< 93; i++){
    int k = i-58;
    cp[i] = new Checkpoint(75, 130+(k*15), i);
  }
  cp[93] = new Checkpoint(80, 655, 94);
  cp[94] = new Checkpoint(90, 660, 95);
  cp[95] = new Checkpoint(100, 665, 96);
  cp[96] = new Checkpoint(110, 665, 97);
  cp[97] = new Checkpoint(120, 660, 98);
  cp[98] = new Checkpoint(130, 655, 99);
  
  for(int i = 99; i< 129; i++){
    int k = i-98;
    cp[i] = new Checkpoint(150, 190+(k*15), 70, 130-k);
  }
  
  for(int i = 0; i < cp.length; i++){
    if(cp[i] == null){
      print(i);
      numberOfCheckpoints = i;
      break;
    }
  }
}

void makeRPs(){
  RP[0] = new RestartPoint(90, 20, 1);
  RP[1] = new RestartPoint(120, 680, 2);
  
  for(int i = 0; i < RP.length; i++){
    if(RP[i] == null){
      numberOfRPs = i;
      break;
    }
  }
}
  
