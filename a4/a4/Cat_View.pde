class Cat_View {
  Data data;
  Cat_Bar[] graphs;
  int num_graphs;
  
  int xl, yt;
  int canvas_w, canvas_h;
  
  Cat_View(Data parsed) {
    num_graphs = 3;
    views = new Cat_Bar[num_graphs];
    data = parsed;
    
    for(int i = 0; i < 3; i++) {
      views[i] = new Cat_Bar(data.events[5 + i], data.header[5 + i]);
  }
  
  void draw_cat_view(int x1, int x2, int y1, int y2) {
    xl = x1;
    yt = y1;
    canvas_w = x2 - x1;
    canvas_h = y2 - y1;
    
    
  }
  
  
  
  
  
}

