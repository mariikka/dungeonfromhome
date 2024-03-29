//Marika H

//setting variables
int SHOTGUN_THRESHOLD = 100;
int SHOTGUN_BULLETSPEED = 5;

//buttons
boolean mouseReleased;
boolean hadPressed;
Button introButton;
Button storyButton;
Button returnButton;
Button PressDAMAGE, PressSPEED, PressHP, PressEXIT;
Button Ygor, Mary, Karl, Vera;
Button BEGIN;

//character name 
int name;

//scoring etc
int money;


// ====================== colors 
color green     = #31710D;
color darkGreen = #15580C;
color red       = #BF1D1D;
color brightRed = #F70F0F;
color brown     =  #812828;
color darkBlue  = #1D0B67;
color black     = #000000;
color white     = #FFFFFF;
color grey      = #BFBBBB;
color northRoom, eastRoom, southRoom, westRoom;

//======================================= mode framework and controls

int mode;
final int INTRO = 0;
final int STORYINTRO = 1;
final int NAMESELECT = 2;
final int MOUSE = 3;
final int GAME = 4;
final int PAUSE = 5;
final int GAMEOVER = 6;
boolean wkey, skey, akey, dkey, spacekey, select, pause, mapkey;

// =============================== objects
ArrayList<GameObjects> myObjects;
Hero myHero;
ArrayList<Darkness> darkness;


//========================= gifs and images
AnimatedGif Giff;
AnimatedGif spriteUp;
AnimatedGif spriteDown;
AnimatedGif spriteLeft;
AnimatedGif spriteRight;
AnimatedGif grass;
PImage room;
PImage floor;
PImage card1;
PImage card2;
PImage card3;
PImage card4;
int cardTime = 0;
PImage map;
PImage doorN;
PImage doorE; 
PImage doorS;
PImage doorW;
PImage potion;
PImage shield, shieldcount, poison, coin, rock, stake;
PImage Pause, gameover, YGOR, VERA, KARL, MARY, graves;

//fonts ================
PFont iFont, yFont;


void setup() {
  mode = GAMEOVER;
  size(800, 600, FX2D);
  Giff = new AnimatedGif(247, 10,  "gif1/frame_", "_delay-0.04s.png" );
  spriteUp = new AnimatedGif (4, 10, "sprite/up/sprite_", ".png");
  spriteDown = new AnimatedGif (4,10, "sprite/down/sprite_", ".png");
  spriteLeft = new AnimatedGif (4,10, "sprite/left/sprite_", ".png");
  spriteRight = new AnimatedGif (4, 10,"sprite/right/sprite_", ".png");
  grass = new AnimatedGif (6, 7,"frame_", "_delay-0.13s.gif");

  //============================= buttons
  introButton   = new Button(iFont, "Begin", 400, 530, 300, 100, black, white);
  storyButton   = new Button(iFont, "Enter", 400, 530, 300, 100, black, white);
  returnButton  = new Button(iFont, "RETURN", 400, 530, 300, 100, black, white);
  PressDAMAGE   = new Button (iFont, "+", 90, 240, 30, 30, black, white);
  PressSPEED    = new Button (iFont, "+", 90, 340, 30, 30, black, white);
  PressHP       = new Button (iFont, "+", 90, 440, 30, 30, black, white);
  PressEXIT     = new Button (iFont, "x", 700, 220, 100, 100, black, white);
  Ygor          = new Button (yFont, "Ygor", 250, 200, 200, 70, black, white);
  Mary          = new Button (yFont, "Mary", 550, 200, 200, 70, black, white);
  Karl          = new Button (yFont, "Karl", 250, 300, 200, 70, black, white);
  Vera          = new Button (yFont, "Vera", 550, 300, 200, 70, black, white);
  BEGIN         = new Button(iFont, "BEGIN", 400, 530, 300, 100, black, white);

  //scoring etc
  money = 5;

  // ==================== fonts and images
  iFont = createFont("OldLondon.ttf", 50);
  yFont = createFont("yFont.otf", 50);
  room = loadImage("room.png");
  floor = loadImage("floor.png");
  card1 = loadImage("card1.png");
  card2 = loadImage("card2.png");
  card3 = loadImage("card3.png");
  card4 = loadImage("card4.png");
  map = loadImage("map.png");
  doorN = loadImage("doorN.png");
  doorE = loadImage("doorE.png");
  doorS = loadImage("doorS.png");
  doorW = loadImage("doorW.png");
  potion = loadImage("health4.png");
  shield = loadImage("shield.png");
  shieldcount = loadImage("shieldcount.png");
  poison = loadImage("poison.png");
  Pause = loadImage("pause.png");
  coin = loadImage("coin2.png");
  rock = loadImage("rock.png");
  stake = loadImage("stake.png");
  gameover = loadImage("gameover.png");
  VERA  = loadImage("VERA.png");
  YGOR = loadImage("YGOR.png");
  KARL = loadImage("KARL.png");
  MARY = loadImage("MARY.png");
  graves = loadImage("graves.png");
  //================= objects
  myHero = new Hero();
  myObjects = new ArrayList<GameObjects>();
  myObjects.add(myHero);
  myObjects.add(new Follower (150, 1, 2, width/2, height/2));


  //darkness


  darkness = new ArrayList<Darkness>();
  int s = 5;
  int x = 0, y = 0;
  while (y < height) {
    darkness.add(new Darkness(x, y, s));
    x = x + 5;
    if (x >= width) {
      x = 0;
      y = y + 5;
    }
  }

  //loading the enemies from map
  x = 0;
  y = 0;
  while (y < map.height) {
    color roomColor =  map.get(x, y);
    if (roomColor == brown) {
      myObjects.add(new Lurker(x, y, width/2, height/2));
    }
    if (roomColor == black) {
      myObjects.add(new Spawner(x, y));
    }

    if (roomColor == darkBlue) {
      myObjects.add(new Bat(100, x, y, width/2, height/2));
    }
    x++;
    if (x == map.width) {
      x = 0;
      y++;
    }
  }
}

void draw() {

  //button

  if (mousePressed) hadPressed = true;
  else if (hadPressed && !mousePressed) {
    mouseReleased = true;
    hadPressed = false;
  } else if (mouseReleased) mouseReleased = false;

  if (introButton.clicked) {
    mode = STORYINTRO;
  }
  if (storyButton.clicked) {
    mode = NAMESELECT;
  }




  //============================================= mode framework
  if (mode == INTRO) {
    intro();
  } else if (mode == MOUSE) {
    mousePressed();
  } else if (mode == GAME) {
    game();
  } else if (mode == PAUSE) {
    pause();
  } else if (mode == GAMEOVER) {
    gameover();
  } else if (mode == STORYINTRO) {
    storyIntro();
  } else if (mode == NAMESELECT) {
    name();
  } else {
    println("Error: Mode = " + mode);
  }
}
