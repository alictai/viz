class Gen_Check {
  float x, y;
  float wid, hgt;
  
  String title;
  
  boolean active;
 
  Gen_Check(float _x, float _y, float w, float h, boolean act, String t) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    active = act;
    title = t;
  } 
  
  void draw_gen() {
    if(active) {
     fill(200);
    } else {
     fill(70);
    } 
    
    textAlign(CENTER, CENTER);
    textSize(25);
    text(title, x, y);
  }
  
}

class Filter {
  float x, y;
  float wid, hgt;
  
  Slider    slider;
  Gen_Check male;
  Gen_Check female;
 
 
 
  Filter(float _x, float _y, float w, float h) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    
    float s_x = x + 20;
    float s_y = y + 75; 
    float s_w = wid - 400;

    slider = new Slider(x + 20, y + 25, w - 400);

    male   = new Gen_Check(wid - 470, y + 60, 30, 10, true, "male");
    female = new Gen_Check(x + 70,    y + 60, 40, 10, true, "female");   
  } 
  
  void draw_filter() {
    fill(100);
    strokeWeight(0);
    rect(x, y, wid, hgt); 
    
    draw_prompt();
    slider.draw_slider(); 
    male.draw_gen();
    female.draw_gen();
  }
  
  void draw_prompt() {
    PFont font;
    font = loadFont("DejaVuSans-20.vlw");
    textFont(font, 20);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    textLeading(18);
    text("SELECT AGE AND\nGENDER DEMOGRAPHIC", x + 420, y + 65);
    
  }
  
  
  Range get_range() {
    return slider.get_range(); 
  }
  
  //rename
  void pressed() {
    slider.check_brackets(); 
  }
  /*
  //rename
  void move_brackets() {
    slider.move_brackets();
  }
  */
  void released() {
    slider.unactivate(); 
  }
  
}
