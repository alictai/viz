class Display {
  //data for visualizations
  UserData data;      //contains an array of AgeGroups for m & f
  
  //list of visualizations, may be active or nah
  Cloud    cloud; 
  //ParGraph par_graph;
  /* more to be added */

  Display(WordCram wc, UserData d) {
    data = d;
    cloud = new Cloud(wc, data);
    //par_graph = new ParGraph(data);
  }

  void draw_graphs(WordCram wc, Range range) {
      cloud.set_weights(wc, range, "female");
      cloud.draw_cloud();
  }
  
  
}
