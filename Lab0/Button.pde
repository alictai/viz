class Button {
   boolean isect;
   float curr_h, curr_w;
   float h1, h2, w1, w2;
   float posx, posy;
   color curr_color;
   color C1, C2;
   String curr_text;
   String T1, T2;
   
   Button(float screen_h, float screen_w, float x, float y) {
     isect = false;
     h1 = screen_h/2;
     h2 = screen_h/3;
     w1 = screen_w/2;
     w2 = screen_w/3;
     curr_h = h1;
     curr_w = w1;
     posx = x;
     posy = y;
     C1 = color(random(127, 255), random(127, 255), random(127, 255));
     C2 = color(random(127, 255), random(127, 255), random(127, 255));
     curr_color = C1;
     T1 = "Big Button";
     T2 = "Small Button";
     curr_text = T1;
   }
   
   void draw_button () {
       fill (curr_color);
       rect(posx, posy, curr_w, curr_h);
       textSize(32);
       fill(0,0,0);
       textAlign(CENTER, CENTER);
       text(T1, posx + (curr_w/2), posy + (curr_h/2));
   }
   
   void intersect (int mousex, int mousey) {
       if (mousex < (posx + curr_w) && mousex > posx) {
           if (mousey < (posy + curr_h) && mousey > posy) {
             isect = true;
           }
       } else {
         isect = false;
       }
   }
   
   void update () {
        isect = false;
        
        //Size Change
        if (curr_h == h1) {
          curr_h = h2;
          curr_w = w2;
        } else {
          curr_h = h1;
          curr_w = w1;
        }
        
        // Color Change
        if (curr_color == C1) {
           curr_color = C2;
        } else {
           curr_color = C1;
        }
   }
   
   boolean getIsect() { return isect; }
   float getHeight () { return curr_h; }
   float getWidth () { return curr_w; }
   float getPosX () { return posx; }
   float getPosY () { return posy; }
   
}
   
