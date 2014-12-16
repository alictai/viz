class Display {
  //data for visualizations
  UserData data;      //contains an array of AgeGroups for m & f
  
  //list of visualizations, may be active or nah
  Cloud    cloud; 
  ParGraph par_graph;
  PieControl pies;
  /* more to be added */
  
  int[] word_freqs;

  Display(WordCram wc, UserData d) {
    data = d;
    cloud = new Cloud(wc, data);
    pies = new PieControl(data);
    par_graph = new ParGraph(data);
  }
  
  //returns true if frequencies change
  void get_freqs(Range range) {
      //word_freqs = cloud.get_freqs(range, range.gender);
      //return cloud.freq_changed();
      par_graph.draw_graph(0, 0, width, height-100, range, range.gender);
  }

  // pass gender from Musicvis
  void draw_graphs(WordCram wc, Range range) {
      String gender = "both";
      //cloud.set_weights(wc, word_freqs);
      //cloud.draw_cloud(range);
      //pies.draw_pies(range, gender);
      par_graph.draw_graph(0, 0, width, height-100, range, range.gender);
      
  }
  
  void set_click() {
      pies.check_click();
      //cloud.check_click();
  }
  
 
}
