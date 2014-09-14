class Bar_Graph {
  boolean visible;
  Data data;

  Bar_Graph(Data parsed) {
    data = parsed;
  }
  
  void draw_bar() {
    print(data.name[0]);
  }

}
