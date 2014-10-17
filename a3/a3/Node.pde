class Node {
   int id;
   float mass;
   Node parent;
   float dist_to_parent;
   float resting_dist;
   int num_children;
   float x, y;
   
   Node() {
       id = 0;
       mass = 0;
       dist_to_parent = 0;
       num_children = 0;
       resting_dist = 0;
       x = 0;
       y = 0;
   }
   
   Node(int i, float mas) {
       id = i;
       mass = mas;
   }
   
}
