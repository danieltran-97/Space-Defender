/************
Enemy Tab
An enemy class has been created to setup enemies shooters sending missiles
to the middle base. Enemy objects needs to be positioned (tempXpos,tempYpos) on the
screen and the speed (tempSpeed) of the missle is also initiated.
When the shooters (white large circle) are shooting the missiles (white small circles),
if the cursor collides with the missiles, it will disappear and points are added.
If the missiles hit the base, the base will grow in size and also points are deducted.
Enemies will shoot missiles one at a time till it its base or the player cursor.
************/

/*References*/
/**
 Code to have missile aimed at the centre of screen
 https://forum.processing.org/one/topic/how-can-i-make-a-ball-always-move-towards-the-player-character.html
 **/

/*Enemy Class to position enemy to shoot missles*/
class Enemy {
  PVector shooter, missile, base, target;
  int enemyDirectionX;
  int enemyDirectionY;
  float missileSpeed;
  boolean shoot;
  int delay;
  int delayMin;
  int delayMax;
  float rotation;
  boolean enemyPause; 
  PImage blast;

  Enemy(float tempXpos, float tempYpos, float tempSpeed) {
    shooter = new PVector(tempXpos, tempYpos); /*Position shooter on screen*/
    missile = new PVector(shooter.x, shooter.y); /*Initial position of missle, which is the same as the shooter position*/
    base = new PVector(width/2, height/2); /*Position of base*/
    target = new PVector(base.x, base.y); /*Position of base, this is used to re-target the missle to aim for the base when shooting*/
    enemyDirectionX = 1; /*Used to move the Enemy shooter left(-1) and right(1)*/
    enemyDirectionY = 1; /*Used to move the Enemy shooter Up (-1) and down(1)*/
    missileSpeed = tempSpeed; /*Initalise speed of missle*/
    shoot = false; /*control when missiles are triggered by shooter*/
    delayMin = 100; /*minimum milli second to delay missile*/
    delayMax = 300; /*maximum milli second to delay missile*/
    delay = int(random(delayMin, delayMax)); /*Randomise the miliseconds to use when sending a missile*/
    rotation = 0; // all enemies start rotation at 0
    enemyPause  = false;
  }

  /*Shooter Missle from Enemy Shooter position*/
  void shoot() {
    // blast image
    blast = loadImage("blast.png");

    /*Delay when the missile has hit base or eliminated*/
    if (!shoot) {
      delay--;
      resetShooter();
    }

    if (delay==0 && !shoot) {
      shoot = true;
      delay = int(random(delayMin, delayMax));
    }

    /*Shoot Target (Base)*/
    if ((missile.x>width || missile.y>height)&& shoot) {
      // Make the starting position of the missile where the enemy shooter is
      missile.x = shooter.x;
      missile.y = shooter.y;

      // Aim target to where the base is located from the shooter
      target.x = base.x-shooter.x;
      target.y = base.y-shooter.y;

      // Normalize the direction vector of the missile towards base
      target.normalize();

      // Speed used to move the missle towards base
      target.x *= missileSpeed;
      target.y *= missileSpeed;
    }

    // Update the missile to hit the base, if enemy is paused the missile position is not updated (not still moving)
    if(enemyPause == false){
    missile.x += target.x;
    missile.y += target.y;
    }
    /*Draw Missiles and Enemy Shooters*/
    drawMissile(missile.x, missile.y);
    rotation -= 0.1;
    drawEnemyShooter(shooter.x, shooter.y, rotation); // added the new input for rotate as we changed the enemy shooter to become a method with (float, float, float)
    
    /*Enemy hits base!*/
    /*If missles are within range of the base in the middle, decrease points and health*/
    /*Increase base size to make game harder*/
    if ((missile.x > base.x-baseSizeX && missile.x < base.x+baseSizeX &&
      missile.y > base.y-baseSizeY && missile.y < base.y+baseSizeY) &&
      (missile.x != base.x && missile.y != base.y)) {
      resetShooter();

      /*plays explosion sound when base is hit!
       taken from: https://www.youtube.com/watch?v=mJAX16YVQ3U*/
      Explosion.rewind();
      Explosion.play();

      /*Decrease Points*/
      if (!gameOver) {
        points--;
        baseHealth--;
        minus1 = 200;
        baseSizeX+=30;
        baseSizeY+=30;
      }
    }

    /*Enemy eliminated by player*/
    /*If missiles are within range of the mouse cursor, missle is removed and player gains points*/
    if(playerPause == false){                                                   //if enemey pause = true, then skip checking collision 
    
      if ((missile.x > mouseX-20 && missile.x < mouseX+20 &&
      missile.y > mouseY-20 && missile.y < mouseY+20)
      && (mouseX > shooter.x+30 || mouseX < shooter.x-30)) {
  
        //plays explosion when missile is destroyed
        Boom.rewind();
        Boom.play();
          
        resetShooter(); //Reset missile to shoot from enemy shooter
        
        image(blast, mouseX -100, mouseY -70);
  
        /*Increase Points*/
        if (!gameOver) {
          points++;
          shoot = false;
        }
      }
      
      if ((missile.x > Cx-Cr && missile.x < Cx+Cr &&
        missile.y > Cy-Cr && missile.y < Cy+Cr)
        && (Cx > shooter.x+Cr || Cx < shooter.x-Cr)) {
  
        Boom.rewind();
        Boom.play();
          
        resetShooter();
        
        image(blast, Cx -100, Cy -70);
  
        if (!gameOver) {
          points++;
          shoot = false;
        }
      }
      
      if ((missile.x > handPosX-grab && missile.x < handPosX+grab &&
        missile.y > handPosY-grab && missile.y < handPosY+grab)
        && (handPosX > shooter.x+grab || handPosX < shooter.x-grab)) {
  
        //plays explosion when missile is destroyed
        Boom.rewind();
        Boom.play();
          
        resetShooter(); //Reset missile to shoot from enemy shooter
        
        image(blast, handPosX -100, handPosY -70);
  
        /*Increase Points*/
        if (!gameOver) {
          points++;
          shoot = false;
        }
      }
    }
  }

  void resetShooter() {
    // Make the starting position of the missile where the enemy shooter is
    missile.x = shooter.x;
    missile.y = shooter.y;

    // Aim target to where the base is located from the shooter
    target.x = base.x-shooter.x;
    target.y = base.y-shooter.y;

    // Normalize the direction vector of the missile towards base
    target.normalize();

    // Speed used to move the missle towards base
    target.x *= missileSpeed;
    target.y *= missileSpeed;
  }

  /*Used to move a Enemy Shooter left and right*/
  void moveShooterVertical() {
    if (shooter.x > width) {
      enemyDirectionX = -1;
    } else if (shooter.x < 0) {
      enemyDirectionX = 1;
    }
    shooter.x = shooter.x + enemyDirectionX;
  }

  /*Used to move a Enemy Shooter up and down*/
  void moveShooterHorizontal() {
    if (shooter.y > height) {
      enemyDirectionY = -1;
    } else if (shooter.y < 0) {
      enemyDirectionY = 1;
    }
    shooter.y = shooter.y + enemyDirectionY;
  }

  /*Used to make missles move faster to make it harder*/
  void increaseSpeed() {
    if (missileSpeed <= maxMissileSpeed) { //Max speed has been setup to 5
      missileSpeed+=0.5;
      println(missileSpeed);
    }
  }
  
  // changing the pause state from false to true 
  void toggleEnemyPause(boolean state){
    enemyPause = state; // enemyPause is now changed to current state
  }
}
