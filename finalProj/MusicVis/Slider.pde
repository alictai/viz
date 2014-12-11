/*************************************************************************/
/*                            BRACKET CLASS                              */
/*************************************************************************/
class Bracket {
  float x, y;                       //pos on slide line
  float w, h;                       //static width and height
  float int_l, int_r, int_t, int_b; //box for intersecting
  float l_bound, r_bound;           //
  int val;                          //value held on slider bar
  boolean isLeft;
  boolean active;                   //currently being dragged
 
  Bracket(float _x, float _y, float _l, float _r, int start, boolean l) {
    x = _x;
    y = _y;
    l_bound = _l;
    r_bound = _r;
    w = 8;
    h = 30;
    
    int_l = x - w/2;
    int_r = x + w/2;
    int_t = y - h/2;
    int_b = y + h/2;
    
    val = start;
    isLeft = l;
    active = false;
  } 
  
  void draw_self() {
    float x2;
    
    if (isLeft) {
      x2 = x + (w/2);
    } else {
      x2 = x - (w/2);
    }
    
    stroke(200, 0, 0);
    strokeWeight(5);
    
    line(x, y - (h/2), x,  y + (h/2)); //vert part of bracket
    line(x, y - (h/2), x2, y - (h/2)); //top horiz of bracket
    line(x, y + (h/2), x2, y + (h/2)); //bot horiz of bracket
  }
  
  void check_click() {
    if((mouseX > int_l && mouseX < int_r) && (mouseY > int_t && mouseY < int_b)) {
      active = true;
    } 
  }
  
  void move(float oth_x) {
    if(active) {
      float lb, rb;
      
      //determining bracket's range
      if(isLeft) {
        lb = l_bound;
        rb = oth_x;
      } else {
        lb = oth_x;
        rb = r_bound;
      }
            
      if(mouseX > lb && mouseX < rb) {
        float curr, l, r;
        curr = map(val, 0, 93, l_bound, r_bound);
        l    = map(val - 1, 0, 93, l_bound, r_bound);
        r    = map(val + 1, 0, 93, l_bound, r_bound);
                
        //while (! (abs(mouseX - l) < abs(mouseX - curr)) || (abs(mouseX - r) < abs(mouseX - curr))) {
          if (abs(mouseX - l) < abs(mouseX - curr)) {
             val--;
             x = l;
             int_l = x - w/2;
             int_r = x + w/2;
          } else if (abs(mouseX - r) < abs(mouseX - curr)) {
             val++;
             x = r;
             int_l = x - w/2;
             int_r = x + w/2;
          }
        //}
      }
    } 
  }
  
  void unactivate() {
    active = false; 
  }
}

/*************************************************************************/
/*                             SLIDER CLASS                              */
/*************************************************************************/

class Slider {
  float x, y;
  float wid, hgt;
  float range_buf = 100;
 
  Bracket left, right;
 
  Slider(float _x, float _y, float w, float h) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    
    left  = new Bracket(x + range_buf,   y + h/2, x + range_buf, wid - range_buf, 0,  true);
    right = new Bracket(wid - range_buf, y + h/2, x + range_buf, wid - range_buf, 93, false); 
  } 
  
  void draw_slider() {
    stroke(100);
    strokeWeight(0);
    fill(100);
    rect(x, y, wid, hgt); 
    draw_range();
    
  }
  
  void draw_range() {
    stroke(70);
    strokeWeight(4);
    float x1 = x + range_buf;
    float x2 = wid - range_buf;
    float yn  = y + (hgt / 2);
    line(x1, yn, x2, yn);
    draw_notches(x1, x2, yn);
  }
  
  void draw_notches(float xl, float xr, float y) {
    float xloc;
    int l_id = left.val;
    int r_id = right.val;
    for(int i = 0; i < 94; i++) {
      xloc = lerp(xl, xr, (i / 93.0));
      line(xloc, y - 8, xloc, y + 8);
      
      if(i == l_id) {
        left.draw_self(); 
        stroke(200);
        strokeWeight(4);
      }
      
      if(i == r_id) {
        right.draw_self(); 
        stroke(70);
        strokeWeight(4);
      }
    }
  }
  
  void check_brackets() {
    left.check_click();
    if (left.val != right.val) {
      right.check_click();
    }
  }
  
  void move_brackets() {
    left.move(right.x);
    right.move(left.x);
  }
  
  void unactivate() {
    left.unactivate();
    right.unactivate(); 
  }
  
  
}
