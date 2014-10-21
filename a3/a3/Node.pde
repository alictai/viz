class Node {
   int id;
   float mass;
   Node parent;
   float dist_to_parent;
   float resting_dist;
   int num_children;
   float x, y;
   float Fx, Fy;
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
      float ax = Fx/mass
      x = x + vxt + .5*ax*(t^2)
      vx = vx + ax*t
    
      //y
      float ay = Fy/mass
      y = y + vyt + .5*ay*(t^2)
      vy = vy + ay*t
    }
   
}
