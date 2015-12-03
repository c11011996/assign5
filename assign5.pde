int fighterX, fighterY, fighterW, fighterH;
int bgX, hp1;
int treasureX, treasureY, treasureW, treasureH;
int enemyX, enemyY, enemyW, enemyH, bulletW, bulletH;
int currentFrame, timer, j, score;
float bulletX, bulletY;
PFont w; 
PImage bg1, bg2, enemy, fighter, hp, treasure, start1, start2, end1, end2, flame1, flame2, flame3, flame4, flame5;
PImage [] flames = new PImage [5];
PImage [] shoot = new PImage [5];
final int GAME_START = 0, GAME_RUN = 1, GAME_WIN = 2, GAME_OVER = 3;
final int STRAIGHT = 0, TILT = 1, DIAMOND = 2;
boolean [] hit = new boolean [12];
boolean [] isShooting = new boolean [12];
boolean [] boom = new boolean [12];
float [][] bullet = new float [5][2];
int gameState, enemyState;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

void setup () {
  size(640, 480) ;
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  enemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  flame1 = loadImage("img/flame1.png");
  flame2 = loadImage("img/flame2.png");
  flame3 = loadImage("img/flame3.png");
  flame4 = loadImage("img/flame4.png");
  flame5 = loadImage("img/flame5.png");

  gameState = GAME_START; 
  enemyState = STRAIGHT;
  fighterW = 50;
  fighterH = 50;
  fighterX = 590;
  fighterY = 240;
  bulletW = 31;
  bulletH = 27;
  bgX = 0;
  hp1 = 40;
  enemyW = 60;
  enemyH = 60;
  enemyX = 0;
  enemyY = floor(random(50, 240));
  treasureW = 40;
  treasureH = 40;
  treasureX = floor(random(10,600));
  treasureY = floor(random(30,440));
  timer = 0;
  currentFrame = 0;
  j = 0;
  score = 0;
  w = createFont("Arial",24);
  for(int i=0; i<5; i++){
    flames[i] = loadImage("img/flame"+(i+1)+".png");
    frameRate(60);
    shoot[i] = loadImage("img/shoot.png");
  }
    for(int i=0; i<12; i++){
    boom[i] = false;//explode detection
    hit[i] = true;//as a trigger of the enemy
    isShooting[i] = false;//bullet detection
    }
}

void draw() {
  switch(gameState) {
    //GAME START
  case GAME_START:
    if (mouseY > 365 && mouseY < 420 && mouseX > 200 && mouseX < 408) {
      image(start1, 0, 0);
      if (mousePressed) {
        gameState = GAME_RUN;
      }
    }else{
      image(start2, 0, 0);
    }
    break;

    //GAME RUN
  case GAME_RUN:
    //background
    image(bg1, bgX, 0);
    bgX++;
    image(bg2, bgX-640, 0);
    image(bg1, bgX-1280, 0);
    bgX%=1280;
    textFont(w,30);
    textAlign(LEFT);
    fill(255);
    text("Score: "+score,10,465);
    image(treasure, treasureX, treasureY);
    //hp
    fill(255, 0, 0, 240);
    rect(10, 3, hp1, 18); 
    image(hp, 5, 1);
    for(int j=0; j<5; j++){
      if (isShooting[j]){
        bullet[j][0]-=5;
        bulletX = bullet[j][0];
        bulletY = bullet[j][1];
        image(shoot[j],bulletX,bulletY);
     }
    }
    int f = floor((currentFrame++)/6%5);
    
    switch(enemyState) {
       case STRAIGHT:
           for(int i=0;i<5;i++){
             int [] enemyXY = new int [5];
             enemyXY[i] = i;
             if(hit[i]){
             //hit detection   
             if(fighterX+fighterH >= enemyX-enemyXY[i]*enemyW && fighterX <= enemyX-enemyXY[i]*enemyW+enemyW){
             if(fighterY+fighterH >= enemyY && fighterY <= enemyY+enemyH){
                 hit[i] = false;
                 boom[i] = true;
                 hp1 -= 40;
                 //println (hp1) ;
                 }
               }
               //bullet detection
                 if(isShooting[i]){
                   if(bulletX <= enemyX-enemyXY[i]*enemyW+enemyW && bulletX+bulletW>=enemyX-enemyXY[i]*enemyW){
                     if(bulletY+bulletH>=enemyY && bulletY<=enemyY+enemyH){
                       hit[i] = false;
                       boom[i] = true;
                       isShooting[i] = false;
                       scoreChange(20);
                     }                     
                   }
                 }               
             }
             if(hit[i]){
               image(enemy,enemyX-enemyXY[i]*enemyW,enemyY);
             }
             if(boom[i]){
               image(flames[f],enemyX-enemyXY[i]*enemyW,enemyY);
               if(frameCount%(60/10)==0){
               timer++;
               }
               if(timer==4){
               boom[i]=false;
               timer=0;
               }
             }
           }
           enemyX += 5;
           if(enemyX-enemyW*4 > width){
             enemyState = TILT;
             enemyX=0;
             enemyY = floor(random(50, 180));
             for(int i=0; i<5; i++){
               hit[i] = true;
             }
           }
       break;
       
    case TILT:
      for (int i=0; i<5; i++){
        int [] enemyXY = new int [5];
        enemyXY[i] = i;
        //hit detection         
        if(hit[i]){  
             if(fighterX+fighterH >= enemyX-enemyXY[i]*enemyW && fighterX <= enemyX+(1-enemyXY[i])*enemyW){
             if(fighterY+fighterH >= enemyY+enemyXY[i]*enemyH && fighterY <= enemyY+(1+enemyXY[i])*enemyH){
                 hit[i] = false;
                 hp1 -= 40;
                 boom[i] = true;
                 //println (hp1) ;
                 }
               }
               //bullet detection
                 if(isShooting[i]){
                   if(bulletX <= enemyX-enemyXY[i]*enemyW+enemyW && bulletX+bulletW>=enemyX-enemyXY[i]*enemyW){
                     if(bulletY+bulletH>=enemyY+enemyXY[i]*enemyH && bulletY<=enemyY+enemyXY[i]*enemyH+enemyH){
                       hit[i] = false;
                       boom[i] = true;
                       isShooting[i] = false;
                       scoreChange(20);
                     }                     
                   }
                 }
             }
             if(hit[i]){
               image(enemy, enemyX-enemyXY[i]*enemyW, enemyY+enemyXY[i]*enemyH);   
             }
             if(boom[i]){
               image(flames[f],enemyX-enemyXY[i]*enemyW,enemyY+enemyXY[i]*enemyH);
               if(frameCount%(60/10)==0){
               timer++;
               }
               if(timer==4){
               boom[i]=false;
               timer=0;
               }
             }
         }
         enemyX+=5;
          if (enemyX-4*enemyW > width){
          enemyState = DIAMOND;
          enemyX=0;
          enemyY = floor(random(150, 300));
          for(int i=0; i<12; i++){
            hit[i] = true;
           } 
          }   
      break; 
        
    case DIAMOND:
        for(int i=0; i<3; i++){
          int [] enemyXY = new int [12];
          enemyXY[i] = i;
          //hit detection         
          if(hit[i]){  
               if(fighterX+fighterH >= enemyX-enemyXY[i]*enemyW && fighterX <= enemyX-enemyXY[i]*enemyW+enemyW){
               if(fighterY+fighterH >= enemyY-enemyXY[i]*enemyH && fighterY <= enemyY-enemyXY[i]*enemyH+enemyH){
                   hit[i] = false;  
                   hp1 -= 40;
                   boom[i] = true;
                   //println (hp1) ;
                   }
                 }
                 //bullet detection
                 if(isShooting[i]){
                   if(bulletX <= enemyX-enemyXY[i]*enemyW+enemyW && bulletX+bulletW>=enemyX-enemyXY[i]*enemyW){
                     if(bulletY+bulletH>=enemyY-enemyXY[i]*enemyH && bulletY<=enemyY-enemyXY[i]*enemyH+enemyH){
                       hit[i] = false;
                       boom[i] = true;
                       isShooting[i] = false;
                       scoreChange(20);
                     }                     
                   }
                 }
               }
          if(hit[i]){
          image(enemy, enemyX-enemyXY[i]*enemyW, enemyY-enemyXY[i]*enemyH);
          }
          if(boom[i]){
               image(flames[f],enemyX-enemyXY[i]*enemyW, enemyY-enemyXY[i]*enemyH);
               if(frameCount%(60/10)==0){
               timer++;
               }
               if(timer==4){
               boom[i]=false;
               timer=0;
               }
             }
        }
        for(int i=3; i<6; i++){
          int [] enemyXY = new int [12];
          enemyXY[i] = i-3;
          //hit detection         
          if(hit[i]){  
               if(fighterX+fighterH >= enemyX-enemyXY[i]*enemyW && fighterX <= enemyX-enemyXY[i]*enemyW+enemyW){
               if(fighterY+fighterH >= enemyY+enemyXY[i]*enemyH && fighterY <= enemyY+enemyXY[i]*enemyH+enemyH){
                   hit[i] = false;  
                   hp1 -= 40;
                   boom[i] = true;
                   //println (hp1) ;
                   }
                 }
                 //bullet detection
                 if(isShooting[i]){
                   if(bulletX <= enemyX-enemyXY[i]*enemyW+enemyW && bulletX+bulletW>=enemyX-enemyXY[i]*enemyW){
                     if(bulletY+bulletH>=enemyY+enemyXY[i]*enemyH && bulletY<=enemyY+enemyXY[i]*enemyH+enemyH){
                       hit[i] = false;
                       boom[i] = true;
                       isShooting[i] = false;
                       scoreChange(20);
                     }                     
                   }
                 }
               }
          if(hit[i]){
          image(enemy, enemyX-enemyXY[i]*enemyW, enemyY+enemyXY[i]*enemyH);
          }
          if(boom[i]){
               image(flames[f],enemyX-enemyXY[i]*enemyW, enemyY+enemyXY[i]*enemyH);
               if(frameCount%(60/10)==0){
               timer++;
               }
               if(timer==4){
               boom[i]=false;
               timer=0;
               }
             }
        }
        for(int i=6; i<9; i++){
          int [] enemyXY = new int [12];
          enemyXY[i] = i-6;
          //hit detection         
          if(hit[i]){  
               if(fighterX+fighterH >= enemyX-(4-enemyXY[i])*enemyW && fighterX <= enemyX-(4-enemyXY[i])*enemyW+enemyW){
               if(fighterY+fighterH >= enemyY-enemyXY[i]*enemyH && fighterY <= enemyY-enemyXY[i]*enemyH+enemyH){
                   hit[i] = false;  
                   hp1 -= 40;
                   boom[i] = true;
                   //println (hp1) ;
                   }
                 }
                 //bullet detection
                 if(isShooting[i]){
                   if(bulletX <= enemyX-(4-enemyXY[i])*enemyW+enemyW && bulletX+bulletW>=enemyX-(4-enemyXY[i])*enemyW){
                     if(bulletY+bulletH>=enemyY-enemyXY[i]*enemyH && bulletY<=enemyY-enemyXY[i]*enemyH+enemyH){
                       hit[i] = false;
                       boom[i] = true;
                       isShooting[i] = false;
                       scoreChange(20);
                     }                     
                   }
                 }
               }
          if(hit[i]){
          image(enemy, enemyX-(4-enemyXY[i])*enemyW, enemyY-enemyXY[i]*enemyH);
          }
          if(boom[i]){
               image(flames[f],enemyX-(4-enemyXY[i])*enemyW, enemyY-enemyXY[i]*enemyH);
               if(frameCount%(60/10)==0){
               timer++;
               }
               if(timer==4){
               boom[i]=false;
               timer=0;
               }
             }
        }
        for(int i=9; i<12; i++){
          int [] enemyXY = new int [12];
          enemyXY[i] = i-9;
          //hit detection         
          if(hit[i]){  
               if(fighterX+fighterH >= enemyX-(4-enemyXY[i])*enemyW && fighterX <= enemyX-(4-enemyXY[i])*enemyW+enemyW){
               if(fighterY+fighterH >= enemyY+enemyXY[i]*enemyH && fighterY <= enemyY+enemyXY[i]*enemyH+enemyH){
                   hit[i] = false;  
                   hp1 -= 40;
                   boom[i] = true;
                   //println (hp1) ;
                   }
                 }
                 //bullet detection
                 if(isShooting[i]){
                   if(bulletX <= enemyX-(4-enemyXY[i])*enemyW+enemyW && bulletX+bulletW>=enemyX-(4-enemyXY[i])*enemyW){
                     if(bulletY+bulletH>=enemyY+enemyXY[i]*enemyH && bulletY<=enemyY+enemyXY[i]*enemyH+enemyH){
                       hit[i] = false;
                       boom[i] = true;
                       isShooting[i] = false;
                       scoreChange(20);
                     }                     
                   }
                 }
               }
          if(hit[i]){
          image(enemy, enemyX-(4-enemyXY[i])*enemyW, enemyY+enemyXY[i]*enemyH);
          }
          if(boom[i]){
               image(flames[f],enemyX-(4-enemyXY[i])*enemyW, enemyY+enemyXY[i]*enemyH);
               if(frameCount%(60/10)==0){
               timer++;
               }
               if(timer==4){
               boom[i]=false;
               timer=0;
               }
             }
        }
        enemyX+=5;
        if (enemyX-enemyW*3 > width) {
          enemyState = STRAIGHT;
          enemyX=0;
          enemyY = floor(random(50, 360));
          for(int i=0; i<5; i++){
               hit[i] = true;
             }
        }
      break;
    }
    //fighter
    image(fighter, fighterX, fighterY);
    if (upPressed) {
      fighterY -= 7;
      if (fighterY < 0) {
        fighterY = 0;
      }
    }
    if (downPressed) {
      fighterY += 7;
      if (fighterY > 430) {
        fighterY = 430;
      }
    }
    if (leftPressed) {
      fighterX -= 7;
      if (fighterX < 0) {
        fighterX = 0;
      }
    }
    if (rightPressed) {
      fighterX += 7;
      if (fighterX > 590) {
        fighterX = 590;
      }
    }
              
     if(fighterX+fighterW >= treasureX && fighterX <= treasureX+treasureW){
       if(fighterY+fighterH >= treasureY && fighterY <= treasureY+treasureH){
       hp1 += 20;
      // println(hp1);
       treasureX = floor(random(600));
       treasureY = floor(random(440));
       }
     }
      if (hp1 <= 0) {gameState=GAME_OVER;}
      if (hp1 >= 200) {hp1 = 200;}
    break;

    //GAME OVER
  case GAME_OVER:
    image(end2, 0, 0);
    if (mouseY > 305 && mouseY < 350 && mouseX > 200 && mouseX < 434) {
      image(end1, 0, 0);
      if (mousePressed) {
        hp1 = 40;
        fighterX = 590;
        fighterY = 240;
        gameState = GAME_RUN;
        enemyState = STRAIGHT;
        enemyX=0;
        enemyY = floor(random(50, 360));
        score=0;
        for(int i=0; i<12; i++){
         hit[i] = true;
         isShooting[i] = false;
         boom[i] = false;        
        }
      }
    }
    break;
  }
}
void keyPressed() {
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
    case UP:
      upPressed = true;
      break;
    case DOWN:
      downPressed = true;
      break;
    case LEFT:
      leftPressed = true;
      break;
    case RIGHT:
      rightPressed = true;
      break;
     }
  }
     if(key==' '){
      isShooting[j]=true;
      bullet[j][0]-=5;
 //     bullet[j][0]=bulletX;
 //     bullet[j][1]=bulletY;
        bullet[j][0]=fighterX;
        bullet[j][1]=fighterY+5;
        j++;
        j=j%5;
      }
 }

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      upPressed = false;
      break;
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    }
  }
}

void scoreChange(int value){
  score+=value;
}
