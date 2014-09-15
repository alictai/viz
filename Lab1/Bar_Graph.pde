class Bar_Graph {
  boolean visible;
  Data data;
  String x_axis;
  String y_axis;
  int x_max;
  int y_max;
  int num_bars;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;

  Bar_Graph(Data parsed) {
    data = parsed;
  }

  void draw_graph() {
    make_canvas();

    //print(data.name[0]);
  }

  void make_canvas() {
    canvas_y1 = 40;
    canvas_y2 = height - 60;
    canvas_x1 = 60;
    canvas_x2 = width - 10;
    
    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
    
    fill(255, 255, 255);
    rect(canvas_x1, canvas_y1, canvas_w, canvas_h);
  }

  void draw_axes() {
  }

  void draw_bars() {
  }
}

