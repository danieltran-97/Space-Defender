/************  
Game Level Tab
Enemy objects have been initialised and positioned to start shooting at the case.
The different levels of the game adds a layer of complexity:
- Level 1: Enemies are drawn at each corner and starts shooting base
- Level 2: Two additional enemies are added and starts shooting at base
- Level 3: Two additional enemies are added and starts shooting at base
- Level 4: Two of the exisiting enemies start moving and shooting.
- Level 5: Another two of the exisiting enemies start moving and shooting.
- Level 6+ : Every 10 points obtained, enemies' missles will randomly increase in speed.

Background music is also played (Chiptune)
************/
void playGame() {
  /*play music at start of the game
   taken from: https://www.youtube.com/watch?v=OSJ0rW0d5AY*/
  Chiptune.play();

  /*Enabled LeapMotion to use secondary cursor controlled by LeapMotion*/
  moveLeapMotionPlayer();

  /*Level 1, Shooters are setup to appear on all 4 corners*/
  if (level >= 1) {
    if (configLvl && level == 1) { /*One time level configuration*/
      /*Create Shooters for Level 1*/
      shooter[0] = new Enemy(0, 0, speed);
      shooter[1] = new Enemy(0, height, speed);
      shooter[2] = new Enemy(width, 0, speed);
      shooter[3] = new Enemy(width, height, speed);
      configLvl = false;
    }

    /*Level 1 shooters start shooting!*/
    shooter[0].shoot();
    shooter[1].shoot();
    shooter[2].shoot();
    shooter[3].shoot();

    /*Level 1 Completed*/
    if (points ==  10 && level == 1) {
      level ++;
      configLvl = true;
    }
  }
  
  /*Level 2, Two more shooters are added to the left and right side and randomly positioned vertically*/
  if (level >= 2) {
    if (configLvl && level == 2) {
      /*Create Shooters for Level 2*/
      shooter[4] = new Enemy(0, random(100, height-100), speed);
      shooter[5] = new Enemy(width, random(100, height-100), speed);
      configLvl = false;
    }

    /*Level 2 shooters start shooting!*/
    shooter[4].shoot();
    shooter[5].shoot();

    /*Level 2 Completed*/
    if (points == 20 && level == 2) {
      level ++;
      configLvl = true;
    }
  }
  
  /*Level 3, Two more shooters are added to the top and bottom and positioned randomly horizontally*/
  if (level >= 3) {
    if (configLvl && level == 3) {
      /*Create Shooters for Level 3*/
      shooter[6] = new Enemy(random(100, width-100), 0, speed);
      shooter[7] = new Enemy(random(100, width-100), height, speed);
      configLvl = false;
    }

    /*Level 3 shooters start shooting!*/
    shooter[6].shoot();
    shooter[7].shoot();

    /*Level 3 Completed*/
    if (points == 30 && level == 3) {
      level ++;
      configLvl = true;
      speed++;
    }
  }
  /*Level 4, Two existing shooters are now moving left and right or up and down*/
  if (level >= 4) {
    
    //Moving shooters 4 and 6
    shooter[4].moveShooterHorizontal();
    shooter[6].moveShooterVertical();

    /*Level 4 Completed*/
    if (points == 40 && level == 4) {
      level ++;
      configLvl = true;
    }
  }

   /*Level 4, Two more existing shooters are now moving left and right or up and down*/
   /*Whenever points are divisible by 10, increase the speed of an existing shooter */
  if (level >= 5) {

    shooter[5].moveShooterHorizontal();
    shooter[7].moveShooterVertical();

    if (points%10 == 0) {
      int shooterNo = int(random(1, 8));
      shooter[shooterNo].increaseSpeed();
      
      /*Every 10 points obtained, level up*/
      if (points >= level*10) {
        level++;
      }
    }
  } 
}
