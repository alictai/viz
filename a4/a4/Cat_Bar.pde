class Cat_Bar {
  String title;
  String[] data;

  int xl, xr;
  int yt, yb;
  int wid, hgt;
  int num_points;

  Cat_Bar(String[] parsed, String cat) {
    data = parsed;
    title = cat;
    num_points = data.length;
  }

  void draw_graph(int xl, int xr, int yt, int yb) {
    make_canvas(xl, xr, yt, yb); 
    draw_bars();
  }

  void make_canvas(int _xt, int _xb, int _yl, int _yr) {
    yt = _yt;
    yb = _yb;
    xl = _xl;
    xr = _xr;

    wid = xr - xl;
    hgt = yb - yt;
  }


  void draw_bars(float w) {
    int 


/*
    float tot_h = 0;
    float h_ratio = 0;
    float curr_y = canvas_y2;
    y_coords = new float[num_points][data.num_cols];
    //print("in draw bars, dum width: ", w, "\ngoal: ", x_spacing/2, "\n");
    for (int i = 0; i < data.name.length; i++) {
      curr_y = canvas_y2;
      tot_h = canvas_y2 - max_y_coords[i];
      for (int j = 0; j < data.num_cols-1; j++) {
        float fill_clr = map(j, 0, data.num_cols, 0, 255);
        h_ratio = data.values[j][i]/data.row_totals[i];
        curr_y -= tot_h*h_ratio;

        fill(150, fill_clr, 150);
        // rect(x_coords[i]-(x_spacing/4), y_coords[i], x_spacing/2, canvas_y2 - y_coords[i]);
        rect(x_coords[i]-(w/4), curr_y, w, tot_h*h_ratio); 
        y_coords[i][j] = curr_y;
      }
    }
  }
  */
}

