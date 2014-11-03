class Cat_Bar {
  String title;
  Event[] data_big;
  String[] data;

  float xl, xr;
  float yt, yb;
  float wid, hgt;
  int num_points;
  int index_key;

  Cat_Bar(Event[] parsed, String category, int _key) {
    data_big = parsed;
    title = category;
    num_points = data_big.length;
    data = new String[num_points];
    index_key = _key;
    extract_data();
  }
  
  void extract_data() {
    switch(index_key) {
      case 5: //Syslog priority
        for(int i = 0; i < num_points; i++) {
          data[i] = data_big[i].priority;
        }
        break;
      case 6: //Operation
        for(int i = 0; i < num_points; i++) {
          data[i] = data_big[i].operation;
        }
        break;
      case 7: //Protocol
        for(int i = 0; i < num_points; i++) {
          data[i] = data_big[i].protocol;
        }
        break;
      default:
        print("ERROR: Data headings not in expected format");
    }
    
    
  }

  void draw_graph(float xl, float xr, float yt, float yb) {
    make_canvas(xl, xr, yt, yb); 
    draw_bars();
  }

  void make_canvas(float _xl, float _xr, float _yt, float _yb) {
    yt = _yt;
    yb = _yb;
    xl = _xl;
    xr = _xr;

    wid = xr - xl;
    hgt = yb - yt;
  }

  void print_data() {
    print(title, '\n');
    printArray(data);
  }


  void draw_bars() {
    rect(xl, yt, wid, hgt);
  }
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

