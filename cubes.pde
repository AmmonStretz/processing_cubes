
color bgColor;
interface Colorator {
  void colorize(float value, PVector pos);
}
class Colorator1 implements Colorator{
  void colorize(float value, PVector pos) {
    noStroke();
    fill(bgColor);
  }
}
class Colorator2 implements Colorator{
  void colorize(float value, PVector pos) {
    noStroke();
    fill(3.5*255/6,255,85, 255*value);
  }
}
class AnimationOptions {
  float minAnimation, maxAnimation, minClamp, maxClamp, scale;
  Colorator col;
  AnimationOptions(float minAnimation, float maxAnimation, float minClamp, float maxClamp, float scale, Colorator col) {
    this.minAnimation = minAnimation;
    this.maxAnimation = maxAnimation;
    this.minClamp = minClamp;
    this.maxClamp = maxClamp;
    this.scale = scale;
    this.col = col;
  }
}
class Pattern {
  float r, w, h;
  Pack[][] packs;
  Pattern(float r, int w, int h) {
    this.r = r;
    packs = new Pack[h][];
    for(int y = 0; y < packs.length; y++) {
      packs[y] = new Pack[w];
      for(int x = 0; x < packs[0].length; x++) {
        packs[y][x] = new Pack(new PVector(2*r*x*cos(PI/6.0)+r*cos(PI/6.0)*(y%2),y*r*1.5), r);
      }
    }
    this.w = r*sin(PI/3.0)+2*r*sin(PI/3.0)*packs[0].length;
    this.h = r*sin(PI/6.0)+packs.length*(r+r*sin(PI/6.0));
  }
  void draw(float time, AnimationOptions opt) {
    translate(
      r*sin(PI/3.0)-0.5*(r*sin(PI/3.0)+2*r*sin(PI/3.0)*packs[0].length),
      0.5*r+0.5*(r*sin(PI/6.0)-packs.length*(r+r*sin(PI/6.0)))
    );
    for(int y = 0; y < packs.length; y++) {
      for(int x = 0; x < packs[0].length; x++) {
        packs[y][x].draw(time, opt);
      }
    }
  }
}
class Pack {
  PVector pos, a, b, c, d, e, f;
  float r;
  PShape diamond;
  Pack(PVector pos, float r) {
    this.pos = pos;
    this.r = r;
    float PI3 = TWO_PI/6.0;
    this.a = new PVector(pos.x + r*sin(0*PI3), pos.y - r*cos(0*PI3));
    this.b = new PVector(pos.x + r*sin(1*PI3), pos.y - r*cos(1*PI3));
    this.c = new PVector(pos.x + r*sin(2*PI3), pos.y - r*cos(2*PI3));
    this.d = new PVector(pos.x + r*sin(3*PI3), pos.y - r*cos(3*PI3));
    this.e = new PVector(pos.x + r*sin(4*PI3), pos.y - r*cos(4*PI3));
    this.f = new PVector(pos.x + r*sin(5*PI3), pos.y - r*cos(5*PI3));
    
    diamond = getDiamant();
  }
  float clamp(float value, float minimum, float maximum) {
    return min(max(value,minimum),maximum);
  }
  void draw(float time, AnimationOptions opt) {
    for(int i = 0; i<3; i++) {
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(i*TWO_PI/3.0);
      translate(0,-r*0.5);
      PVector mat = new PVector(modelX(0,0,0)/400.0,modelY(0,0,0)/400.0);
      //scale(0.90);
      float s =
        opt.scale *
        clamp(
          map(
            sin(time+2*TWO_PI*noise(mat.x,mat.y)),
            -1,1,opt.minAnimation,opt.maxAnimation
          ),
          opt.minClamp,
          opt.maxClamp
        );
      scale(s);
      opt.col.colorize(s, mat);
      //scale(min(map(noise(mat.x/100.0, mat.y/100.0, time),0,1,0.75,0.95),1));
      shape(diamond);
      popMatrix();
    }
  }
  PShape getDiamant() {
    PShape d = createShape();
    d.beginShape();
    d.vertex(0, -r*0.5);
    d.vertex(r*sin(PI/3.0), 0);
    d.vertex(0, r*0.5);
    d.vertex(-r*sin(PI/3.0), 0);
    d.endShape(CLOSE);
    d.disableStyle();
    return d;
  }
}
Pattern pattern, pattern1, pattern2;

void setup() {
  fullScreen(P3D);
  //size(500, 500, P3D);
  pattern = new Pattern(50, 3*7, 2*8);
  //pattern1 = new Pattern(50, 7, 8);
  //pattern = new Pattern(r, 9, 10);
  colorMode(HSB);
  bgColor= color(3.5*255/6,255,35);
  noCursor();
}
void draw() {
  AnimationOptions opt0 =new AnimationOptions(-0.2, 1.2, 0, 1, 0.8, new Colorator2());
  AnimationOptions opt1 =new AnimationOptions(-0.2, 1.2, 0, 1, 0.7, new Colorator1());
  float time = millis() / 1000.0;
  //minAnimation, maxAnimation, minClamp, maxClamp
  
  background(bgColor);
  
  translate(width/2.0, height/2.0);
  //blendMode(ADD);
  //rotate(-millis()/4000.0);
  pushMatrix();
    fill(255,255,255);
    pattern.draw(time, opt0);
  popMatrix();
  pushMatrix();
    noStroke();
    fill(255,0,0);
    pattern.draw(time-PI/6.0, opt1);
  popMatrix();
}
