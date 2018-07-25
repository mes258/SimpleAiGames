class Population {
  Dot[] dots;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;//the index of the best dot in the dots[]

  int minStep = 1000;

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot(0);
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------
  //show all dots
  void show() {
    for (int i = 1; i< dots.length; i++) {
      dots[i].show();
    }
    dots[0].show();
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  //update all dots 
  void update() {
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].brain.step > minStep) {//if the dot has already taken more steps than the best dot has taken to reach the goal
        dots[i].dead = true;//then it dead
      } else {
        dots[i].update();
      }
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------
  //calculate all the fitnesses
  void calculateFitness() {
    for (int i = 0; i< dots.length; i++) {
      dots[i].calculateFitness();
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------
  //returns whether all the dots are either dead or have reached the goal
  boolean allDotsDead() {
    for (int i = 0; i< dots.length; i++) {
      if (!dots[i].dead && !dots[i].reachedGoal) { 
        return false;
      }
    }

    return true;
  }



  //-------------------------------------------------------------------------------------------------------------------------------------

  //gets the next generation of dots
  void naturalSelection() {
    Dot[] newDots = new Dot[dots.length];//next gen
    setBestDot();
    calculateFitnessSum();

    //the champion lives on 
    newDots[0] = dots[bestDot].newBaby();
    newDots[0].isBest = true;
    for (int i = 1; i< newDots.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();

      //get baby from them
      newDots[i] = parent.newBaby();
    }

    dots = newDots.clone(); 
    gen++;
  }


  //---------------dots.-----------------------------------------------------------------------------------------------------------------------
  //you get it
  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dots.length; i++) {
      fitnessSum += dots[i].fitness;
    }
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  //chooses dot from the population to return randomly(considering fitness)

  //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
  //then go through all the dots and add their fitness to a running sum and if that sum is greater than the random value generated that dot is chosen
  //since dots with a higher fitness function add more to the running sum then they have a higher chance of being chosen
  Dot selectParent() {
    float rand = random(fitnessSum);


    float runningSum = 0;

    for (int i = 0; i< dots.length; i++) {
      runningSum+= dots[i].fitness;
      if (runningSum > rand) {
        return dots[i];
      }
    }

    //should never get to this point

    return null;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  //void mutateDemBabies(){s  //  for (int i = 1; i< dots.length; i++) {
  //    dots[i].brain.mutate();
  //  }
  //}
  
  void mutateDots(){
    for(int i = 1; i < dots.length; i++){
      dots[i].brain.mutate();
    }
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  //finds the dot with the highest fitness and sets it as the best dot
  void setBestDot() {
    float max = 0;
    int maxIndex = 0;
    boolean atEnd = false;;
    //int maxSteps = 0;
    float secondMax = 0;
    int secondMaxIndex = 0;
    for (int i = 0; i< dots.length; i++) {
      if (dots[i].fitness > max) {
        max = dots[i].fitness;
        maxIndex = i;
        if(max == 126*126){
          atEnd = true;
          println("YOU WIN!!");
        }
        //maxSteps = dots[i].steps;
      //}else if(dots[i].fitness == max && dots[i].steps < maxSteps){
      //  max = dots[i].fitness;
      //  maxIndex = i;
      //  maxSteps = dots[i].steps;
      }else if(dots[i].fitness > secondMax){
        secondMax = dots[i].fitness;
        secondMaxIndex = i;
      }
      dots[maxIndex].fitness = max*max;
      dots[secondMaxIndex].fitness = secondMax*secondMax;
    }

    bestDot = maxIndex;
    //println("Setting best dot");
    println("checkpoint: ", dots[bestDot].atCheckpoint);
    println("fitness: ", dots[bestDot].fitness);
    println("RP: ", dots[bestDot].atRP);
    println("finished? ", atEnd);
    //println("second checkpoint: ", dots[secondMaxIndex].atCheckpoint);
    //println("second fitness", dots[secondMaxIndex].fitness);
    println("");
    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      println("step:", minStep);
      
    }
  }
}
