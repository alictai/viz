int screenWidth = 1200;
int screenHeight = 700;

Parser   parser;
Display  toShow;
Slider   slider;

void setup() {
  
  parser = new Parser();
  parser.parse("../merged.csv");
  
  toShow = new Display();
  slider = new Slider(0, 650, 1200, 50);
  
  frameRate(30);
  
  size(screenWidth, screenHeight);
  /*
  if (frame != null) {
    frame.setResizable(true);
  }
  */
   
}


void draw() {
  background(230);
  slider.draw_slider();
  //find range from slider
  //pass range into Display's draw
  //display has range, pulls data, updates vizs
  
}

/* events */
