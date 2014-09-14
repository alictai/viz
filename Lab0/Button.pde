class Button {
   boolean isect;
   float curr_h, curr_w;
   float h1, h2, w1, w2;
   float curr_posx, curr_posy;
   float posx1, posx2, posy1, posy2;
   color curr_color;
   color C1, C2;
   String curr_text;
   String T1, T2;
   
   Button(float screen_h, float screen_w) {
     isect = false;
     h1 = screen_h/2;
     h2 = screen_h/3;
     w1 = screen_w/2;
     w2 = screen_w/3;
     curr_h = h1;
     curr_w = w1;
     posx1 = screen_w/4;
     posx2 = screen_w/3;
     curr_posx = posx1;
     posy1 = screen_h/4;
     posy2 = screen_h/3;
     curr_posy = posy1;
     C1 = color(random(127, 255), random(127, 255), random(127, 255));
     C2 = color(random(127, 255), random(127, 255), random(127, 255));
     curr_color = C1;
     T1 = "Big Button";
     T2 = "Small Button";
     curr_text = T1;
   }
   
   void draw_button () {
       fill (curr_color);
       rect(curr_posx, curr_posy, curr_w, curr_h);
       textSize(10);
       fill(0,0,0);
       textAlign(CENTER, CENTER);
       text(curr_text, curr_posx + (curr_w/2), curr_posy + (curr_h/2));
   }
   
   void intersect (int mousex, int mousey) {
       if (mousex < (curr_posx + curr_w) && mousex > curr_posx) {
           if (mousey < (curr_posy + curr_h) && mousey > curr_posy) {
             isect = true;
           }
       } else {
         isect = false;
       }
   }
   
   void update () {
        isect = false;
        
        if (curr_h == h1) {
          //Size Change
          curr_h = h2;
          curr_w = w2;
          //Color Change
          curr_color = C2;
          //Position Change
          curr_posx = posx2;
          curr_posy = posy2;
          //Text Change
          curr_text = T2;
        } else {
          curr_h = h1;
          curr_w = w1;
          curr_color = C1;
          curr_posx = posx1;
          curr_posy = posy1;
          curr_text = T1;
        }
   }
   
   boolean getIsect() { return isect; }
   float getHeight () { return curr_h; }
   float getWidth () { return curr_w; }
   float getPosX () { return curr_posx; }
   float getPosY () { return curr_posy; }
   float getColor() { return curr_color; }
   
}
   
