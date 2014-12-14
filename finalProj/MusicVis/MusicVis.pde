import java.awt.geom.Area;
import java.awt.geom.Rectangle2D;
import java.awt.Shape;
import wordcram.*;

int screenWidth = 1200;
int screenHeight = 700;

Parser   parser;
Display  toShow;
Slider   slider;
WordCram wc;
Range    range;
Range    prev_range;

//PGraphics canvas = this.createGraphics(screenWidth - 100, screenHeight - 100, P2D\\);
PImage image = createImage(1000, 650, RGB);
Shape imageShape = new ImageShaper().shape(image, #000000);
ShapeBasedPlacer placer = new ShapeBasedPlacer(imageShape);

void setup() {
  size(screenWidth, screenHeight);
  background(255);
  frameRate(30);

  parser = new Parser();
  UserData data = parser.parse("../merged.csv");
  wc = new WordCram(this);
  //wc.withCustomCanvas(this.canvas);
  toShow = new Display(wc, data);
  slider = new Slider(0, 650, 1200, 50);
  prev_range = new Range();
  prev_range.low = 0;
  prev_range.high = 93;



  /*
  if (frame != null) {
   frame.setResizable(true);
   }
   */
}


void draw() {
  slider.draw_slider();
  
  range = slider.get_range();
  if (range.low >= range.high) {
    range.high = range.low + 1;
  }
  
  boolean freqs_changed = toShow.get_freqs(range);
  
  if ((range_changed() == true) && (freqs_changed == true)) {
    wc = new WordCram(this);
    fill(255);
    rect(0, 0, 1200, 650);
  }
  
  
  toShow.draw_graphs(wc);
  print("Range: ", range.low, " to ", range.high, "\n");
  //find range from slider
  //pass range into Display's draw
  //display has range, pulls data, updates vizs
}

boolean range_changed() {
  if((range.low == prev_range.low) && (range.high == prev_range.high)) {
      return false;
  } else {
      prev_range = range;
      return true;
  }
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

