class Stage {

  int stageNum = 0;

  Wall[] walls; //All walls
  int numWalls = 0; 

  RestartPoint RP; //Restart Point

  boolean dotsCompletedPrevious = false;
  boolean carCompletedPrevious = false;

  boolean hasMovingWalls = false;

  Critter[] bugs;
  boolean hasBugs = false;


  Stage(int stageNum) {
    this.stageNum = stageNum;
    walls = new Wall[30];
    bugs = new Critter[15];
    makeStage(stageNum);
  }

  void show() {

    if (hasBugs) {
      for (int i = 0; i < bugs.length; i++) {
        bugs[i].show();
      }
    }
    if (hasMovingWalls) {
      for (int i = 0; i < numWalls; i ++) {
        if (walls[i].type == 2) {
          moveWalls(walls[i]);
        }
      }
    }
    if (dotsCompletedPrevious && carCompletedPrevious) {
      walls[0].type = 0;
      walls[1].type = 0;
    }else{
      walls[0].type = 3;
      walls[1].type = 3;
    }
    for (int i = 0; i < numWalls; i++) {
      walls[i].show(walls[i].type);
    }
    RP.show();
  }

  void makeStage(int n) {
    //Wall types: 0 = normal wall, 1 = trigger wall, 2 = moving wall, 3 = hidden wall, 4 = teleporter, 5 = bug bounce wall
    if (n == 1) {               //STAGE 1
      RP  = new RestartPoint(75, 0, 1);
      walls[0] = new Wall(-1, -65, 50, 30, 10, 3);
      walls[1] = new Wall(-2, -65, 0, 10, 50, 3);

      walls[2] = new Wall(0, 50, 70, 10, 630, 0);
      walls[3] = new Wall(1, 0, 60, 30, 10, 0);
      walls[4] = new Wall(2, 95, 50, 10, 60, 0);
      walls[5] = new Wall(3, 60, 100, 80, 10, 0);
    } else if (n == 2) {         //STAGE 2
      RP = new RestartPoint(80, 650, 2);
      walls[0] = new Wall(-1, 65, 50, 30, 10, 3);
      walls[1] = new Wall(-2, 65, 0, 10, 50, 3);

      walls[2] = new Wall(0, 50, 100, 10, 630, 0);
      walls[3] = new Wall(2, 95, 50, 10, 60, 0);
      walls[4] = new Wall(3, 60, 100, 80, 10, 0);
      walls[5] = new Wall(4, 200, 0, 10, 150, 0);
      walls[6] = new Wall(5, 150, 140, 60, 10, 0);
      walls[7] = new Wall(6, 150, 140, 10, 35, 0);
      walls[8] = new Wall(7, 125, 165, 35, 10, 0);
      walls[9] = new Wall(8, 125, 165, 10, 35, 0);
      walls[10] = new Wall(9, 100, 190, 35, 10, 0);
      walls[11] = new Wall(10, 100, 190, 10, 460, 0);
      walls[12] = new Wall(10, 50, 400, 10, 60, 50, 100, true, true, 1, 2);
      hasMovingWalls = true;
    } else if (n == 3) {         //STAGE 3
      RP = new RestartPoint(160, 150, 3);

      walls[0] = new Wall(-3, 70, 640, 30, 10, 3);
      walls[1] = new Wall(-4, 70, 640, 10, 60, 3);

      walls[2] = new Wall(12, 200, 200, 10, 500, 0);
      walls[3] = new Wall(5, 150, 140, 60, 10, 0);
      walls[4] = new Wall(6, 150, 140, 10, 35, 0);
      walls[5] = new Wall(7, 125, 165, 35, 10, 0);
      walls[6] = new Wall(8, 125, 165, 10, 35, 0);
      walls[7] = new Wall(9, 100, 190, 35, 10, 0);
      walls[8] = new Wall(10, 100, 190, 10, 460, 0);

      walls[9] = new Wall(11, random(101, 175), 580, 10, 60, 101, 199, true, false, 1, 2);
      walls[10] = new Wall(12, random(101, 175), 550, 10, 60, 101, 199, true, true, 1, 2);
      walls[11] = new Wall(13, random(101, 175), 450, 10, 60, 101, 199, true, true, 1, 2);
      walls[12] = new Wall(14, random(101, 175), 400, 10, 60, 102, 198, true, true, 2, 2);
      walls[13] = new Wall(15, random(101, 175), 350, 10, 60, 101, 199, true, true, 1, 2);
      walls[14] = new Wall(16, random(101, 175), 250, 10, 60, 102, 198, true, true, 2, 2);
      walls[15] = new Wall(17, random(101, 175), 300, 10, 60, 103, 162, true, true, 3, 2);
      walls[16] = new Wall(18, random(101, 175), 200, 10, 60, 103, 197, true, true, 3, 2);
      hasMovingWalls = true;
    } else if (n == 4) {
      RP = new RestartPoint(210, 10, 4);
      walls[0] = new Wall(-5, 150, 170, 10, 30, 3);
      walls[1] = new Wall(-6, 150, 200, 60, 10, 3);

      walls[2] = new Wall(2, 200, 0, 10, 150, 0);
      walls[3] = new Wall(3, 150, 140, 60, 10, 0);
      walls[4] = new Wall(4, 150, 140, 10, 35, 0);
      walls[5] = new Wall(5, 260, 0, 10, 330, 0);
      walls[6] = new Wall(6, 200, 200, 10, 130, 0);
      //Triggers and trigger walls
      walls[7] = new Wall(15, 210, 100, 50, 10, 1);
      walls[8] = new Wall(16, 210, 220, 50, 10, 0);
      walls[9] = new Wall(17, 210, 240, 50, 10, 1);
      walls[10] = new Wall(18, 210, 75, 50, 10, 0);
      walls[11] = new Wall(14, 210, 0, 50, 10, 1);
      walls[12] = new Wall(19, 210, 260, 50, 10, 0);
    } else if (n == 5) {
      RP = new RestartPoint(210, 280, 5);
      walls[0] = new Wall(-7, 210, 0, 50, 10, 3);
      walls[1] = new Wall(-8, 200, 150, 10, 50, 3);

      walls[2] = new Wall(2, 200, 200, 10, 130, 0);
      walls[3] = new Wall(3, 260, 0, 10, 330, 0);
      walls[4] = new Wall(4, 200, 0, 10, 150, 0);
    } else if (n == 6) {
      RP = new RestartPoint(210, 650, 6);
      walls[0] = new Wall(-9, 210, 270, 50, 10, 3);
      walls[1] = new Wall(-10, -200, 270, 50, 10, 3);

      walls[2] = new Wall(13, 260, 270, 10, 380, 0);
      walls[3] = new Wall(20, 215, 340, 20, 30, 0);
      walls[4] = new Wall(21, 230, 390, 30, 10, 0);
      walls[5] = new Wall(22, 215, 420, 20, 30, 0);
      walls[6] = new Wall(23, 230, 470, 30, 10, 0);
      walls[7] = new Wall(25, 230, 550, 30, 10, 0);
      walls[8] = new Wall(24, 215, 500, 20, 30, 200, 250, true, true, 1, 2);
      walls[9] = new Wall(26, 215, 580, 20, 30, 200, 250, true, true, 1, 2);
      walls[10] = new Wall(27, 230, 630, 30, 10, 200, 240, true, true, 1, 2);
      hasMovingWalls = true;
      walls[11] = new Wall(2, 200, 270, 10, 430, 0);
    } else if (n == 7) {
      RP = new RestartPoint(630, 650, 7);
      walls[0] = new Wall(-11, 210, 640, 50, 10, 3);
      walls[1] = new Wall(-12, 200, 640, 10, 60, 3);
  
      
      walls[2] = new Wall(2, 260, 640, 440, 10, 0);
      walls[3] = new Wall(3, 270, 686, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      walls[4] = new Wall(4, 270, 674, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      walls[5] = new Wall(5, 270, 662, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      walls[6] = new Wall(6, 270, 650, 10, 10, 300, (int)random(400, 600), true, true, (int)random(1,4), 2);
      hasMovingWalls = true;
      
    } else if (n == 8) {
      RP = new RestartPoint(270, 200, 8);
      walls[0] = new Wall(13, 620, 640, 10, 60, 3);
      walls[1] = new Wall(-12, -210, 620, 50, 20, 3);

      walls[2] = new Wall(1, 270, 240, 100, 10, 5);
      walls[3] = new Wall(2, 370, 251, 10, 340, 5);
      walls[4] = new Wall(1, 270, 590, 100, 50, 5);
      walls[5] = new Wall(2, 260, 251, 10, 340, 5);
      
      walls[6] = new Wall(29, 370, 250, 10, 400, 0);
      walls[7] = new Wall(30, 320, 240, 60, 10, 0);
      walls[8] = new Wall(80, 680, 650, 20, 50, 4);
      walls[9] = new Wall(31, 260, 200, 10, 440, 0);
      walls[10] = new Wall(11, 270, 640, 100, 10, 0);
      walls[11] = new Wall(12, 630, 640, 120, 10, 0);
      

      hasBugs = true;

      for (int i = 0; i < bugs.length; i++) {
        bugs[i] = new Critter(275, 365, 255, 585);
      }
    
    } else if (n == 9) {
      RP = new RestartPoint(540, 0, 9);
      walls[0] = new Wall(-13, 260, 250, 70, 10, 3);
      walls[1] = new Wall(-14, -650, 55, 10, 10, 3);
      
      walls[2] = new Wall(1, 590, 0, 10, 60, 0);
      walls[3] = new Wall(3, 320, 50, 10, 200, 0);
      walls[4] = new Wall(4, 330, 50, 210, 10, 0);
      walls[5] = new Wall(5, 260, 0, 10, 250, 0);
      
      
    } else if (n == 10) {
      RP = new RestartPoint(650, 590, 10);
      walls[0] = new Wall(-13, 590, 60, 110, 10, 3);
      walls[1] = new Wall(-14, 530, 0, 10, 60, 3);
      
    //Border Walls
      //walls[10] = new Wall(1, 590, 0, 10, 60, 0);
      //walls[11] = new Wall(3, 320, 50, 10, 200, 0);
      //walls[12] = new Wall(4, 330, 50, 210, 10, 0);
      //walls[13] = new Wall(5, 330, 240, 50, 10, 0);
      //walls[14] = new Wall(6, 370, 250, 10, 400, 0);
      //walls[15] = new Wall(7, 370, 640, 330, 10, 0);
      //walls[16] = new Wall(8, 590, 60, 110, 10, 0);
      
    //Obstacles
      //Moving Walls
      walls[2] = new Wall(20, 330, 70, 10, 30, 330, 700, true, true, (int)random(1,4), 2);
    
      //Teleportation areas:
      //walls[2] = new Wall(81, 600, 100, 20, 50, 4);
      
      //Dot Zones [3 - 9]
      walls[3] = new Wall(2, 320, 50, 10, 200, 5);
      walls[4] = new Wall(1, 330, 50, 210, 10, 5);
      walls[5] = new Wall(1, 330, 240, 49, 10, 5);
      walls[6] = new Wall(2, 370, 251, 10, 400, 5);
      walls[7] = new Wall(1, 370, 640, 330, 10, 5);
      walls[8] = new Wall(1, 591, 60, 110, 10, 5);
      walls[9] = new Wall(2, 700, 60, 10, 590, 5);
      walls[10] = new Wall(1, 540, 40, 50, 10, 5);
      walls[11] = new Wall(2, 590, 50, 10, 19, 5);
      
      hasBugs = true;
      //Triggers and trigger walls
      hasMovingWalls = true;
      
      
      //Bugs: 
      for (int i = 0; i < bugs.length; i++) {
        bugs[i] = new Critter(385, 695, 70, 640);
      }
      
      
    } 
    //11 and 12 ARE BUFFERS FOR WINNING AFTER TEN LEVELS
    else if (n == 11) {
      RP = new RestartPoint(150, -590, 11);
      walls[0] = new Wall(-13, -550, 590, 10, 10, 3);
      walls[1] = new Wall(-14, -550, 590, 10, 10, 3);

      walls[2] = new Wall(50, -260, 0, 10, 700, 0);
      //walls[2] = new Wall(3, 370, 570, 250, 10, 0);
      //walls[3] = new Wall(4, 610, 580, 10, 60, 0);
    } else if (n == 12) {
      RP = new RestartPoint(50, -590, 12);
      walls[0] = new Wall(-13, -550, 590, 10, 10, 3);
      walls[1] = new Wall(-14, -550, 590, 10, 10, 3);

      walls[2] = new Wall(50, -260, 0, 10, 700, 0);
      //walls[2] = new Wall(3, 550, 590, 10, 90, 3);
      //walls[3] = new Wall(4, 550, 590, 80, 10, 3);
    } 


    for (int i = 0; i < walls.length; i++) {
      if (walls[i] == null) {
        numWalls = i;
        break;
      }
    }
  }

  void moveWalls(Wall w) {
    if (w.increase) {                //increase is true;
      if (w.moveX) {                    //moving x
        if (w.x < w.max) {                //x is less than max
          w.x += w.speed;
        } else {                          //x is more than max
          w.increase = false;
          w.x -= w.speed;
        }
      } else {                          // moving y
        if (w.y < w.max) {                //y is less than max
          w.y+= w.speed;
        } else {                          //y is more than max
          w.increase = false;
          w.y-= w.speed;
        }
      }
    } else {                      //increase is false
      if (w.moveX) {                    //moving x
        if (w.x >= w.min) {                //x is less than max
          w.x-= w.speed;
        } else {                          //x is more than max
          w.increase = true;
          w.x+= w.speed;
        }
      } else {                          // moving y
        if (w.y >= w.min) {                //y is less than max
          w.y-= w.speed;
        } else {                          //y is more than max
          w.increase = true;
          w.y+= w.speed;
        }
      }
    }
  }
}
