class Parser {
  Leaf[] leaves;
  Rels[] relations;
  
  void parse(String file) {
       int i = 0;
       String[] lines = loadStrings(file);
       String[] split_line;
       
       leaves = new Leaf[int(lines[0])];
       //
       //TO BE TURNED INTO HELPER FUNCTION
       //
       for(i = 1; i <= int(lines[0]); i++) {
           leaves[i-1] = new Leaf();
           split_line = splitTokens(lines[i], " ");
           leaves[i-1].id = int(split_line[0]);
           leaves[i-1].value = int(split_line[1]);
       }
       
       //after reading in leaves, i should be at line w/ # of rels
       //relations = new Rels[int(lines[i++])];
       relations = find_rels(lines, i);

       //Canvas to_return = new Canvas();
       
       
       print("Parents:\n");
       for (int j = 0; j < relations.length; j++) {
           print(relations[j].parent);
           print("\n");
       }
       
       print("Kiddies:\n");
       for(int j = 0; j < relations.length; j++) {
           print(relations[j].child);
           print("\n");
       }
       
       
       
    }
    
    Rels[] find_rels(String[] lines, int f_place) {       
      String[] split_line;
      int j = 0;  
      Rels[] relations = new Rels[int(lines[f_place++])];
        
      for(; f_place < lines.length; f_place++) {
         relations[j] = new Rels();
         split_line = splitTokens(lines[f_place], " ");
         relations[j].parent = int(split_line[0]);
         relations[j].child  = int(split_line[1]);
         j++;
       }
       
       return relations;
    }
        
}
