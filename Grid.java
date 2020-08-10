import processing.core.*;

class Grid
{
  private int size;
  private int step;
  private PApplet p;
  
  public Grid(PApplet p, int _size, int _step){
    this.p = p;
    size = _size;
    step = _step;
  }
  
  public void render(float scaleFactor){
    p.stroke(200);
    p.strokeWeight(0.5f);
    p.noFill();
    p.rectMode(PApplet.CORNER);
    p.pushMatrix();
      //rotateX(PI/2);  // commented out since rendering on XY Scale
      p.scale(scaleFactor, scaleFactor, scaleFactor);
      p.translate(-(step * size * 0.5f), -(step * size * 0.5f), 0);
      p.pushMatrix();
      for(int i = 0; i < size; i++)
      {
        for(int j = 0; j < size; j++)
        {
          p.rect(i * step, j * step, step, step);  
        }
      }
      p.popMatrix();
    p.popMatrix();
  }
}
