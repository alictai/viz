import java.awt.geom.Area;
import java.awt.geom.Rectangle2D;
import java.awt.Shape;
import wordcram.*;

int screenWidth = 1200;
int screenHeight = 700;

Parser   parser;
Display  toShow;
Slider   slider;
Range    range;

//PGraphics canvas = this.createGraphics(screenWidth - 100, screenHeight - 100, P2D\\);
PImage image = createImage(1000, 650, RGB);
Shape imageShape = new ImageShaper().shape(image, #000000);
ShapeBasedPlacer placer = new ShapeBasedPlacer(imageShape);

void setup() {
  size(screenWidth, screenHeight);
  frameRate(30);

  parser = new Parser();
  UserData data = parser.parse("../merged.csv");
  WordCram wc = new WordCram(this);
  //wc.withCustomCanvas(this.canvas);
  toShow = new Display(wc, data);
  slider = new Slider(0, 650, 1200, 50);




  /*
  if (frame != null) {
   frame.setResizable(true);
   }
   */
}


void draw() {
  //canvas.beginDraw();
  //canvas.background(0, 0);
  //canvas.endDraw();
  slider.draw_slider();
  toShow.draw_graphs();
  range = slider.get_range();
  print("Range: ", range.low, " to ", range.high, "\n");
  //find range from slider
  //pass range into Display's draw
  //display has range, pulls data, updates vizs
}

/* events */

void mousePressed() {
  slider.check_brackets();
}

void mouseReleased() {
  slider.unactivate();
}

void mouseDragged() {
  slider.move_brackets();
}

