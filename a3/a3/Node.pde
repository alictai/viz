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
   
   Node() {
       id = 0;
       mass = 0;
       dist_to_parent = 0;
       num_children = 0;
       resting_dist = 0;
       x = random(10, width-10);
       y = random(10, height-10);
       fx = 0;
       fy = 0;
       vx = 0;
       vy = 0;
       ax = 0;
       ay = 0;
   }
   
   Node(int i, float mas) {
       id = i;
       mass = mas;
       dist_to_parent = 0;
       num_children = 0;
       resting_dist = 0;
       x = random(10, width-10);
       y = random(10, height-10);
   }
   
   void update_position() {
      //assuming t = 1 frame
      float t = 1;
    
      //x
      float ax = fx/mass;
      x = x + vx*t + .5*ax*(t*t);
      vx = vx + ax*t;
    
      //y
      float ay = fy/mass;
      y = y + vy*t + .5*ay*(t*t);
      vy = vy + ay*t;
    }
   
}
