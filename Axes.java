import processing.core.*; 

class Axes{
  
  PApplet p;
  
  Axes(PApplet p){
    this.p = p;  
  }
  
  public void render(float scaleFactor, float rotate, int textSize){
    int len = 400;
    p.pushMatrix();
      p.scale(scaleFactor, scaleFactor, scaleFactor);
      p.strokeWeight(3);
      p.stroke(255,0,0);
      p.line(0,0,0,len,0,0);
      p.stroke(0,255,0);
      p.line(0,0,0,0,len,0);
      p.stroke(0,0,255);
      p.line(0,0,0,0,0,len);
      p.strokeWeight(1);
      annotateAxis(rotate, textSize, len);
    p.popMatrix();    
  }
  
  private void annotateAxis(float rotate, int textSize, int len){
    p.textSize(textSize);
    p.pushMatrix();
      p.rotateX(rotate); // rotate the text so it appears on the XZ plane
      p.textSize(30);
      p.text("X",len+25,0,0);
    p.popMatrix();
    
    p.pushMatrix();
      p.translate(0,len+25,0);
      p.rotateX(-rotate);
      p.rotateY(rotate*2);
      p.textSize(18);
      p.text("Y",0,0,0);
    p.popMatrix();
    
    p.pushMatrix();
      p.translate(-50,0,len+25);
      p.rotateX(-rotate);
      p.textSize(30);    
      p.text("Z",0,0,0);
    p.popMatrix();
    
        
      
  }
  
}
