PVector goal  = new PVector(790, 400);
PlayerCar car;
Wall[] walls;

int generation = 1;
void setup() {
  size(800, 800);
  frameRate(200);
  car = new PlayerCar();
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
  
  //for(int i = 0; i < 10; i++){
  //  walls[i].show();
  //}
  
  car.display();
  car.move();
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
  walls[0] = new Wall(500, 500, 50, 100);
}
  
