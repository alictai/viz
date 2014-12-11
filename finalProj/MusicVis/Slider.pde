class Bracket {
  float x, y, w, h;
  int val;
 
  Bracket() {
    val = (int)random(94);
  } 
  
}

class Slider {
  float x, y;
  float wid, hgt;
 
  Bracket left, right;
 
  Slider(float xx, float yy, float w, float h) {
    x = xx;
    y = yy;
    wid = w;
    hgt = h;
    
    left = new Bracket();
    right = new Bracket();
  } 
  
  void draw_slider() {
    stroke(100);
    strokeWeight(0);
    fill(100);
    rect(x, y, wid, hgt); 
    draw_range();
    //left.draw_self();
    //right.draw_self();
    
  }
  
  void draw_range() {
    stroke(70);
    strokeWeight(4);
    float x1 = x + 100;
    float x2 = wid - 100;
    float yn  = y + (hgt / 2);
    line(x1, yn, x2, yn);
    draw_notches(x1, x2, yn);
  }
  
  void draw_notches(float xl, float xr, float y) {
    float xloc;
    for(int i = 0; i < 94; i++) {
      xloc = lerp(xl, xr, (i / 94.0));
      //print(xloc, "\n");
    }
  }
  
  
  
  
}
