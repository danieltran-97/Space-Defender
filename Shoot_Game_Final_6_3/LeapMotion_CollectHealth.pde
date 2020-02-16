/************
Leap Motion Health Collector
Inspired my Mario Oddesey on Switch, Leap motion has been implemented as a secondary
ability that can be used by one player or controlled by a second player. The purpose
is to use the leapMotion to move upwards away from the leapMotion to go up on the
screen, down towards to leapMotion to go down on the screen and left and right.
This cursor can be used only to collect health to help heal the base when it has been
hit. The LeapMotion can only be used by the left hand, otherwise it may not work
properly.

Health items (Hearts) will only appear if the base is hit. Health items will only
appear when the score is divisble by 12. 
************/
//Display LeapMotion cursor using left hand
void moveLeapMotionPlayer() {
  //create ellipse with left hand
  for (Hand hand : leap.getHands() ) {
    if (hand.isLeft()) { //use left hand to control object
      pos = hand.getPosition(); //get hand position
      handPosX = pos.x*2;
      handPosY = pos.y*2-400;
      grab = hand.getGrabStrength() * 50;
      drawLeapMotionPlayer(handPosX, handPosY, grab);
    }
  }
}

//Randomly setup where health item will appear and move. Works one time, till another health item is called
void healthItem() {
  /*Where is health coming from 0:TOP 1:BOTTOM 2:LEFT 3:RIGHT*/
  if (setHealthPos  && !sendHealth) {
    int position = int(random(0, 4)); //randomly pick a number to position health item to appear from
    if (position == 0) {
      //Health item positioned at the Top, randomly position on X axis
      healthItemY = 0;
      healthItemX = int(random(50, width-50));
      healthMoveX = 0;
      healthMoveY = 1*healthSpeed;//health will move down
    } else if (position == 1) {
      //Health item positioned at the bottom, randomly position on the X axis
      healthItemY = height;
      healthItemX = int(random(50, width-50));
      healthMoveX = 0;
      healthMoveY = -1*healthSpeed; // health will move up
    } else if (position == 2) {
      //Health item position at on left side, randomly position on the Y axis
      healthItemX = 0;
      healthItemY = int(random(50, height-50));
      healthMoveX = 1*healthSpeed; //health will move right
      healthMoveY = 0;
    } else if (position == 3) {
      //Health item position at on right side, randomly position on the Y axis
      healthItemX = width;
      healthItemY = int(random(50, height-50));
      healthMoveX = -1*healthSpeed; //health will move left
      healthMoveY = 0;
    }
    setHealthPos = false; /*One time health position initialisation*/
    sendHealth = true; /*move health across screen*/
  }

  /*move health across screen, once inital position is set */
  if (sendHealth) {
    fill(0, 0, 255);
    healthItemX+=healthMoveX;
    healthItemY+=healthMoveY;    
    healthHeart(healthItemX, healthItemY);
    
    /*if moving health disappears from screen, remove health item*/
    if (healthItemX < 0 || healthItemX > width || healthItemY < 0 || healthItemY > height) {
      sendHealth = false;
      setHealthPos = false;
      healthItemX = 0;
      healthItemY = 0;
    }
    
    //If health item is within range of the leapMotion cursor, add extra health and decrease base size
    if ((handPosX >= healthItemX-30 && handPosX <= healthItemX+30)&&
      (handPosY >= healthItemY-10 && handPosY <= healthItemY+40)&& (healthItemX > 0 && healthItemX < width &&
      healthItemY > 0 && healthItemY < height)) {
      
      //Add health to health bar and decrease base size
      if (baseHealth < 5) {
        baseHealth++;
        if (baseSizeX > 50 && baseSizeY > 50) {
          baseSizeX-=30;
          baseSizeY-=30;
        }
      }
      /*Remove health item from screen*/
      sendHealth = false;
      setHealthPos = false;
      healthItemX = 0;
      healthItemY = 0;
    }
  }
}

/*Provide health if points are divisible by 12 and baseHealth is less than 5*/
void gameHealth() {
  if (points%12 == 0 && points > 0 && baseHealth < 5) {
    setHealthPos = true;
  }

  healthItem(); //health items display
}
