class Node {
   int id;
   float mass;
   Node parent;
   float dist_to_parent;
   float resting_dist;
   int num_children;
   float x, y;
   float fx, fy;
   float vx, vy;
   float ax, ay;
   float KE;
   boolean intersect;
   boolean drag;
   
   Node() {
       id = 0;
       mass = 0;
       dist_to_parent = 0;
       num_children = 0;
       resting_dist = 0;
       x = random(10, width-10);
       y = random(10, height-10);
       // x = height/2;
       // y = width/2;
       fx = 0;
       fy = 0;
       vx = 0;
       vy = 0;
       ax = 0;
       ay = 0;
       KE = 0;
       intersect = false;
       drag = false;
   }
   
   Node(int i, float mas) {
       id = i;
       mass = mas;
       dist_to_parent = 0;
       num_children = 0;
       resting_dist = 0;
       x = random(10, width-10);
       y = random(10, height-10);
       // x = height/2;
       // y = width/2;
   }
   
   void update_position(float damp_const) {
      //assuming t = 1 frame
      float t = 1;
                    
      if (!drag) {
      
          //print(fx, ",", fy, "\n");
          //x
          ax = fx/mass;
          x = x + vx*t + .5*ax*(t*t);
          vx = damp_const * (vx + ax*t);
          //print("x: ", x, "\n");
    
          //y
          ay = fy/mass;
          y = y + vy*t + .5*ay*(t*t);
          vy = damp_const * (vy + ay*t);
          //print("y: ", y, "\n");
      
          KE = .5 * mass * ((vx*vx) + (vy*vy));
          //print("KE is ", KE, "\n");
      
          // if (x < 10) { x = 10; }
          // if (y < 10) { y = 10; }
          // if (x > width-10) { x = width - 10; }
          // if (y > height-10) { y = height - 10; }
          
          /*
          if(id == 1) {
            print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
            print("X: f-", fx, " a-", ax, " v-", vx, " x-", x, "\n");
            print("Y: f-", fy, " a-", ay, " v-", vy, " y-", y, "\n\n\n");
          }
          */
      }
    }
   
    void intersect (int mousex, int mousey) {
    	float distance;
    	distance = sqrt(((mousex - x) * (mousex - x)) + ((mousey - y) * (mousey - y)));
    	if (distance < mass) { 
    		intersect = true; 
    	} else {
    		intersect = false;
    	}
    }

    void drag (int mousex, int mousey) {
    	if (intersect) {
    		drag = true;
    		x = float(mousex);
    		y = float(mousey);
    	}
    }
}
