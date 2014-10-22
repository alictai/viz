class Graph {
   Node[] nodes;
   Rels[] relations;
   float k_h, k_c, k_damp;
   float thresh;
   boolean start;
   
   Graph() { 
      k_h = .2;
      k_c = 1000;
      k_damp = .5;
      thresh = 0;
      start = true;
   }
   void draw_graph() {
       float total_KE = calc_KE();     
       if(total_KE > thresh || start) {
           update_with_forces();
           start = false;
       } else {
           //print("you hit the threshold!\n");
           update_with_forces();
       }
       draw_edges();
       draw_nodes();
   }

   //finds total coulumb and hooke's forces for all nodes
    void calc_forces() {
        initialize_forces();
        find_coulumb();
        find_hooke();
    }
   
   float calc_KE() {
       float total = 0;
       for(int i = 0; i < nodes.length; i++) {
           total += nodes[i].KE;
       }
       //print("total: ", total, "\n");
       return total;
   }
   
   void update_with_forces() {
     for (int i = 0; i < nodes.length; i++) {
           //print(nodes[i].x, ", ", nodes[i].y, "\n");
           nodes[i].update_position(k_damp);
           //print(nodes[i].x, ", ", nodes[i].y, "\n");
       }
       
       for (int k = 0; k < relations.length; k++) {
           Node n1 = lookup(relations[k].node1);
           Node n2 = lookup(relations[k].node2);
           
           relations[k].update_curr(n1.x, n1.y, n2.x, n2.y);
       }
   }
   
   void draw_nodes() {
       int size = 0;
       for (int i = 0; i < nodes.length; i++) {
          stroke(0, 102, 153);
          if (nodes[i].intersect) {
          	fill(0);
          	textAlign(CENTER);
          	String label = "ID: " + nodes[i].id + ", MASS: " + nodes[i].mass;
          	text(label, nodes[i].x, nodes[i].y - nodes[i].mass);
          	fill (255, 0, 0);
          } else {
          	fill(16, 220, 250);
          }
          ellipse(nodes[i].x, nodes[i].y, 2*nodes[i].mass, 2*nodes[i].mass);
       }
     
   }
   
   void draw_edges() {
     stroke(0, 102, 153);
     Node n1, n2;
     for (int i = 0; i < relations.length; i++) {
           n1 = lookup(relations[i].node1);
           n2 = lookup(relations[i].node2);
           line(n1.x, n1.y, n2.x, n2.y);
       }
   }
   
   Node lookup(int id) {
       Node toret = null;
       for (int i = 0; i < nodes.length; i++) {
           if (nodes[i].id == id) {
              toret = nodes[i]; 
           }
       }
       return toret;
   }

    void initialize_forces() {
       for(int i = 0; i < nodes.length; i++) {
          nodes[i].fx = 0;
          nodes[i].fy = 0;
       }
    }

    //for all nodes, finds coulumb forces from other nodes
    void find_coulumb() {
        for (int i = 0; i < nodes.length; i++) {
            accumulate_coulumb(nodes[i]);
        }
    }

    //for a single node, find coulumb forces from other nodes
    void accumulate_coulumb(Node n) {
        for (int i = 0; i < nodes.length; i++) {
            if (nodes[i].id != n.id) {
            	// restricts nodes from landing on top of each other
            	if (n.x == nodes[i].x) { n.x = n.x - 1; } 
            	if (n.y == nodes[i].y) { n.y = n.y + 1; }
            
                float dist_y = abs(nodes[i].y - n.y);
                float dist_x = abs(nodes[i].x - n.x);
                float dist_total = sqrt((dist_y * dist_y) + (dist_x * dist_x));
                float theta_rad = atan(dist_y / dist_x);
                
                float force_c = k_c / (dist_total * dist_total);
                
                int dir = check_dir(n.x, nodes[i].x);
                n.fx += dir * (cos(theta_rad) * force_c);
                int dir2 = check_dir(n.y, nodes[i].y);
                n.fy += dir2 * (sin(theta_rad) * force_c);
                            
            	//n.fx += calc_coulumb(n.x, nodes[i].x);
            	//n.fy += calc_coulumb(n.y, nodes[i].y); 
            }
        }
    }
    /*
    float calc_coulumb(float target, float pusher) {
        int dir = check_dir(target, pusher);
        float force_c = dir * k_c / ((pusher - target)*(pusher - target));
        return force_c;
    }
    */

    // for all edges, finds hooke force effects for both affected nodes
    void find_hooke() {   
        Node n1, n2;
        for (int i = 0; i < relations.length; i++) {
           n1 = lookup(relations[i].node1);
           n2 = lookup(relations[i].node2);
           
           boolean n1Lock = n1.drag;
           boolean n2Lock = n2.drag;
           
           float ex = relations[i].curr_edge_x;
           float targex = relations[i].targ_edge_x;
           float ey = relations[i].curr_edge_y;
           float targey = relations[i].targ_edge_y;

           n1.fx += calc_hooke(n1.x, n2.x, ex, targex);
           n1.fy += calc_hooke(n1.y, n2.y, ey, targey);
           n2.fx += calc_hooke(n2.x, n1.x, ex, targex);
           n2.fy += calc_hooke(n2.y, n1.y, ey, targey);
           
           if(n1Lock) {
             n2.fx *= 2;
             n2.fy *= 2;
           }
           
           if(n2Lock) {
             n1.fx *= 2;
             n1.fy *= 2;
           }
        }
        
    }
    
    float calc_hooke(float target, float pusher, float e, float targe) {
        int dir = check_dir(target, pusher);
        float force_h = dir * k_h * (targe - e);
        
        return force_h;
    }
    
    int check_dir (float target, float pusher) {
        if (target < pusher) {
           return -1; 
        } else {
          return 1;
        }
    }

    void intersect(int mousex, int mousey) {
    	for(int i = 0; i < nodes.length; i++) {
    		nodes[i].intersect(mousex, mousey);
    	}

    }

    void drag(int mousex, int mousey) {
    	for (int i = 0; i < nodes.length; i++) {
    		nodes[i].drag(mousex, mousey);
    	}
    }
    
    void undrag() {
       for (int i = 0; i < nodes.length; i++) {
          nodes[i].drag = false;
       } 
    }
    
}
