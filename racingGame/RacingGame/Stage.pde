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

      walls[2] = new Wall(28, 260, 640, 440, 10, 0);
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
        bugs[i] = new Critter();
      }
    } else if (n == 9) {
      RP = new RestartPoint(650, 0, 9);
      walls[0] = new Wall(-13, 635, 5, 10, 10, 3);
      walls[1] = new Wall(-14, 650, 55, 10, 10, 3);

      walls[2] = new Wall(1, 620, 0, 10, 70, 0);
      walls[3] = new Wall(2, 620, 70, 80, 10, 0);
    } else if (n == 10) {
      RP = new RestartPoint(650, 100, 10);
      walls[0] = new Wall(-13, 635, 105, 10, 10, 3);
      walls[1] = new Wall(-14, 650, 155, 10, 10, 3);

      walls[2] = new Wall(3, 620, 80, 10, 90, 0);
      walls[3] = new Wall(4, 620, 170, 80, 10, 0);
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
