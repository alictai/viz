class Graph {
   Node[] nodes;
   Rels[] relations;
   float k_h, k_c;
   
   Graph() {
      k_h = 5.0; 
      k_c = 2.0;
   }
   void draw_graph() {
       for (int i = 0; i < nodes.length; i++) {
           //print(nodes[i].x, ", ", nodes[i].y, "\n");
           nodes[i].update_position();
       }
       draw_edges();
       draw_nodes();
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
        //find_hooke();
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
           // call calc_hooke() to accumualte fx and fy
        }
    }
    
    float calc_hooke(float target, float pusher) {
        
    }
    
    int check_dir (float target, float pusher) {
        if (target < pusher) {
           return -1; 
        } else {
          return 1;
        }
    }

}
