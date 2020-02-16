/************
Tutorial Tab
This is setup to display the inital instructions of how the game works. Player can
read through the instructions by pressing LEFT and RIGHT. Below the screen shows the
page you are currently on. On each tutorial page, there is a small animation showing
the player how to play the game.
************/
void displayInstructions() {
  fill(color(255, 255, 255));
  textSize(30);

  /*Navigate through tutorial/instructions by key presses*/
  if (tutPage == 1) {
    /*Point out base in game*/
    text("Protect your center base!", width/2, height/4);
    textSize(20);
    text("<-- BASE", width/2+baseSizeX+50, height/2);
    textSize(30);
    text("'SPACE' or 'Swipe' for Pause", width/2, height/2 + 120);
    text("'M' for Mute", width/2, height/2 + 170);
    text("'B' 'circle' 'key tap' or 'screen tap' for Bomb", width/2, height/2 + 220);
  } 
  else if (tutPage == 2) {
    /*Point out how enemies are eliminated*/
    text("Use your mouse to eliminate the enemy's missiles", width/2, height/4);
    text("OR you can grab your hand to eliminate missiles", width/2, height/4+40);
    textSize(20);
    text("YOU", width/2 - 100, height/2-50);
    text("LEAPMOTION CURSOR", width/2 - 100, height/2+180);
    drawPlayerShooter(width/2 - 100, height/2);
    drawLeapMotionPlayer(width/2-100, height/2+100, 50);
    //move text and missle in tutorial
    if (introMissile != width/2 - 100) {
      introMissile+=2;
    } else {
      introMissile = 0;
    }

    textSize(20);
    text("MISSLE", introMissile, height/2+40);
    drawMissile(introMissile, height/2);
    textSize(20);
    text("<-- SHOOTER", 130, height/2-20);
    drawEnemyShooter(0, height/2, 0);         // added 3rd input here of 0 as the enemy method has been changed to (float, float, float), however we chose to not rotate for tutorial page
    fill(255);
    text("MISSLE", introMissile, height/2+140);
    drawMissile(introMissile, height/2+100);
    text("<-- SHOOTER", 130, height/2+80);
    drawEnemyShooter(0, height/2+100, 0);
    
  } 
  else if (tutPage == 3) {
    /*point out how leapMotion cursor is used to collect health items*/
    text("Use the leapMotion cursor to collect health and heal your base", width/2, height/4);
    //move heart and text in tutorial
    if (introHeart != width/2) {
      introHeart+=2;
    } else {
      introHeart = 0;
    }

    healthHeart(introHeart, height/2+100);
    fill(255);
    textSize(20);
    text("COLLECT ME!", introHeart, height/2+150);
    text("<-- LEAPMOTION CURSOR", width/2+ 175, height/2+100);

    drawLeapMotionPlayer(width/2, height/2+100, 0);
  } 
  else if (tutPage == 4){
    text("Generate a bomb can elimate enemies around it", width/2, height/4);
    float x = width/2;
    float y = height/2+100;
    float r = 100;
    noFill();
    stroke(255,255,255,50);
    strokeWeight(8);
    ellipse(x,y,r,r);
    noStroke();
    for(float i=r; i>=0; i--){
    fill(130,120,250,25);
    ellipse(x, y, 1.5*i, 1.5*i);
    fill(180,100,100,10);
    ellipse(x,y,r/1.75,r/1.75);
    }

    
    if (introMissile != width/2 - 50) {
      introMissile+=2;
    } else {
      introMissile = 0;
    }
    if (introMissile2 != width/2 + 50) {
      introMissile2-=2;
    } else {
      introMissile2 = width;
    }
    
    textSize(20);
    fill(255);
    text("MISSLE", introMissile, height/2+140);
    drawMissile(introMissile, height/2+100);
    text("<-- SHOOTER", 150, height/2+80);
    drawEnemyShooter(0, height/2+100, 0);
    fill(255);
    text("MISSLE", introMissile2, height/2+140);
    drawMissile(introMissile2, height/2+100);
    text("SHOOTER -->", width-150, height/2+80);
    drawEnemyShooter(width, height/2+100, 0);
    
  }
  else if (tutPage == 5) {
    /*Point out how to start game*/
    text("Click the base below to begin!", width/2, height/4);
  }
  
  textSize(20);
  fill(255);
  text(tutPage+"/5", width/2, height-60);
  text("Press LEFT and RIGHT key to read instructions", width/2, height-30);
}
