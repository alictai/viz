class Display {
  //data for visualizations
  UserData ud;      //contains an array of AgeGroups for m & f
  
  //list of visualizations, may be active or nah
  Cloud    cloud; 
  ParGraph par_graph;
  /* more to be added */


  Display() {
    ud = new UserData();
    cloud = new Cloud();
    par_graph = new ParGraph();
  }

  
}
