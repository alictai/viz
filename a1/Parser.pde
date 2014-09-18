class Parser {
  Leaf[] leaves;
  Rels[] relations;
  
  void parse(String file) {
       //int i = 0;
       String[] lines = loadStrings(file);
       String[] split_line;
       
       leaves = find_leaves(lines);
       relations = find_rels(lines, leaves.length + 1);
       
       
      

       printall();
       //Canvas to_return = new Canvas();
  }
  
    
    Leaf[] find_leaves(String[] lines) {
      String[] split_line;
      Leaf[] leaves = new Leaf[int(lines[0])];
     
      for(int i = 1; i <= int(lines[0]); i++) {
           leaves[i-1] = new Leaf();
           split_line = splitTokens(lines[i], " ");
           leaves[i-1].id = int(split_line[0]);
           leaves[i-1].value = int(split_line[1]);
       }
       
       return leaves;
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
         relations[j].is_linked = false;
         j++;
       }
       
       return relations;
    }
   
   void assign_rels () {
      for (int i = 0; i < relations.length; i++) {
         if (!relations[i].is_linked) {
            set_links(relations[i].child) 
         }
      } 
   }
   
   //setlinks() - recursive function that takes in the child's id, and returns the newly created child
   // with all its children in place
   //  base case: either goes through rel array and doesn't find anything
   //             or finds id in leaf array
   
   Canvas set_links(int id) {
     //base case == isleaf
     if (rval.children.length == 0) {
         // search through leaf array, assign value to leaf 
      }
      //recursive case == has child
      else {
        
      }
     
      Canvas rval = Canvas.create(id);
      for (int i = 0; i < rels.length; i++) {
         if (rels[i].parent == id) {
            rval.children = append(rval.children, set_links(rels[i].child));
         }
      }
      
      //checking if it is leaf
      
      
      
      return rval;

   }
    
  void printall() {
       print("Leaves:\n");
       for (int j = 0; j < leaves.length; j++) {
           print(leaves[j].id);
           print("\n");
       }
       
       print("Values:\n");
       for(int j = 0; j < leaves.length; j++) {
           print(leaves[j].value);
           print("\n");
       }
       
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
        
}
