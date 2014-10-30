class Para_Coord {
  Data data;
  float[] mins;
  float[] maxes;
  float[] x_coords;
  float[][] y_coords;
  float x, y;
  float w, h;
  float y_top, y_bott;

  Para_Coord (Data d) {
    data = d;
    mins = new float[data.get_num_cols()];
    maxes = new float[data.get_num_cols()];
    find_bounds();
    x_coords = new float[data.get_num_cols()];
    y_coords = new float[data.get_num_cols()][data.get_num_rows()];
  }

  void draw_graph(float x_in, float y_in, float w_in, float h_in) {
    x = x_in;
    y = y_in;
    w = w_in;
    h = h_in;
    
    calculate_axes();
    calc_pts();
    
    draw_axes();
    //draw_pts();
    //draw_lines();
    
    //draw_labels
  }

  void find_bounds() {
    for (int i = 0; i < data.get_num_cols (); i++) {
      mins[i] = min(data.vals[i]);
      maxes[i] = max(data.vals[i]);
    }
  }

  void calculate_axes() {
    float x_spacing = w/(data.get_num_cols()+1);
    for(int i = 0; i < x_coords.length; i++) {
        x_coords[i] = x_spacing * (i+1);
    }
    
    y_top = y + 20;
    y_bott = y + h - 60; 
    
    
  }
  
  void calc_pts() {
     for (int i = 0; i < data.get_num_cols(); i++) {
        for (int k = 0; k < data.get_num_rows(); k++) {
           y_coords[i][k] = map(data.vals[i][k], maxes[i], mins[i], y_bott, y_top);
           ellipse(x_coords[i], y_coords[i][k], 10, 10);
        }
     } 
  }
  
  void draw_axes() {
     for (int i = 0; i < x_coords.length; i++) {
        line(x_coords[i], y_top, x_coords[i], y_bott);
     } 
  }
}

