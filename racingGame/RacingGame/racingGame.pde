PVector goal  = new PVector(600, 100);
PVector goal2 = new PVector(605, 650);
PlayerCar car;
Wall[] walls;
Checkpoint[] cp;
Population bots;
int numberOfWalls = 0;
int numberOfCheckpoints = 0;

int generation = 1;
void setup() {
  size(800, 800);
  frameRate(200);
  car = new PlayerCar();
  bots = new Population(3000);
  walls = new Wall[30];
  makeWalls();
  cp = new Checkpoint[35];
  makeCheckpoints();
}

void draw() { 
  background(255);
  //draw goal
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, 10, 10);
  ellipse(goal2.x, goal2.y, 10, 10);
  
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
    bots.mutateDemBabies();
    if(car.dead){
      car.reset();
    }
  } else {
    //if any of the dots are still alive then update and then show them
    bots.update();
    bots.show();
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
  }
}

boolean hitCP(float objX, float objY, float objW, float objH, Checkpoint c){
  
  boolean a =(objX + objW/2 <= c.x + c.w/2 && 
              objX - objW/2 >= c.x - c.w/2 && 
              objY + objH/2 <= c.y + c.h/2 && 
              objY - objH/2 >= c.y - c.h/2);
          return a;

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
  walls[0] = new Wall(100, 750, 15, 100);
  walls[1] = new Wall(75, 700, 50, 15);
  walls[2] = new Wall(50, 400, 15, 600);
  walls[3] = new Wall(100, 100, 100, 15);
  walls[4] = new Wall(200, 75, 15, 150);
  walls[5] = new Wall(150, 150, 100, 15);
  walls[6] = new Wall(100, 400, 15, 500);
  
  
  numberOfWalls = 7;
}

void makeCheckpoints(){
  for(int i = 0; i < 20; i++){
     cp[i] = new Checkpoint(15, (i+1)*30, 19-i);
  }
  cp[20] = new Checkpoint(150, 70, 21);
  cp[21] = new Checkpoint(150, 120, 22);
  for(int i = 22; i< 31; i++){
    int k = i-21;
    if(i == 22){
      cp[i] = new Checkpoint(75, k*70, 20);
    } else{
      cp[i] = new Checkpoint(75, k*70, i);
    }
  }
  numberOfCheckpoints = 31;
}
  
