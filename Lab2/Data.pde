class Data { 
   int[] season;
   int[] episode;
   String[] title;
   int[] rating;
   int[] votes;
   String[] header;
  
   //Modularity: Could've taken in delimeters
   void parse(String file){
      String[] lines = loadStrings(file);
      String[] split_line;
      int num_lines = lines.length-1;
      
      season = new int[num_lines];
      episode = new int[num_lines];
      title = new String[num_lines];
      rating = new int[num_lines];
      votes = new int[num_lines];
      
      readHeader(lines[0]);
      
      for (int i = 1; i < lines.length; i++) {
        split_line = splitTokens(lines[i], ",");
        season[i-1] = int(split_line[0]);
        episode[i-1] = int(split_line[1]);
        title[i-1] = split_line[2];
        rating[i-1] = int(split_line[3]);
        votes[i-1] = int(split_line[4]);
      }
      
      /*print("Names:\n");
      printArray(name);
      print('\n');
      print("Values:\n");
      printArray(value);*/
   }
   
   void readHeader(String line1) {
      header = new String[5];
      
      //given CSV has header delimited by ',' & ' '
      header = splitTokens(line1, ",");
      print("Headers: \n");
      printArray(header);
      print('\n');
   }
  
}
