class Data { 
   String[] header;
   int num_cols;
   Event[] events;
   
   //Modularity: Could've taken in delimeters
   void parse(String file){
      String[] lines = loadStrings(file);
      String[] split_line;
      
      readHeader(lines[0]);
      
      events = new Event[lines.length - 1];
      for (int i = 1; i < lines.length; i++) {
         split_line = splitTokens(lines[i], ",");
         events[i - 1] = new Event(split_line[0], split_line[1], split_line[2], 
                                   split_line[3], split_line[4], split_line[5], 
                                   split_line[6], split_line[7]); 
      }
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
