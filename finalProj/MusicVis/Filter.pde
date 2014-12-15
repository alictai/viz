class Filter {
  float x, y;
  float wid, hgt;
  
  Slider    slider;
  //Gen_Check gencheck;
 
 
 
  Filter(float _x, float _y, float w, float h) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    
    float s_x = x + 20;
    float s_y = y + 75; 
    float s_w = wid - 400;
    slider = new Slider(x + 20, y + 75, w - 400);
    //gencheck = new Gen_Check();
   
  } 
  
  void draw_filter() {
    fill(100);
    strokeWeight(0);
    rect(x, y, wid, hgt); 
    
    slider.draw_slider(); 
  }
  
  Range get_range() {
    return slider.get_range(); 
  }
  
  //rename
  void pressed() {
    slider.check_brackets(); 
  }
  
  //rename
  void move_brackets() {
    slider.move_brackets();
  }
  
  void released() {
    slider.unactivate(); 
  }
  
}
