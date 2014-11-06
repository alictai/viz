class Node {
   int id;
   int num_names;
   Node parent;
   float dist_to_parent;
   //int num_children;
   float x, y;
   float fx, fy;
   float vx, vy;
   float ax, ay;
   float KE;
   boolean intersect;
   boolean drag;
   float radius;
   String[] names;
   int[][] intern_links;
   Extern_link[] extern_links;
   
   Node() {
       id = 0;
       num_names = 0;
       dist_to_parent = 0;
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
       extern_links = new Extern_link[0];
   }
   
   Node(int i, int mas) {
       id = i;
       num_names = mas;
       dist_to_parent = 0;
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
       radius = crunch();
       extern_links = new Extern_link[0];
   }
   
   int which_index(String name) {
       for (int i = 0; i < num_names; i++) {
           if (name.equals(names[i])) {
              return i; 
           }
       }
       
       return -1;
   }
   
   void add_extern(int for_node, String loc_name, String for_name) {
       Extern_link temp = new Extern_link(for_node, loc_name, for_name);
       extern_links = (Extern_link[])append(extern_links, temp);
   }
   
   float crunch() {
       return (map(num_names, 1, 10, 5, 20));
   }
   
   void update_position(float damp_const) {
        //assuming t = 1 frame
        float t = 1;
                    
        if (!drag) {
            //x
            ax = fx/num_names;
            x = x + vx*t + .5*ax*(t*t);
            vx = damp_const * (vx + ax*t);
    
            //y
            ay = fy/num_names;
            y = y + vy*t + .5*ay*(t*t);
            vy = damp_const * (vy + ay*t);
      
            KE = .5 * num_names * ((vx*vx) + (vy*vy));
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
