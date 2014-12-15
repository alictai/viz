import java.awt.geom.Area;
import java.awt.geom.Rectangle2D;
import java.awt.Shape;
import wordcram.*;

int screenWidth = 1200;
int screenHeight = 700;

Parser   parser;
Display  toShow;
Slider   slider;
Filter   filter;
WordCram wc;
Range    range;
Range    prev_range;
boolean clicked;

//PGraphics canvas = this.createGraphics(screenWidth - 100, screenHeight - 100, P2D\\);
PImage image = createImage(1000, 650, RGB);
Shape imageShape = new ImageShaper().shape(image, #000000);
ShapeBasedPlacer placer = new ShapeBasedPlacer(imageShape);

void setup() {
  size(screenWidth, screenHeight);
  background(255);
  frameRate(60);

  parser = new Parser();
  UserData data = parser.parse("../merged.csv");
  wc = new WordCram(this);
  //wc.withCustomCanvas(this.canvas);
  toShow = new Display(wc, data);
  filter = new Filter(0, 600, 1200, 100);
  prev_range = new Range();
  prev_range.low = 0;
  prev_range.high = 93;
  clicked = false;


  /*
  if (frame != null) {
   frame.setResizable(true);
   }
   */
}


void draw() {
  //slider.draw_slider();
  filter.draw_filter();
  
  range = filter.get_range();
  if (range.low >= range.high) {
    range.high = range.low + 1;
  }
  
  toShow.get_freqs(range);
  
  if(!mousePressed) {
    if (range_changed() == true) {
      if(range_changed() == true) {print("changed\n");}
      wc = new WordCram(this);
      fill(255);
      noStroke();
      rect(0, 0, 1200, 600);
    }
  }
  
  toShow.draw_graphs(wc, range, gender);
  
  
  //print("Range: ", range.low, " to ", range.high, "\n");
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

void mouseClicked() {
  toShow.set_click();
}

void mousePressed() {
  filter.pressed();
}

void mouseReleased() {
  filter.released();
}

