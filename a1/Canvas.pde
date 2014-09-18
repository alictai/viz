class Canvas {
   boolean is_leaf = true;
   int id;
   int wid, hgt;
   int xl, xr, yt, yb;   //x-left, x-right, y-top, y-bottom
   int total_value = -1;
   Canvas[] children;
   
   Canvas create(int id) {
       Canvas temp = new Canvas;
       temp.id = id;
       temp.children = new Canvas[0];
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


