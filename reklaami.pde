import moonlander.library.*;
import ddf.minim.*;
final float FPS = 60;
final float SPEED = 120;
final String[] prices = {"99mk","499mk","15mk","39mk","69mk"};
final String[] itemTexts = {"ANKKA - GLSL TUELLA","MÄTIPILLI DELUXE - MIKSI SÖISIT MÄTISI LUSIKALLA?","SIBS - SUOSIKIT: HERNEKEITTO, VIINA JA JOHANNES","KAMPAVIINA - SAMMUTTAA JANON PAREMMIN","PIKSELIVIILA - EI SOVELLU VEKTORIEN VANUTTAMISEEN"};
final String[] itemObjs = {"ducky.obj","matipilli.obj","10874_Chips_v1_L3.obj","14042_750_mL_Wine_Bottle_r_v1_L3.obj","viila.obj"};
final String[] greets = {"SKROLLI","TEKOTUOTANTO","WIDE LOAD","PARAGUAY","BYTERAPERS","ADAPT","CNCD","FAIRLIGHT","ASD","VANHA MEDIAKUNTA","QUADTRIP","DEKADENCE","DAMONES","JUMALAUTA","SCENESAT"};

float now = 0.0;
float CANVAS_WIDTH = 1920;
float CANVAS_HEIGHT = 1080;

float pM, dD, dF;

int tsx = (int)CANVAS_WIDTH/2;
float pT = 0.0;

Moonlander moonlander;

PFont font;
PImage bubble;
PImage overlay1;
PImage nekola;
PShape[] itemShapes = new PShape[itemObjs.length];
PGraphics bg;

PShader bgShader;

void settings() {
  boolean fullscreen = true;
  
  if (fullscreen) {
    fullScreen(P3D);
  } else {
    size((int)CANVAS_WIDTH,(int)CANVAS_HEIGHT, P3D);
  }
}

void setup() {
  font = createFont("VictorMono-Regular.ttf",100);
  bubble = loadImage("kupla.png");
  overlay1 = loadImage("overlay1.png");
  nekola = loadImage("warejako.png");
  for (int i = 0; i < itemShapes.length; i++)
  {
    itemShapes[i] = loadShape(itemObjs[i]);
  }
  bg = createGraphics((int)CANVAS_WIDTH,(int)CANVAS_HEIGHT);
  bgShader = loadShader("voro.glsl");
  bgShader.set("iResolution",(float)CANVAS_WIDTH, (float)CANVAS_HEIGHT);
  noCursor();
  
  int bpm = 120; // Tune's beats per minute
  int rowsPerBeat = 4; // How many rows one beat consists of in the sync editor (GNURocket or so)
  shader(bgShader);
  resetShader();
  moonlander = new Moonlander(this, new TimeController(8));
  //moonlander = Moonlander.initWithSoundtrack(this, "reklaami.mp3", bpm, rowsPerBeat);
  moonlander.start();
  int fps = (int)FPS;
  frameRate(fps);
  pM = millis();
}

int x;
String msg = "";
void drawText()
{
  pushMatrix();
  fill(255,255,255);
  textFont(font);
  msg = itemTexts[(int)moonlander.getValue("bubble:price")];
  x = (int)moonlander.getValue("scene:textx");
  for (int i = 0; i < msg.length(); i++) {
    text(msg.charAt(i),x,30*sin(x/(2*textWidth(msg.charAt(i)))));
    x += textWidth(msg.charAt(i));
  }
  popMatrix();
}

void drawSolidColorBGWithAlpha()
{
  bg.beginDraw();
  bg.background((float)moonlander.getValue("bg:r"),(float)moonlander.getValue("bg:g"),(float)moonlander.getValue("bg:b"),(float)moonlander.getValue("bg:a"));
  bg.endDraw();
  image(bg,-bg.width/2,-bg.height/2);
}

void drawBubble(String price, int x, int y, float zrot, float alpha) {
  pushMatrix();
  translate(x,y);
  rotateZ(radians(zrot));
  tint(255,alpha);
  image(bubble, -bubble.width/2, -bubble.height/2);
  scale(1.5);
  rotateZ(radians(-14));
  textFont(font);
  textAlign(CENTER,CENTER);
  fill(0,0,0,alpha);
  text(price,0,-30);
  popMatrix();
  
}

void draw3dProduct(int i) {
  if((float)moonlander.getValue("product:scale") <= 0.0) {
    return;
  }
  pushMatrix();
  translate((float)moonlander.getValue("product:x"),(float)moonlander.getValue("product:y"),(float)moonlander.getValue("product:z"));
  rotateX(PI*(float)moonlander.getValue("product:xrot")/180);
  rotateY(PI*(float)moonlander.getValue("product:yrot")/180);
  rotateZ(PI*(float)moonlander.getValue("product:zrot")/180);
  scale((float)moonlander.getValue("product:scale"));
  shape(itemShapes[i]);
  popMatrix();
}

void drawNekola() {
  image(nekola,-nekola.width/2, -nekola.height/2);
}

void drawOverlay() {
  image(overlay1,-CANVAS_WIDTH/2, -CANVAS_HEIGHT/2);
}

void draw() { 
  moonlander.update();
  switch((int)moonlander.getValue("scene:scene"))
  {
    case 0:
      hint(DISABLE_DEPTH_TEST);
      shader(bgShader);
      rect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
      resetShader();
      bgShader.set("iTime",(float)moonlander.getCurrentTime());
      translate(width/2, height/2, 0);
      scale(width/CANVAS_WIDTH,height/CANVAS_HEIGHT,width/CANVAS_WIDTH);
      drawSolidColorBGWithAlpha();
      drawNekola();
    break;
    case 1:
      lights();
      hint(DISABLE_DEPTH_TEST); 
      shader(bgShader);
      rect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
      resetShader();
      hint(ENABLE_DEPTH_TEST);
      bgShader.set("iTime",(float)moonlander.getCurrentTime());

      translate(width/2, height/2, 0);
      scale(width/CANVAS_WIDTH,height/CANVAS_HEIGHT,width/CANVAS_WIDTH);
      draw3dProduct((int)moonlander.getValue("bubble:price"));
      noLights();
       
      hint(DISABLE_DEPTH_TEST); 
      drawBubble(prices[(int)moonlander.getValue("bubble:price")],(int)moonlander.getValue("bubble:x"),(int)moonlander.getValue("bubble:y"),(float)moonlander.getValue("bubble:zrot"),(float)moonlander.getValue("bubble:alpha"));
      drawText();
    break;
    case 2:
      background(0,0,0);
      translate(width/2, height/2, 0);
      scale(width/CANVAS_WIDTH,height/CANVAS_HEIGHT,width/CANVAS_WIDTH);
      noLights();
      hint(DISABLE_DEPTH_TEST); 

      drawText();
    break;
  }

}
