class Data { 
   String[] header;
   int num_cols;
   String[] name;
   float[][] values;
   float[] row_totals;

  
   //Modularity: Could've taken in delimeters
   void parse(String file){
      String[] lines = loadStrings(file);
      String[] split_line;
      
      readHeader(lines[0]);
      num_cols = header.length - 1;
      
      name = new String[lines.length-1];
      values = new float[lines.length-1][num_cols];
      row_totals = new float[lines.length-1];
      
      for (int i = 1; i < lines.length; i++) {
        split_line = splitTokens(lines[i], ",");
        name[i-1] = split_line[0];
        for (int j = 0; j < num_cols; j++) {
          values[i-1][j] = float(split_line[j+1]);
          row_totals[i-1] += values[i-1][j];
        }   
      }
      /*
      print("Names:\n");
      printArray(name);
      print('\n');
      print("Values:\n");
      for(int i = 0; i < name.length; i++) {
        printArray(row_totals[i]);
        //printArray(values[j]);
      }
      */
   }
   
   void readHeader(String line1) {
      header = new String[8];
      
      //given CSV has header delimited by ',' & ' '
      header = splitTokens(line1, ",");
      /*print("Headers: \n");
      printArray(header);
      print('\n');*/
   }
  
}
