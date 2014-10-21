class Graph {
   Node[] nodes;
   Rels[] relations;
   float k_h, k_c;
   float KE_threshold;
   boolean start;
   
   Graph() {
      k_h = 1.0; 
      k_c = 1.0;
      KE_threshold = 0;
      start = true;
   }
   void draw_graph() {
       float total_KE = calc_KE();       
       if(total_KE > KE_threshold || start) {
           update_with_forces();
           start = false;
       } else {
         print("you hit the threshold!\n");
       }
       draw_edges();
       draw_nodes();
   }
   
   float calc_KE() {
       float total = 0;
       for(int i = 0; i < nodes.length; i++) {
           total += nodes[i].KE;
       }
       return total;
   }
   
   void update_with_forces() {
     for (int i = 0; i < nodes.length; i++) {
           //print(nodes[i].x, ", ", nodes[i].y, "\n");
           nodes[i].update_position();
       }
       
       for (int k = 0; k < relations.length; k++) {
           Node n1 = lookup(relations[k].node1);
           Node n2 = lookup(relations[k].node2);
           
           relations[k].update_act(n1.x, n1.y, n2.x, n2.y);
       }
     
   }
   
   void draw_nodes() {
       int size = 0;
       for (int i = 0; i < nodes.length; i++) {
          stroke(0, 102, 153);
          fill(16, 220, 250);
          ellipse(nodes[i].x, nodes[i].y, nodes[i].mass, nodes[i].mass);
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
   
   
    //finds total coulumb and hooke's forces for all nodes
    void calc_forces() {
        initialize_forces();
        find_coulumb();
        find_hooke();
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
              n.fx += calc_coulumb(n.x, nodes[i].x);
              n.fy += calc_coulumb(n.y, nodes[i].y);
            }
        }
    }
    
    float calc_coulumb(float target, float pusher) {
        int dir = check_dir(target, pusher);
        return dir * k_c / (abs(pusher - target));
    }

    // for all edges, finds hooke force effects for both affected nodes
    void find_hooke() {
        Node n1, n2;
        for (int i = 0; i < relations.length; i++) {
           n1 = lookup(relations[i].node1);
           n2 = lookup(relations[i].node2);
           
           float ex = relations[i].act_edge_x;
           float rex = relations[i].r_edge_x;
           float ey = relations[i].act_edge_y;
           float rey = relations[i].r_edge_x;
           
           n1.fx += calc_hooke(n1.x, n2.x, ex, rex);
           n1.fy += calc_hooke(n1.y, n2.y, ey, rey);
           n2.fx += calc_hooke(n2.x, n1.x, ex, rex);
           n2.fy += calc_hooke(n2.y, n1.y, ey, rey);
        }
    }
    
    float calc_hooke(float target, float pusher, float e, float re) {
        int dir = check_dir(target, pusher);
        return dir * k_h*(abs(e - re));
    }
    
    int check_dir (float target, float pusher) {
        if (target < pusher) {
           return -1; 
        } else {
          return 1;
        }
    }

}
