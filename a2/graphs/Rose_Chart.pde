class Rose_Chart{
  boolean visible;  
  Data data;
  float max_val;
  int num_wedges;
  float angle;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  float[][] radii;
  
  Rose_Chart(Data parsed) {
    //phase = 0;
    data = parsed;
    max_val = max(data.values[0]);
    num_wedges = data.name.length;
    angle = (2 * PI) / num_wedges;
  }
  
  void draw_graph() {
    make_canvas(); 
    calc_radii();
    draw_chart();
  }

  void make_canvas() {
    canvas_y1 = 40;
    canvas_y2 = height - 90;
    canvas_x1 = 60;
    canvas_x2 = width - 60;

    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
  }
  
  
  void calc_radii() {
      radii = new float[data.num_cols][num_wedges];
      float tot_so_far;
      
      for(int i = 0; i < num_wedges; i++) {
          tot_so_far = data.values[0][i];
          radii[0][i] = tot_so_far;
          for(int j = 1; j < data.num_cols; j++) {
              tot_so_far += data.values[j][i];
              radii[j][i] = tot_so_far;
              if (tot_so_far > max_val) {
                  max_val = tot_so_far;
              }
          }
      }  
      print_data();
  }
  
  void print_data() {
    for(int i = 0; i < num_wedges; i++) {
      for(int j = 0; j < data.num_cols; j++) {
        print(j, " ", i, " ", radii[j][i], "\n");
      }
    }
  }
  
  void draw_chart() {
      float curr_angle;
      color fillVal = color(255, 0, 0);
      int top_index = data.num_cols - 1;
      
      for(int i = top_index; i >= 0; i--) {
          curr_angle = 0;
          fill(fillVal);
          for(int j = 0; j < num_wedges; j++) {
              print("here ", radii[i][j], "\n");
              arc(width/2, height/2, radii[i][j], radii[i][j], curr_angle, curr_angle + angle);
              curr_angle += angle;
          }
          fillVal = color(0, 0, 255);
      }
  }

  
  
  
  
  
}
