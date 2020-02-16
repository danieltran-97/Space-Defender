/********************
 Processing: [Insert Game Name]
 Team Members:
 About: Shoot on the enemy missles to protect your base for as long as you can.
 Use LeapMotion as a secondary ability/player to help heal the base when it was
 inflicted damage
 
 Setup Tab
 This section initalises all the different libraries and global variables to be used in
 this game. The different drawn objects (shooters, missles, health, base, cursor etc)
 has been configured on this page and used in the other tabs.
 
 The base design of the game is setup on this tab, including the background,health bar
 and points

 The key press functionality is also setup on this tab.
 - LEFT and RIGHT to read through tutorial
 - ENTER to reset game
 - 'S' to mute and unmute the sound
 
 STARTING GAME
 When game is run for the first time, the tutorial page will appear first. To begin,
 player will need to press the center base.
 
 *********************/

//import the minim sound library included with processing
import ddf.minim.*;
Minim minim;
AudioPlayer Chiptune;
AudioPlayer Explosion;
AudioPlayer Boom;


//import leapmotion library
import de.voidplus.leapmotion.*;
LeapMotion leap;

//BANG sound variable
PImage bang;
//background image variable
PImage galaxy;
//image for pause
PImage pause;

/*Declare Global Variables*/
/*Game Setup Variables*/
//Base
PImage planet;
PShape sphere;
//Enemy
PImage ship;
PShape spaceCraft;

float rotate;
int baseSizeX, baseSizeY; // Base size
int cursorX, cursorY; // Player Cursors (Used to eliminate enemy missles)
int level; //Game Level (Unlimited Levels)
boolean start, gameOver; // Game Status/Modes
boolean configLvl; //Used to configure the new level


/*Enemy Variables*/
Enemy[] shooter = new Enemy[100]; // Create 100 Enemies to be used in the levels
float speed,maxMissileSpeed; //Base speed of the enemy missles

/*Point Variables*/
int points, minus1; // Scoring Variables, minus1 used to fade text which shows -1 when base is attacked

/*Game Health Variables*/
int baseHealth; // The health of the base
boolean setHealthPos; //initial position of the health heart that is given to the player to collect
boolean sendHealth; //send a health to the player to collect using leapMotion
int healthItemX, healthItemY, healthMoveX, healthMoveY, healthSpeed; //health items variables to position and move

/*LeapMotion Variables*/
PVector pos; //leapMotion hand positions
float handPosX, handPosY, grab;

// explosion
ArrayList<Circle> circles;
//float Bx,By,Br;
float Cx,Cy,Cr;

/*Tutorial Variables*/
boolean tutorial;
int tutPage; //Page number of tutorial page
int introMissile, introMissile2, introHeart; // Introduction variables in Tutorial

//Fading Text
float timeInterval;
float timePast;

int textAlpha = 255; //text alpha value 255 the brightest
int fadeRate = 4; // decreases from 255 by 4 60 times in a second

    int enemyNum = 0;
    boolean playerPause = false;

void setup() {
  size(1200, 720, P3D);
  //fullScreen();
//image for background
  galaxy = loadImage("data/galaxy-2643089_960_720-610x366.jpg");
  planet = loadImage("planet.jpg");
  ship = loadImage("ship.jpg");
//image for pause  
  pause = loadImage("pause.png");
  
// Fade Text
  timePast = millis(); // Time past is given the value of millis
  timeInterval = 1000.0f; // the length of time chosen in between 
  
//explosion
  circles = new ArrayList<Circle>();  
  
//Animated gameover screen//
for (int i = 0; i < drops.length; i++) {
    drops[i] = new Drop();
  }

  /*Initial Game Setup*/
  speed = 3;
  maxMissileSpeed = 7;/*Missiles maximum speed (recommended)*/
  points = 0;
  minus1 = 0; //Variable is used for transparency, initally transparent so it is not displayed on screen
  baseSizeX = 50;
  baseSizeY = 50;
  level = 1;
  configLvl = true; //to setup game for each level
  start = false; //game does not begin initially
  gameOver = false;
  tutorial = true; //begin game with tutorial mode, page 1
  tutPage = 1;
  introMissile = 0;
  introMissile2 = width;
  introHeart = 0;

  /*Load Background Music and sound effects*/
  minim = new Minim(this);
  Chiptune = minim.loadFile("Chiptune.mp3");
  Explosion = minim.loadFile("Explosion.mp3");
  Boom = minim.loadFile("Boom.wav");

  /*Game Health Intialization*/
  baseHealth = 5; //Max baseHealth
  setHealthPos = false;
  sendHealth = false;
  healthItemX = 0;
  healthItemY = 0;
  healthMoveX = 0;
  healthMoveY = 0;
  healthSpeed = 4;

  /*Initalize Leapmotion*/
  leap = new LeapMotion(this);
  leap.allowGestures();
}

void draw() {
  image(galaxy, 0, 0, width, height);

  /*Display Points*/
  textAlign(CENTER);
  fill(color(255, 255, 255));
  textSize(50);
  text(points, width/2, 50);
  text("Level "+level, 200, 50);

  /*Display -1 when base is attacked*/
  fill(color(255, 0, 0, minus1)); //Transparency of '-1' is updated if base is hit.
  text("-1", width/2, 100);
  minus1--; //When base is hit, minus1 variable will be 255 and this variable with fade the -1 on screen

  /*Tutorial Mode: This is initially displayed when game begins/restarted*/
  if (!start && tutorial) {
    displayInstructions();
  /*Start Game*/
  } else if (start) {
    playGame();
    gameHealth();
  }
  
  if(playerPause){
   pause();
  }
  
  /*Position Player Base*/
  drawBase(rotate);
  rotate-=.01;

  /*Position Health*/
  for (int i = 0; i < baseHealth; i++) {
    healthHeart(width-width/3+40*(i+1), 20);
  }

  /*Player Cursor to protect base*/
  if(playerPause == false){               // When it is false which is what we want, it runs, when its true, it skips
  cursorX = mouseX;
  cursorY = mouseY;
  }
  drawPlayerShooter(cursorX, cursorY);
  
  //explosion
  for(int i=0; i<circles.size(); i++) {
    circles.get(i).drawCircle();
    circles.get(i).spread();
    //Br = circles.get(i).Cr();
    //Bx = circles.get(i).Cx();
    //By = circles.get(i).Cy();
    if (Cr >= 150)
    circles.remove(circles.get(i));
   }
   
  
  /*GAMEOVER*/
  /*when baseHealth reaches 0 or gameOver variable is initiated*/
  if (baseHealth <= 0 || gameOver) {
    
    gameOver = true;
    start = false;
    drawAB();

    /*Setup GameOver Screen*/
    textFade();
    fill(255, 0, 0, textAlpha);
    textSize(100);
    text("GAMEOVER!", width/2, height/5);
    fill(255);
    textSize(50);
    text("FINAL SCORE: "+points, width/2, height*0.88);
    textSize(30);
    text("Press ENTER to restart", width*0.75, height*0.95);
    textSize(30);
    text("Press ESC to end the game", width/4, height*0.95);
  }
}

void leapOnSwipeGesture(SwipeGesture g, int state){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector positionStart    = g.getStartPosition();
  PVector direction        = g.getDirection();
  float   speed            = g.getSpeed();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
      break;
    case 3: // Stop
      println("SwipeGesture: " + id);
      playerPause = !playerPause;
      if(level == 1){
        enemyNum = 4;
      }
      else if (level == 2){
        enemyNum = 6;
      }
      else{
        enemyNum = 8;
      }
    
      for(int i = 0; i<enemyNum;i++){
        shooter[i].toggleEnemyPause(playerPause);
      }
      break;
  }
}

void leapOnScreenTapGesture(ScreenTapGesture g){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector direction        = g.getDirection();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();

  println("ScreenTapGesture: " + id);
  if(start)
  circles.add(new Circle(handPosX,handPosY,100)); 
  
}

void leapOnCircleGesture(CircleGesture g, int state){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector positionCenter   = g.getCenter();
  float   radius           = g.getRadius();
  float   progress         = g.getProgress();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();
  int     direction        = g.getDirection();

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
      break;
    case 3: // Stop
      println("CircleGesture: " + id);
      if(start)
      circles.add(new Circle(handPosX, handPosY,100));
      break;
  }

  switch(direction){
    case 0: // Anticlockwise/Left gesture
      if(start)
      circles.add(new Circle(handPosX, handPosY,100));
      break;
    case 1: // Clockwise/Right gesture
      if(start)
      circles.add(new Circle(handPosX, handPosY,100));
      break;
  }
}

void leapOnKeyTapGesture(KeyTapGesture g){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector direction        = g.getDirection();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();

  println("KeyTapGesture: " + id);
  if(start)
  circles.add(new Circle(handPosX, handPosY,100));
}

void pause(){
 translate(width/2,height/2,100); 
 fill(0,0,0,100);
 rectMode(CENTER);
 rect(0,0,width,height);
 fill(255);
 image(pause,-100,-100);
 noFill();
}

// animated background//
void drawAB() {
  for (int i = 0; i < drops.length; i++) {
    drops[i].fall();
    drops[i].show();
  }
}

/*Function to draw player base by setting x and y position*/
void drawBase(float y) {
  /*Centre Base to Protect*/
  pushMatrix();
  noStroke();
  fill(255);
  sphere = createShape(SPHERE, baseSizeX);
  sphere.setTexture(planet);
  translate(width/2,height/2);
  lights();
  rotateY(y);
  shape(sphere);
  popMatrix();
}

/*Function to draw enemy shooter by setting x and y position*/
void drawEnemyShooter(float x, float y, float r) {
  pushMatrix();
  noStroke();
  spaceCraft = createShape(SPHERE, 50);
  spaceCraft.setTexture(ship);
  translate(x, y);
  lights();
  rotateY(r);
  shape(spaceCraft);
  popMatrix();
}

/*Function to draw player shoot (cross) by setting x and y position*/
void drawPlayerShooter (int x, int y) {
  noFill();
  stroke(0, 254, 0);
  strokeWeight(5);
  line(x, y-20, x, y+20);
  line(x-20, y, x+20, y);
  noStroke();
}

/*Function to draw enemy missile by setting x and y position*/
void drawMissile(float x, float y) {
  stroke(0);
  strokeWeight(1);
  fill(238, 133, 255);
  ellipse(x, y, 20, 20);
}



/*Function to hearts used for health bar and items by setting x and y position*/
/*Reference: https://www.processing.org/discourse/beta/num_1246205739.html*/
void healthHeart(int posX, int posY) {
  smooth();
  noStroke();
  fill(255, 0, 0);
  beginShape();
  vertex(posX, posY); 
  bezierVertex(posX, posY-20, posX+40, posY-10, posX, posY+25); 
  vertex(posX, posY); 
  bezierVertex(posX, posY-20, posX-40, posY-10, posX, posY+25); 
  endShape();
}

/*Function to draw LeapMotion Cursor player by setting the x and y position*/
void drawLeapMotionPlayer(float x, float y, float z) {
  stroke(0,0,255,200);
  strokeWeight(5);
  noFill();
  ellipse(x, y, 50+z, 50+z); //draw circle depending on x and y axis of the hand
  noStroke();
}

// Text Fade
void textFade() {
  if (millis() > timeInterval + timePast){               // if current timestamp > 1 sec + previous update timestamp then this update = current timestamp
  timePast = millis();
  fadeRate *= -1;           // multiples by -1 to change it from positive to negative to make it either go up or down 
  }
  textAlpha += fadeRate;       // add current fadeRate to current alpha value
}

/*MouseClick function used to begin the game by clicking the base*/
void mouseClicked() {
  if (!start && (mouseX >= (width/2 - baseSizeX) && mouseX <= width/2 + baseSizeX) 
    && (mouseY >= (height/2 - baseSizeY) && mouseY <= height/2 + baseSizeY)) {
    start = true;
    tutorial = false;
  }
  
  //if(start && mouseX <= (width/2 - baseSizeX) && mouseX >= (width/2 + baseSizeX) && mouseY <= (height/2 - baseSizeY) && mouseY >= (height/2 + baseSizeY))
  //circles.add(new Circle(mouseX, mouseY,100)); 
}

/*KeyPress functions for changing game modes such as tutorial, resets and sound control*/
void keyPressed() {
  /*Left and Right keys used to navigate through the tutorial mode*/
  if (key == CODED) {
    if (keyCode == RIGHT && tutPage != 5) {
      tutPage++;
    }
    if (keyCode == LEFT && tutPage != 1) {
      tutPage--;
    }
  }
  /*Press Enter to reset the game*/
  if (key == ENTER) {
    setup();
  }
  /*Press S to toggle between muting to unmuting the background and sound effects*/
  if (key == 'm') {
    if (!Chiptune.isMuted() && !Explosion.isMuted()) {
      Chiptune.mute();
      Explosion.mute();
    } else {
      Chiptune.unmute();
      Explosion.unmute();
    }
  }
  if (key == ' '){
    playerPause = !playerPause; // update the player pause state
    if(level == 1){            // tells enemy loop below exactly how many enemies there are
      enemyNum = 4;
    }
    else if (level == 2){
      enemyNum = 6;
    }
    else{
      enemyNum = 8;
    }
    
    // this loop pauses each enemey 
    for(int i = 0; i<enemyNum;i++){
      shooter[i].toggleEnemyPause(playerPause);
    }
  }
  if (key == 'b'){
    if(start)
    circles.add(new Circle(mouseX, mouseY,100)); 
  }
}

class Drop {
  float x;
  float y;
  float z;
  float length;
  float yspeed;
  
  Drop() {
    x = random(width);
    y = random(-1000, -50);
    z = random(0, 20);
    length = map(z, 0, 20, 10, 20);
    yspeed = map(z, 0, 20, 1, 20);
  }
  
  void fall() {
    y = y + yspeed;
    float grav = map(z, 0, 20, 0, 0.2);
    yspeed = yspeed + grav;
    
    if (y > height) {
      y = random(-200, -100);
      yspeed = map(z, 0, 20, 4, 10);
    }
  }
  
  void show() {
    float thick = map(z, 0, 20, 1, 3);
    strokeWeight(thick);
    stroke(88, 238, 42);
    line(x, y, x, y + length);
  }
}

Drop[] drops = new Drop[500];
