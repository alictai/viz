class Graph {
   Node[] nodes;
   Rels[] relations;
   
   void draw_graph() {
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
     for (int i = 0; i < relations.length; i++) {
          line(relations[i].node1.x, relations[i].node1.y, relations[i].node2.x, relations[i].node2.y);
       }
   }
   
}
