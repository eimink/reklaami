import moonlander.library.*;
import ddf.minim.*;
final float FPS = 60;
final float SPEED = 120;
final String[] prices = {"99mk","499mk","5,95mk","24,90mk"};
final String[] itemImages = {"ankka.png","pilli.png","sibs.png","kulmanavaaja.png"};

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
PImage[] items = new PImage[itemImages.length];

PShader tunnelShader;

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
  tunnelShader = loadShader("voro.glsl");
  tunnelShader.set("iResolution",(float)CANVAS_WIDTH, (float)CANVAS_HEIGHT);
  noCursor();
  
  for (int i = 0; i < items.length; i++)
  {
    items[i] = loadImage(itemImages[i]);
  }

  int bpm = 120; // Tune's beats per minute
  int rowsPerBeat = 4; // How many rows one beat consists of in the sync editor (GNURocket or so)
  shader(tunnelShader);
  resetShader();
  moonlander = new Moonlander(this, new TimeController(rowsPerBeat));
  //moonlander = Moonlander.initWithSoundtrack(this, "reklaami.mp3", bpm, rowsPerBeat);
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
  fill(255,255,255);
  textFont(font);
  x = tsx;
  for (int i = 0; i < msg.length(); i++) {
    text(msg.charAt(i),x,30*sin(x/(2*textWidth(msg.charAt(i)))));
    x += textWidth(msg.charAt(i));
  }
  popMatrix();
}

void drawPriceBubble(String price, int x, int y, float zrot, float alpha) {
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

void drawProduct(int i, int x, int y, float zrot, float alpha) {
  pushMatrix();
  translate(x,y);
  rotateZ(radians(zrot));
  tint(255, alpha);
  image(items[i], -items[i].width/2, -items[i].height/2);
  popMatrix();
}

void drawOverlay() {
  image(overlay1,-CANVAS_WIDTH/2, -CANVAS_HEIGHT/2);
}

void draw() { 
  moonlander.update();
  switch((int)moonlander.getValue("scene:scene"))
  {
    case 0:
      shader(tunnelShader);
      rect(-CANVAS_WIDTH, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
      resetShader();
      background((int)(moonlander.getValue("bg:r") * 255),(int)(moonlander.getValue("bg:g") * 255),(int)(moonlander.getValue("bg:b") * 255),(int)(moonlander.getValue("bg:a") * 255));
      drawProduct((int)moonlander.getValue("bubble:price"),(int)moonlander.getValue("product:x"),(int)moonlander.getValue("product:y"),(float)moonlander.getValue("product:zrot"),(float)moonlander.getValue("product:alpha"));
      drawPriceBubble(prices[(int)moonlander.getValue("bubble:price")],(int)moonlander.getValue("bubble:x"),(int)moonlander.getValue("bubble:y"),(float)moonlander.getValue("bubble:zrot"),(float)moonlander.getValue("bubble:alpha"));
    break;
    case 1:
      lights();
      hint(ENABLE_DEPTH_TEST);
      tunnelShader.set("iTime",(float)moonlander.getCurrentTime());
      shader(tunnelShader);
      rect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
      resetShader();
      noLights();
      hint(DISABLE_DEPTH_TEST);  
      translate(width/2, height/2, 0);
      scale(width/CANVAS_WIDTH,height/CANVAS_HEIGHT,width/CANVAS_WIDTH);
      drawProduct((int)moonlander.getValue("bubble:price"),(int)moonlander.getValue("product:x"),(int)moonlander.getValue("product:y"),(float)moonlander.getValue("product:zrot"),(float)moonlander.getValue("product:alpha"));
      drawPriceBubble(prices[(int)moonlander.getValue("bubble:price")],(int)moonlander.getValue("bubble:x"),(int)moonlander.getValue("bubble:y"),(float)moonlander.getValue("bubble:zrot"),(float)moonlander.getValue("bubble:alpha"));
    break;
    case 2:
      background((int)(moonlander.getValue("bg:r") * 255),(int)(moonlander.getValue("bg:g") * 255),(int)(moonlander.getValue("bg:b") * 255),(int)(moonlander.getValue("bg:a") * 255));
      noLights();
      hint(DISABLE_DEPTH_TEST); 
      dD = pM / millis();
      dF = (SPEED/FPS)*dD;
      pM = millis();
      pT = now;
      tsx -= 2*dF;
      drawText();
    break;
  }

}
