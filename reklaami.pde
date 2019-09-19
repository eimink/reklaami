import moonlander.library.*;
import ddf.minim.*;
final float FPS = 60;
final float SPEED = 120;

float now = 0.0;
float CANVAS_WIDTH = 1920;
float CANVAS_HEIGHT = 1080;

float pM, dD, dF;

int tsx = (int)CANVAS_WIDTH/2;
float pT = 0.0;

Moonlander moonlander;

PFont font;

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
  
  noCursor();

  int bpm = 120; // Tune's beats per minute
  int rowsPerBeat = 4; // How many rows one beat consists of in the sync editor (GNURocket or so)
  moonlander = new Moonlander(this, new TimeController(4));
  //moonlander = Moonlander.initWithSoundtrack(this, "20190608_graffathon_onescene.mp3", bpm, rowsPerBeat);
  moonlander.start();
  int fps = (int)FPS;
  frameRate(fps);
  pM = millis();
}
int x;
String msg = "-.- o_O O_O O_o -.- peoples' democratic republic of lamers -.- o_O O_O O_o -.-";
void drawText()
{
  pushMatrix();
  //scale(1.5+sin(now));
  //textAlign(LEFT,LEFT);
  textFont(font);
  x = tsx;
  for (int i = 0; i < msg.length(); i++) {
    text(msg.charAt(i),x,30*sin(x/(2*textWidth(msg.charAt(i)))));
    x += textWidth(msg.charAt(i));
  }
  popMatrix();
}

void draw() {
  // update Rocket sync data  
  moonlander.update();
  pT = now;
  dD = pM / millis();
  dF = (SPEED/FPS)*dD;
  pM = millis();
  /*float end = 60.0; //end production after 60 secs which is the maximum time allowed by the One Scene Compo
  if (now > end) {
    exit();
  }*/
  tsx -= 2*dF;
  // Set the background color
  background((int)(moonlander.getValue("bg:r") * 255),(int)(moonlander.getValue("bg:g") * 255),(int)(moonlander.getValue("bg:b") * 255),(int)(moonlander.getValue("bg:a") * 255));
  
  /*
   * Center coordinates to screen and make the window and canvas resolution independent
   * This is because actual window in full screen on a 4K monitor has more pixels than FullHD resolution
   * so scaling is needed to ensure that all objects (3D and 2D) are in correct places regardless of the desktop resolution
   */
  translate(width/2, height/2, 0);
  scale(width/CANVAS_WIDTH,height/CANVAS_HEIGHT,width/CANVAS_WIDTH);

  // Enable lights and depth testing to ensure that 3D meshes are drawn in correct order
  lights();
  hint(ENABLE_DEPTH_TEST);
/*
  drawGears();

  drawCube();
  
  drawAsmLogo();*/

  // disable lights and depth testing so that 2D overlays and text can be draw on top of 3D
  noLights();
  hint(DISABLE_DEPTH_TEST);

  drawText();

  //drawOverlays();
}
