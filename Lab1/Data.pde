class Data { 
   String[] name;
   int[] value;
   String[] header;
  
   //Modularity: Could've taken in delimeters
   void parse(String file){
      String[] lines = loadStrings(file);
      String[] split_line;
      
      name = new String[lines.length-1];
      value = new int[lines.length-1];
      
      readHeader(lines[0]);
      
      for (int i = 1; i < lines.length; i++) {
        split_line = splitTokens(lines[i], ",");
        name[i-1] = split_line[0];
        value[i-1] = int(split_line[1]);
        
      }
      
      /*print("Names:\n");
      printArray(name);
      print('\n');
      print("Values:\n");
      printArray(value);*/
   }
   
   void readHeader(String line1) {
      header = new String[2];
      
      //given CSV has header delimited by ',' & ' '
      header = splitTokens(line1, ", ");
   }
  
}
