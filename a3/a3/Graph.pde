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
     Node n1, n2;
     for (int i = 0; i < relations.length; i++) {
           n1 = lookup(relations[i].node1);
           n2 = lookup(relations[i].node2);
          line(n1.x, n1.y, n2.x, n2.y);
       }
   }
   
   Node lookup(int id) {
       for (int i = 0; i < nodes.length; i++) {
           if (nodes[i].id == id) {
              return nodes[i]; 
           }
       }
       
       return null;
   }
   
}
