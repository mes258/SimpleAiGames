class Stage {
  
  int stageNum = 0;
  
  Wall[] walls; //All walls
  int numWalls = 0; 

  RestartPoint RP; //Restart Point
  
  boolean dotsCompleted = false;
  boolean carCompleted = false;
  
  boolean hasMovingWalls = false;
  

  Stage(int stageNum) {
   this.stageNum = stageNum;
   walls = new Wall[30];
   makeStage(stageNum);
  }
  
  void show(){
    RP.show();
    if(hasMovingWalls){
      for(int i = 0; i < numWalls; i ++){
        if(walls[i].type == 2){
          moveWalls(walls[i]);
        }
      }
    }
    if(dotsCompleted && carCompleted){
      walls[0].type = 0;
      walls[1].type = 0;
    }
    for(int i = 0; i < numWalls; i++){
      walls[i].show(walls[i].type);
    }
  }
  
  void makeStage(int n){
    //Wall types: 0 = normal wall, 1 = trigger wall, 2 = moving wall, 3 = hidden wall
    if(n == 1){               //STAGE 1
      RP  = new RestartPoint(75, 0, 1);
      walls[0] = new Wall(-1, 65, 50, 30, 10, 3);
      walls[1] = new Wall(-2, 65, 0, 10, 50, 3);
      
      walls[2] = new Wall(0, 50, 70, 10, 630, 0);
      walls[3] = new Wall(1, 0, 60, 30, 10, 0);
      walls[4] = new Wall(2, 95, 50, 10, 60,0);
      walls[5] = new Wall(3, 60, 100, 80, 10,0);
    }else if(n == 2){         //STAGE 2
      RP = new RestartPoint(80, 650, 2);
      walls[0] = new Wall(-3, 70, 640, 30, 10, 3);
      walls[1] = new Wall(-4, 70, 640, 10, 60, 3);
      
      walls[2] = new Wall(4, 200, 0, 10, 150,0);
      walls[3] = new Wall(5, 150, 140, 60, 10,0);
      walls[4] = new Wall(6, 150, 140, 10, 35,0);
      walls[5] = new Wall(7, 125, 165, 35, 10,0);
      walls[6] = new Wall(8, 125, 165, 10, 35,0);
      walls[7] = new Wall(9, 100, 190, 35, 10,0);
      walls[8] = new Wall(10, 100, 190, 10, 460, 0);
      walls[9] = new Wall(10, 50, 400, 10, 60, 50, 100, true, true, 1,2);
      hasMovingWalls = true;
    }else if (n == 3){         //STAGE 3
      RP = new RestartPoint(160, 150, 3);
      walls[0] = new Wall(-5, 150, 170, 10, 40, 3);
      walls[1] = new Wall(-6, 150, 200, 60, 10, 3);
      
      walls[2] = new Wall(12, 200, 200, 10, 500,0);
      walls[3] = new Wall(11, 98, 580, 10, 60, 100, 200, true, true, 1,2);
      walls[4] = new Wall(12, 198, 550, 10, 60, 100, 200, true, true, 1,2);
      walls[5] = new Wall(13, 120, 450, 10, 60, 100, 200, true, true, 1,2);
      walls[6] = new Wall(14, 150, 400, 10, 60, 100, 200, true, true, 2,2);
      walls[7] = new Wall(15, 180, 350, 10, 60, 100, 200, true, true, 1,2);
      walls[8] = new Wall(16, 198, 250, 10, 60, 100, 200, true, true, 2,2);
      walls[9] = new Wall(17, 140, 300, 10, 60, 100, 165, true, true, 3,2);
      walls[10] = new Wall(18, 100, 200, 10, 60, 100, 200, true, true, 3,2);
      hasMovingWalls = true;
    }else if(n == 4){
      RP = new RestartPoint(210, 10, 4);
      walls[0] = new Wall(-7, 210, 0, 50, 10, 3);
      walls[1] = new Wall(-8, 200, 150, 10, 50, 3);
      
      walls[2] = new Wall(4, 200, 0, 10, 150,0);
      walls[3] = new Wall(5, 150, 140, 60, 10,0);
      walls[4] = new Wall(6, 150, 140, 10, 35,0);
      walls[5] = new Wall(7, 125, 165, 35, 10,0);
      walls[6] = new Wall(8, 125, 165, 10, 35,0);
      walls[7] = new Wall(9, 100, 190, 35, 10,0);
      walls[8] = new Wall(10, 100, 190, 10, 460, 0);
      walls[9] = new Wall(13, 260, 0, 10, 650, 0);
      //Triggers and trigger walls
      walls[10] = new Wall(15, 210, 100, 50, 10, 1);
      walls[11] = new Wall(16, 210, 220, 50, 10, 0);
      walls[12] = new Wall(17, 210, 240, 50, 10, 1);
      walls[13] = new Wall(18, 210, 75, 50, 10, 0);
      walls[14] = new Wall(14, 210, 0, 50, 10, 1);
      walls[15] = new Wall(19, 210, 260, 50, 10, 0);
    }else if(n == 5){
      RP = new RestartPoint(210, 280, 5);
      walls[0] = new Wall(-9, 210, 270, 50, 10, 3);
      walls[1] = new Wall(-10, -200, 270, 50, 10, 3);
      
      walls[2] = new Wall(12, 200, 200, 10, 500,0);
      walls[3] = new Wall(100, 500, 500, 50, 20, 0);
      walls[4] = new Wall(101, 400, 600, 34, 23, 0);
    }else if(n == 6){
      RP = new RestartPoint(210, 650, 6);
      walls[0] = new Wall(-11, 210, 640, 50, 10, 3);
      walls[1] = new Wall(-12, -210, 620, 50, 20, 3);
      
      walls[2] = new Wall(13, 260, 0, 10, 650, 0);
      walls[3] = new Wall(20, 215, 340, 20, 30, 0);
      walls[4] = new Wall(21, 230, 390, 30, 10, 0);
      walls[5] = new Wall(22, 215, 420, 20, 30, 0);
      walls[6] = new Wall(23, 230, 470, 30, 10, 0);
      walls[7] = new Wall(25, 230, 550, 30, 10, 0);
      walls[8] = new Wall(24, 215, 500, 20, 30, 200, 250, true, true, 1, 2);
      walls[9] = new Wall(26, 215, 580, 20, 30, 200, 250, true, true, 1, 2);
      walls[10] = new Wall(27, 230, 630, 30, 10, 200, 240, true, true, 1, 2);
      hasMovingWalls = true;
    }
    
    
    for(int i = 0; i < walls.length; i++){
    if(walls[i] == null){
      numWalls = i;
      break;
    }
  }
  }
  

  

  void moveWalls(Wall w){
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
  
}
