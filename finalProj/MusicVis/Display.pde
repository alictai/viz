class Display {
  //data for visualizations
  UserData data;      //contains an array of AgeGroups for m & f
  
  //list of visualizations, may be active or nah
  Cloud    cloud; 
  //ParGraph par_graph;
  /* more to be added */
  
  int[] word_freqs;

  Display(WordCram wc, UserData d) {
    data = d;
    cloud = new Cloud(wc, data);
    //par_graph = new ParGraph(data);
  }
  
  //returns true if frequencies change
  void get_freqs(Range range) {
      word_freqs = cloud.get_freqs(range, "female");
      //return cloud.freq_changed();
  }

  void draw_graphs(WordCram wc, Range range) {
      cloud.set_weights(wc, word_freqs);
      cloud.draw_cloud();
      
  }
  
  void set_click() {
      cloud.check_click();
  }
  
 
}
