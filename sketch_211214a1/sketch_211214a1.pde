PImage ManRun1;
PImage ManRun2;
PImage ManJump;
PImage ManDuck;
PImage ManDuck1;
PImage smallCactus;
PImage bigCactus;
PImage manySmallCactus;
PImage Aeroplane;
PImage background;
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Ground> grounds = new ArrayList<Ground>();

int obstacleTimer = 0;
int minTimeBetObs = 60;
int randomAddition = 0;
int groundCounter = 0;
float speed = 10;

int groundHeight = 60;
int playerXpos = 120;
int highScore = 0;
int alongx =0;

Player man;

void setup(){
  size(800, 400);
  frameRate(50);
  
  ManRun1 = loadImage("run1.png");
  ManRun2 = loadImage("run2.png");
  ManJump = loadImage("jump.png");
  ManDuck = loadImage("Duck.png");
  ManDuck1 = loadImage("Duck.png");
  smallCactus = loadImage("Treewithtrunk.png");
  bigCactus = loadImage("woodenLogg.png");
  manySmallCactus = loadImage("GrassWithStone.png");
  Aeroplane = loadImage("AeroplaneRed.png");
  background = loadImage("back.png");
  man = new Player();
  
}

void draw(){
  background(background);
  noStroke();
  fill(255,165,0);
  circle(760,60,60);
  fill(135,206,250);
  ellipse(820,90,50,40);
  ellipse(780,90,70,40);
  ellipse(810,30,60,40);
  ellipse(805,60,100,50);

  fill(135,206,235);
  ellipse(940-alongx,120,80,80);
  ellipse(900-alongx,120,80,80);
  ellipse(920-alongx,90,80,80);
  fill(135,206,235);
  ellipse(380-alongx,120,80,80);
  ellipse(340-alongx,120,80,80);
  ellipse(360-alongx,90,80,80);
  alongx++;
  if(alongx==width){
    alongx=-500;
    
  }
  strokeWeight(2);

  
  updateObstacles();
  
  if(man.score > highScore){
    highScore = man.score;
  }
  
  textSize(20);
  fill(0);
  text("Score: " + man.score, 5, 20);
  text("Space for jump and 's' for Duck",120,20);
  text("High Score: " + highScore, width - (140 + (str(highScore).length() * 10)), 20);
}

void keyPressed(){
  switch(key){
    case ' ': man.jump();
              break;
    case 's': if(!man.dead){
                man.ducking(true);
              }
              break;
  }
}

void keyReleased(){
  switch(key){
    case 's': if(!man.dead){
                man.ducking(false);
              }
              break;
    case 'r': if(man.dead){
                reset();
              }
              break;
  }
}

void updateObstacles(){
  showObstacles();
  man.show();
  if(!man.dead){
    obstacleTimer++;
    speed += 0.002;
    if(obstacleTimer > minTimeBetObs + randomAddition){
      addObstacle();
    }
    groundCounter++;
    if(groundCounter > 10){
      groundCounter = 0;
      grounds.add(new Ground());
    }
    moveObstacles();
    man.update();
  }
  else{
    textSize(32);
    fill(0);
    text("YOU DEAD!", 180, 200);
    textSize(16);
    text("(Press 'r' to restart!)", 330, 230);
  }
}

void showObstacles(){
  for(int i = 0; i < grounds.size(); i++){
    grounds.get(i).show();
  }
  for(int i = 0; i < obstacles.size(); i++){
    obstacles.get(i).show();
  }
  for(int i = 0; i < birds.size(); i++){
    birds.get(i).show();
  }
}

void addObstacle(){
  if(random(1) < 0.15){
    birds.add(new Bird(floor(random(3))));
  }
  else{
    obstacles.add(new Obstacle(floor(random(3))));
  }
  randomAddition = floor(random(50));
  obstacleTimer = 0;
}

void moveObstacles(){
  for(int i = 0; i < grounds.size(); i++){
    grounds.get(i).move(speed);
    if(grounds.get(i).posX < -playerXpos){
      grounds.remove(i);
      i--;
    }
  }
  for(int i = 0; i < obstacles.size(); i++){
    obstacles.get(i).move(speed);
    if(obstacles.get(i).posX < -playerXpos){
      obstacles.remove(i);
      i--;
    }
  }
  for(int i = 0; i < birds.size(); i++){
    birds.get(i).move(speed);
    if(birds.get(i).posX < -playerXpos){
      birds.remove(i);
      i--;
    }
  }
}

void reset(){
  man = new Player();
  obstacles = new ArrayList<Obstacle>();
  birds = new ArrayList<Bird>();
  grounds = new ArrayList<Ground>();
  
  obstacleTimer = 0;
  randomAddition = floor(random(50));
  groundCounter = 0;
  speed = 10;
}
class Bird{
  float w = 60;
  float h = 50;
  float posX, posY;
  int flapCount = 0;
  
  Bird(int t){
    posX = width;
    switch(t){
      case 0: posY = 10 + h / 4;
              break;
      case 1: posY = 60;
              break;
      case 2: posY = 130;
              break;
    }
  }
  
  void show(){
    flapCount++;
    if(flapCount < 0){
      image(Aeroplane, posX - Aeroplane.width / 2, height - groundHeight - (posY + Aeroplane.height - 20));
    }
    else{
      image(Aeroplane, posX - Aeroplane.width / 2, height - groundHeight - (posY + Aeroplane.height - 20));
    }
    if(flapCount > 15){
      flapCount = -15;
    }
  }
  
  void move(float speed){
    posX -= speed;
  }
  
  boolean collided(float playerX, float playerY, float playerWidth, float playerHeight){
    float playerLeft = playerX - playerWidth / 2;
    float playerRight = playerX + playerWidth / 2;
    float thisLeft = posX - w / 2;
    float thisRight = posX + w / 2;
    
    if(playerLeft < thisRight && playerRight > thisLeft){
      float playerDown = playerY - playerHeight / 2;
      float playerUp = playerY + playerHeight / 2;
      float thisUp = posY + h / 2;
      float thisDown = posY - h / 2;
      if(playerDown <= thisUp && playerUp >= thisDown){
        return true;
      }
    }
    return false;
  }
}
class Ground{
  float posX = width;
  float posY = height - floor(random(groundHeight -70, groundHeight + 70));
  int w = floor(random(1, 10));
  
  Ground(){
  }
  
  void show(){
    stroke(0);
    strokeWeight(3);
    line(posX, posY, posX + w, posY);
  }
  
  void move(float speed){
    posX -= speed;
  }
}
class Obstacle{
  float posX;
  int w, h;
  int type;
  
  Obstacle(int t){
    posX = width;
    type = t;
    switch(type){
      case 0: w = 20;
              h = 40;
              break;
      case 1: w = 30;
              h = 60;
              break;
      case 2: w = 60;
              h = 40;
              break;
    }
  }
  
  void show(){
    switch(type){
      case 0: image(smallCactus, posX - smallCactus.width / 2, height - groundHeight - smallCactus.height);
              break;
      case 1: image(bigCactus, posX - bigCactus.width / 2, height - groundHeight - bigCactus.height);
              break;
      case 2: image(manySmallCactus, posX - manySmallCactus.width / 2, height - groundHeight - manySmallCactus.height);
              break;
    }
  }
  
  void move(float speed){
    posX -= speed;
  }
  
  boolean collided(float playerX, float playerY, float playerWidth, float playerHeight){
    float playerLeft = playerX - playerWidth / 2;
    float playerRight = playerX + playerWidth / 2;
    float thisLeft = posX - w / 2;
    float thisRight = posX + w / 2;
    
    if(playerLeft < thisRight && playerRight > thisLeft){
      float playerDown = playerY - playerHeight / 2;
      float thisUp = h;
      if(playerDown < thisUp){
        return true;
      }
    }
    return false;
  }
}
class Player{
  float posY = 0;
  float velY = 0;
  float gravity = 1.2;
  int size = 20;
  boolean duck = false;
  boolean dead = false;
  
  int runCount = -5;
  int lifespan;
  int score;
  
  Player(){
  }
  
  void jump(){
    if(posY == 0){
      gravity = 1.2;
      velY = 16;
    }
  }
  
  void show(){
    if(duck && posY == 0){
      if(runCount < 0){
        image(ManDuck, playerXpos -ManDuck.width / 2, height - groundHeight - (posY +  -ManDuck.height));
      }
      else{
        image(ManDuck1, playerXpos - ManDuck1.width / 2, height - groundHeight - (posY + ManDuck1.height));
      }
    }
    else{
      if(posY == 0){
        if(runCount < 0){
          image(ManRun1, playerXpos - ManRun1.width / 2, height - groundHeight - (posY +ManRun1.height));
        }
        else{
          image(ManRun2, playerXpos -ManRun2.width / 2, height - groundHeight - (posY + ManRun2.height));
        }
      }
      else{
        image(ManJump, playerXpos -ManJump.width / 2, height - groundHeight - (posY + ManJump.height));
      }
    }
    
    if(!dead){
      runCount++;
    }
    if(runCount > 5){
      runCount = -5;
    }
  }
  
  void move(){
    posY += velY;
    if(posY > 0){
      velY -= gravity;
    }
    else{
      velY = 0;
      posY = 0;
    }
    
    for(int i = 0; i < obstacles.size(); i++){
      if(dead){
        if(obstacles.get(i).collided(playerXpos, posY + ManDuck.height / 2, ManDuck.width * 0.5, ManDuck.height)){
          dead = true;
        }
      }
      else{
        if(obstacles.get(i).collided(playerXpos, posY + ManRun1.height / 2,  ManRun1.width * 0.5,  ManRun1.height)){
          dead = true;
        }
      }
    }
    
    for(int i = 0; i < birds.size(); i++){
      if(duck && posY == 0){
        if(birds.get(i).collided(playerXpos, posY +ManDuck.height / 2, ManDuck.width * 0.5, ManDuck.height)){
          dead = true;
        }
      }
      else{
        if(birds.get(i).collided(playerXpos, posY + ManRun1.height / 2, ManRun1.width * 0.5, ManRun1.height)){
          dead = true;
        }
      }
    }
  }
  
  void ducking(boolean isDucking){
    if(posY != 0 && isDucking){
      gravity = 3;
    }
    duck = isDucking;
  }
  
  void update(){
    incrementCounter();
    move();
  }
  
  void incrementCounter(){
    lifespan++;
    if(lifespan % 3 == 0){
      score += 1;
    }
  }
}
