class Canvas {
   boolean is_leaf = true;
   int id;
   int wid, hgt;
   int xl, xr, yt, yb;   //x-left, x-right, y-top, y-bottom
   int total_value = -1;
   Canvas[] children;
   
   Canvas(int id_num, int val, boolean leaf) {
       id = id_num;
       total_value = val;
       is_leaf = leaf;
       children = new Canvas[0];
   }
   
   void sort_children() {
       Canvas temp;
       for(int cur_pos = 1; cur_pos < children.length; cur_pos++) {
         for(int i = cur_pos; i >= 0; i--) {
          if(children[cur_pos].total_value > children[cur_pos - 1].total_value) {
           //swap
           temp = children[i];
           children[i] = children[i-1];
           children[i-1] = temp;
          }
          else {
            break; 
          }
         } 
       }
       
   }
 
   /*
   void parse(String file) {
       int i = 0;
       String[] lines = loadStrings(file);
       String[] split_line;
       //Leaf[] leaves;
       
       for(i = 1; i < int(lines[0]); i++) {
           leaves = splitTokens(lines[i], " ");
   }
   */
}


