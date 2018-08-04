class Population {
  Dot[] dots;

  float fitnessSum;
  int gen = 1;

  int bestDot = 0;//the index of the best dot in the dots[]

  int minStep = 1000;
  float bestFitness = 0;

  Dot topDot = new Dot(0);
  

  Population(int size) {
    dots = new Dot[size];
    for (int i = 0; i< size; i++) {
      dots[i] = new Dot(0);
    }
    topDot.fitness = 0;
  }

  //-------------------------------------------------------------------------------------------------------------------------------------

  //gets the next generation of dots
  void naturalSelection() {
    println("Natural selection");
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

    dots = newDots;
    //gen++;
    for(int i = 0; i < dots.length; i++){
      dots[i].show();
    }

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
    
    // for(int i = 0; i < dots.length * 0.75; i++){
    //   runningSum += dots[bestDot].fitness;
    // }
    
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
  void mutateDots(){
    for(int i = 1; i < dots.length; i++){
      dots[i].brain.mutate();
    }
  }

//getNewDot ______-----------------------------------------------
  void getNewDot(int i){
    dots[i].calculateFitness();
    // if(i == 5){
    //   println("Dot 5 RP: " + dots[5].atRP + "; Fitness: " + dots[5].fitness);
    // }
    if(dots[i].rpChanged){
      //println("RP changed");
      dots[i].fitness = 0;
    }
    if(dots[i].fitness >= dots[0].fitness){
      if(dots[i].atRP > dots[0].atRP){
        println("New Best: " + dots[i].atRP + "; topdot: " + dots[i].fitness);
      }
      dots[0] = dots[i];
   
    //new dot
      // dots[i] = dots[0].newBaby();
      dots[i].isBest = true;
    }else{
      Dot temp = dots[0].newBaby();
      dots[i] = null;
      temp.brain.mutate();
      dots[i] = temp;
    }
  
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------
  //finds the dot with the highest fitness and sets it as the best dot
  void setBestDot() {
    float max = 0;
    int maxIndex = 0;
    int maxSteps = 0;
    int maxRP = 0;
    for (int i = 0; i< dots.length; i++) {
      if(dots[i].atRP > maxRP || dots[i].atRP == maxRP){
        if (dots[i].fitness > max) {
          max = dots[i].fitness;
          maxIndex = i;
          maxSteps = dots[i].steps;
        }else if(dots[i].fitness == max && dots[i].steps < maxSteps){
          max = dots[i].fitness;
          maxIndex = i;
         maxSteps = dots[i].steps;
        }
      }
    }
    bestFitness = max;

    bestDot = maxIndex;
    
    //dots[bestDot].fitness += 10;
    println("fitness: ", dots[bestDot].fitness);
    println("RP: ", dots[bestDot].atRP);
    println("");
    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (dots[bestDot].reachedGoal) {
      minStep = dots[bestDot].brain.step;
      println("step:", minStep);
      
    }
  }
}
