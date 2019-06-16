import processing.serial.*;

Serial fd;

int roll = 0;
int pitch = 0;
int yaw = 0;

void setup () 
{
  size(640, 480, OPENGL);
  smooth();
  noStroke();
  frameRate(50);
  
  //Connect to the corresponding serial port
  fd = new Serial(this, "/dev/tty.usbmodem1411", 115200);
  // Defer callback until new line
  fd.bufferUntil('\n');
  
  delay(1000);
  fd.clear();
}

void draw () 
{
  //Set background
  background(0);
  lights();


  pushMatrix();
  translate(width/2, height/2, -350);
  drawBoard();
  popMatrix();
  
  
  // Output angles
  pushMatrix();
  translate(10, height - 10);
  textAlign(LEFT);
  text("Roll: " + ((int) roll), 0, 0);
  text("Pitch: " + ((int) pitch), 150, 0);
  text("Yaw: " + ((int) yaw), 300, 0);
  popMatrix();
}

void drawBoard() {
  pushMatrix();

//  rotateZ(roll);
//  rotateX(pitch);
//  rotateY(yaw);

  rotateY(radians(yaw));
  rotateX(radians(roll)); 
  rotateZ(-radians(pitch));

  // Board body
  fill(255, 0, 0);
  box(250, 20, 400);
  
  // Forward-arrow
  pushMatrix();
  translate(0, 0, -200);
  scale(0.5f, 0.2f, 0.25f);
  fill(0, 255, 0);
  drawArrow(1.0f, 2.0f);
  popMatrix();
    
  popMatrix();
}

void drawArrow(float headWidthFactor, float headLengthFactor) {
  float headWidth = headWidthFactor * 200.0f;
  float headLength = headLengthFactor * 200.0f;
  
  pushMatrix();
  
  // Draw base
  translate(0, 0, -100);
  box(100, 100, 200);
  
  // Draw pointer
  translate(-headWidth/2, -50, -100);
  beginShape(QUAD_STRIP);
    vertex(0, 0 ,0);
    vertex(0, 100, 0);
    vertex(headWidth, 0 ,0);
    vertex(headWidth, 100, 0);
    vertex(headWidth/2, 0, -headLength);
    vertex(headWidth/2, 100, -headLength);
    vertex(0, 0 ,0);
    vertex(0, 100, 0);
  endShape();
  beginShape(TRIANGLES);
    vertex(0, 0, 0);
    vertex(headWidth, 0, 0);
    vertex(headWidth/2, 0, -headLength);
    vertex(0, 100, 0);
    vertex(headWidth, 100, 0);
    vertex(headWidth/2, 100, -headLength);
  endShape();
  
  popMatrix();
}

void serialEvent (Serial fd) 
{
  // get the ASCII string:
  String rpstr = fd.readStringUntil('\n');
  if (rpstr != null) {
    String[] list = split(rpstr, ',');
    if(list.length == 3) {
      roll = ((int)float(list[0]));
      pitch = ((int)float(list[1]));
      yaw = ((int)float(list[2]));
    }
  }
}
