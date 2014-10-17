class Parser {
  Node[] nodes;
  Rels[] relations;
  Graph graph;
  int f_place;
  int ult_root;
  
 Graph parse(String file) {
       String[] lines = loadStrings(file);
       String[] split_line;
       graph = new Graph();
       
       find_nodes(lines);
       find_rels(lines);
       attach_nodes();
       
       print_rels();
       
       graph.nodes = nodes;
       graph.relations = relations;
       
       return graph;
  }
  
    
    void find_nodes(String[] lines) {
      String[] split_line;
      split_line = splitTokens(lines[0], ",");
      int num_nodes = int(split_line[0]);
      nodes = new Node[num_nodes];

      for(f_place = 1; f_place <= num_nodes; f_place++) {
           nodes[f_place-1] = new Node();
           split_line = splitTokens(lines[f_place], ",");
           nodes[f_place-1].id = int(split_line[0]);
           nodes[f_place-1].mass = float(split_line[1]);
       }

    }
    
    void find_rels(String[] lines) { 
      String[] split_line;
      split_line = splitTokens(lines[f_place++], ",");
      int num_rels = int(split_line[0]);     
      int j = 0;  
      relations = new Rels[num_rels];

      for(; f_place < lines.length; f_place++) {
         relations[j] = new Rels();
         split_line = splitTokens(lines[f_place], ",");
         relations[j].parent = int(split_line[0]);
         relations[j].child  = int(split_line[1]);
         relations[j].edge = float(split_line[2]);
         j++;
       }
    }
    
    void attach_nodes() {
       for (int i = 0; i < relations.length; i++) {
          for (int j = 0; j < nodes.length; j++) {
             if (relations[i].parent == nodes[j].id) {
                relations[i].node1 = nodes[j];
             }
             if (relations[i].child == nodes[j].id) {
                relations[i].node2 = nodes[j];
             }
          }
       }
    }
    
    void print_rels() {
        for (int i = 0; i < relations.length; i++) {
            print("node1 = ", relations[i].node1.id, "node2 = ", relations[i].node2.id, "spring = ", relations[i].edge, "\n");
        }
    }
    
}
