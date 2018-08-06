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
boolean gameOver = false;

int numHitTeleporter = 0;


//Game over vars: 
int rectX, rectY; // Position of square button
int rectW = 180;     // Width of restart button
int rectH = 90; 
boolean rectOver = false; // True if mouse over button
boolean restartButtonClicked = false; //True if clicked over button

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
  
  allStages = new Stage[13];
  for(int i = 0; i < 13; i++){
    allStages[i] = new Stage(i+1);
  }
  numberOfStages = 13;
  currentStages = new Stage[allStages.length];
  
  bots = new Population(2000);
  
  rectX = width/2-rectW/2;
  rectY = height/2-rectH/2;
  
  //Cheating Area: 
  //car.atRP = 9;
  //car.x = 600;
  //car.y = 600;
}
int step = 0;
/* UPDATE EACH STEP */
void draw() { 
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
  
  if(gameOver){
    textSize(26);
    textAlign(CENTER);
    if(winner == 0){
      text("YOU WIN!!", 350, 100);
    }else if(winner == 1){
      text("THE DOTS WIN!!", 350, 100);
    }
    update(mouseX, mouseY);
    rect(rectX, rectY, rectW, rectH);
    fill(0, 0, 255);
    text("Restart", rectX + rectW/2, rectY + rectH/2);
    if(restartButtonClicked){
      car.atRP = 0;
      car.dead = true;
      for(int i = 0; i < bots.dots.length; i++){
         bots.dots[i].atRP = 0; 
         bots.dots[i].dead = true;
      }
      generation = 0;
      car.numberOfDeaths = 0;
      gameOver = false;
      restartButtonClicked = false;
    }
  }else{
    textSize(14);
    //textAlign(RIGHT);
    
    getCurrentStages(car.atRP, bots.dots[0].atRP);
    for(int i = 0; i < numCurrentStages; i++){
      currentStages[i].show();
    }
    //allStages[1].show();
    //allStages[2].show();
    
    checkCollisions();
    
    if(step % 5 == 0){
      if(car.dead){
          car.reset();
      }
    }
    
    for(int i = 0; i < bots.dots.length; i++){
      if(bots.dots[i].dead){
        bots.getNewDot(i);
      } else {
        bots.dots[i].update();
      }
    }
    
    bots.show();
    
    car.update();
    car.display();
    
    }
  /* END GENERATION CHECK */
}
/* END OF STEP */

  void update(int x, int y) {
    if ( overRect(rectX, rectY, rectW, rectH) ) {
      rectOver = true;
    }
  }

  boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  void mousePressed() {
    if (rectOver) {
      restartButtonClicked = true;
    }
  }
  
  void getCurrentStages(int carRP, int dotRP){
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
    
    if(carRP > 7 && dotRP > 7){
      if(numHitTeleporter > 0){
        currentStages[numCurrentStages] = allStages[7];
        numCurrentStages++;
      }
    }
    
    checkStageCompletion(carRP, dotRP);
  }
  
  void checkStageCompletion(int carRP, int dotRP){
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
    if(!c.dead){
         c.numberOfDeaths ++;
      }
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
      d.pos.x = 320;
      d.pos.y = 615;
      d.atRP = 7;
      numHitTeleporter++;
      //if(numHitTeleporter > 200){
      //  for(int i = 0; i < bots.dots.length; i++){
      //    bots.dots[i].atRP = 7;
      //  }
      //}
    }
  }
}

PlayerCar carHitWall(PlayerCar c, Wall w, int stage, int index){
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
      c.x = 315;
      c.y = 610;
    }
  }
  return c;
}

void dotHitRP(Dot d, RestartPoint p){
  boolean newRP = false;
  boolean b = overLap(d.pos.x, d.pos.y, 1, 1, p.x, p.y, p.w, p.h);
  if(b){
    for(int i = 0; i < bots.dots.length; i++){
      if(bots.dots[i].atRP + 1 == p.val){
         bots.dots[i].rpChanged = true;
         bots.dots[i].atRP = p.val;
         newRP = true;
      }
      if(bots.dots[i].atRP == 10){
         winner = 1;
         gameOver = true;
      }
      //if(bots.dots[i].atRP == 1){
      //   bots.dots[i].atRP = 2;
      //}
    }
    if(newRP){
        bots.naturalSelection();
        newRP = false;
      }
  }
}

PlayerCar carHitRP(PlayerCar c, RestartPoint p){
  boolean b = overLap(c.x, c.y, c.w, c.h, p.x, p.y, p.w, p.h);
  if(b){
    c.atRP = p.val;
  }
  if(c.atRP == 10){
    winner = 0;
    gameOver = true;
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
