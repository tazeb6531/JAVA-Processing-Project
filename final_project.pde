/*

Tazeb Abera
Final Project

Controls:
RIGHT, LEFT arrow keys  =  Rotate along X-axis
   UP, DOWN arrow keys  =  Rotate along Y-axis
                     +  =  Zoom In
                     -  =  Zoom Out
                     f  =  Move away from the sceen towards the user
                     b  =  Move into the screen away from the user
                     g  =  Toggle Grid
             SPACE BAR  =  Reset Plot
*/

Table table;
Grid grid;
Axes axes;

float rotateX;
float rotateY;
float rotateZ;
float rotationStep;
float scaleFactor;
float scaleStep;
int zDepth;

// Color Scheme
static final int RED    = #FF0000;
static final int ORANGE = #FF7F00;
static final int YELLOW = #FFFF00;
static final int GREEN  = #00FF00; 
static final int BLUE   = #0000FF; 
static final int INDIGO_SUB = #FF00B2;  //#4B0082;
static final int VIOLET = #9400D3;

color[] colors = {BLUE,VIOLET,INDIGO_SUB,RED,ORANGE,YELLOW,GREEN};


float maxZ = -10000000; // low value
float maxXYMag = -10000000; // low value
float minZ = 10000000; // high value
float minZX;
float minZY;
float colorSpacing;
int gridOn;
int gridSize = 20;

void settings(){
  size(800,800,P3D); 
}

void setup(){
  noStroke(); 
  table = loadTable("data.csv", "header");
  //println(table.getRowCount() + " total rows in table");

  for (TableRow row : table.rows()) {
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");
    
    // Max Z needed for Colorbar
    if (z > maxZ){ maxZ = z; }
    
    // Min Z is what user is interested in
    if (z < minZ){ minZX = x; minZY = y; minZ = z; }
    
    // Required for sizing the Axes
    if (abs(x) > maxXYMag){ maxXYMag = abs(x); }
    if (abs(y) > maxXYMag){ maxXYMag = abs(y); }
  }
  
  grid = new Grid(this, 2*(ceil(maxXYMag)+1), gridSize);
  axes = new Axes(this);
  
  colorSpacing = maxZ/(colors.length); 
  resetRotationAndZoom();
}

void draw(){
  background(0);
  lights();
  
  // Static hence placed before translation
  writeTitleAndInfo();
  plotColorBarWithLabels();
  
  translate(width*0.25, height*.97, zDepth);
  plotGridAndAxis();
  plotDataPoints(); 
}

void keyPressed()
{
  if (key == CODED) {
    if(keyCode == LEFT)  { rotateX = rotateX - rotationStep; }
    else if(keyCode == RIGHT) { rotateX = rotateX + rotationStep; }
    else if(keyCode == UP) { rotateY = rotateY - rotationStep; }
    else if(keyCode == DOWN) { rotateY = rotateY + rotationStep; }
  }

  if(key == '+') { scaleFactor = scaleFactor + scaleStep; } // zoom in 
  else if(key == '-') { scaleFactor = scaleFactor - scaleStep; } // zoom out
  else if(key == ' ') { resetRotationAndZoom(); }
  else if(key == 'g') {gridOn = (gridOn + 1)%2; }
  else if(key == 'b') {zDepth = zDepth - 50; }
  else if(key == 'f') {zDepth = zDepth + 50; }
}

void plotColorBarWithLabels(){
  int boxWidth = 26;
  plotColorBar(boxWidth);
  plotColorBarLabels(boxWidth);
}


void plotDataPoints(){
  // Plot Data Points 
  for (TableRow row : table.rows()) {
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float z = row.getFloat("Z");

    int colorOption = int(z/colorSpacing) - 1 ;
    noStroke();
    
    // Decide Color
    if (z == minZ){ 
      fill(255);
    } else { 
      fill(colors[colorOption]);
    }
    
    plot3DScatterPlot(x,y,z);
    plotXYContour(x,y,z); //z is still needed to check against MinZ
  }  
}

void plot3DScatterPlot(float x, float y, float z){
  pushMatrix();
    rotateVariable();
    scale(scaleFactor,scaleFactor,scaleFactor);
    translate(x*gridSize,y*gridSize,z*gridSize); // set default zoom levels (may not be same for all axes)
    if (z == minZ){ 
      sphere(7);
    } else { 
      sphere(3);
    }
  popMatrix();  
}

void plotXYContour(float x, float y, float z){
  pushMatrix();
    rotateVariable();
    scale(scaleFactor,scaleFactor,scaleFactor);
    translate(x*gridSize,y*gridSize); // set default zoom levels (may not be same for all axes)
    
    if (z == minZ){ 
        ellipse(0,0,12,12);
      } else { 
        ellipse(0,0,5,5);
      }
  popMatrix();  
}

void writeTitleAndInfo(){
  // Title
  fill(255);
  textAlign(CENTER);
  textSize(15);
  text("3D Scatter Plot and Modified 2D Contour Plot",0.5* width, 0.05 * height);
  textSize(18);
  text("Min Z = " + minZ + " @ X = " + minZX + " and @Y = " + minZY,0.5* width, 0.95 * height);
}

void plotGridAndAxis(){
  pushMatrix();
    rotateVariable();
    axes.render(scaleFactor,PI/2,25);
    if (gridOn == 1){
      grid.render(scaleFactor);
    }
  popMatrix();
}


void plotColorBar(int boxWidth){
  pushMatrix();
    rotateFixed();
    //translate(600,0,150);
    //translate(600,-1600,150);
    translate(width*0.8,0,-height*0.6);
   
    for (int i=0; i<colors.length; i++){
      pushMatrix();
        fill(colors[i]);
        box(boxWidth);
      popMatrix();
      translate(0,0,boxWidth);
    }
  popMatrix();
  
  
}

void plotColorBarLabels(int boxWidth){
  pushMatrix();
    rotateFixed();
    
    textAlign(LEFT);
    translate(width*0.8,0,-height*0.6);
    //Color Bar label
    for (int i=0; i<=colors.length; i++){  // <= here since we need an extra text value
      pushMatrix();
        rotateX(-PI/2); // rotate the text so it appears on the XZ plane
        textSize(15);
        fill(255);
        text(i*round(colorSpacing),25,15,00);
      popMatrix();
      translate(0,0,boxWidth);
    }
  popMatrix();    
}

void resetRotationAndZoom(){
  rotateX = PI/2;
  rotateY = -PI/2;
  rotateZ = PI/2;
  rotationStep = PI/20;
  scaleFactor = 1;
  scaleStep = 0.05;
  gridOn = 0;
  zDepth = -500;
}

private void rotateFixed(){
  rotateZ(PI/2);
  rotateX(PI/2);
  rotateY(-PI/2);  
}

private void rotateVariable(){
  rotateZ(rotateZ);
  rotateX(rotateX);
  rotateY(rotateY);
}
