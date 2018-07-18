PVector goal  = new PVector(10, 10);
PlayerCar car;
Wall[] walls;
Population bots;

int generation = 1;
void setup() {
  size(800, 800);
  frameRate(200);
  car = new PlayerCar();
  bots = new Population(2000);
  walls = new Wall[30];
  makeWalls();
  //for(int i = 1; i < 10; i++){
  //  walls[i] = new Wall(i*10, i*20, 30, 10);
  //}
}

void draw() { 
  background(255);
  //draw goal
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, 10, 10);
  
  for(int i = 0; i < 3; i++){
    walls[i].show();
    car = carHitWall(car, walls[i]);
    for(int j = 0; j < bots.dots.length; j++){
      dotHitWall(bots.dots[j], walls[i]);
    }
  }
 
    car.update();
    car.display();
  
  
  if (bots.allDotsDead()) {
    //genetic algorithm
    bots.calculateFitness();
    bots.naturalSelection();
    bots.mutateDemBabies();
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
}
  
