class ForceNode {
   String id;
   float mass;
   ForceNode parent;
   float dist_to_parent;
   int num_children;
   float x, y;
   float fx, fy;
   float vx, vy;
   float ax, ay;
   float KE;
   boolean intersect;
   boolean drag;
   float radius;
   
   ForceNode() {
       id = "0";
       mass = 0;
       dist_to_parent = 0;
       num_children = 0;
       x = random(10, width-10);
       y = random(10, height-10);
       fx = 0;
       fy = 0;
       vx = 0;
       vy = 0;
       ax = 0;
       ay = 0;
       KE = 0;
       intersect = false;
       drag = false;
       radius = 0;
   }
   
   ForceNode(String i, float mas, int canvas_w, int canvas_h) {
       id = i;
       mass = mas;
       dist_to_parent = 0;
       num_children = 0;
       x = random(10, canvas_w-10);
       y = random(10, canvas_h-10);
       fx = 0;
       fy = 0;
       vx = 0;
       vy = 0;
       ax = 0;
       ay = 0;
       KE = 0;
       intersect = false;
       drag = false;
       radius = crunch();
   }
   
   float crunch() {
       return (map(mass, 1, 10, 1, 10));
   }
   
   void update_position(float damp_const) {
        //assuming t = 1 frame
        float t = 1;
                    
        if (!drag) {
            //x
            ax = fx/mass;
            x = x + vx*t + .5*ax*(t*t);
            vx = damp_const * (vx + ax*t);
    
            //y
            ay = fy/mass;
            y = y + vy*t + .5*ay*(t*t);
            vy = damp_const * (vy + ay*t);
      
            KE = .5 * mass * ((vx*vx) + (vy*vy));
        }
            
        if (x < 10) { x = 10; }
        if (y < 10) { y = 10; }
        if (x > width-10) { x = width - 10; }
        if (y > height-10) { y = height - 10; }
    }
   
    void intersect (int mousex, int mousey) {
      float distance;
      distance = sqrt(((mousex - x) * (mousex - x)) + ((mousey - y) * (mousey - y)));
      if (distance < radius) { 
        intersect = true; 
      } else {
        intersect = false;
      }
    }

    boolean drag (int mousex, int mousey) {
      if (intersect) {
        drag = true;
        x = float(mousex);
        y = float(mousey);
                return true;
      }
        return false;
    }
}
