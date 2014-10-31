class Para_Coord {
  Data data;
  float[] mins;
  float[] maxes;
  float[] x_coords;
  float[][] y_coords;
  float[][] label_coords;
  float[][] labels;
  float x, y;
  float w, h;
  float y_top, y_bott;
  int num_labels;

  Para_Coord (Data d) {
    data = d;
    mins = new float[data.get_num_cols()];
    maxes = new float[data.get_num_cols()];
    find_bounds();
    x_coords = new float[data.get_num_cols()];
    y_coords = new float[data.get_num_cols()][data.get_num_rows()];
    num_labels = 5;
    labels = new float[data.get_num_cols()][num_labels];
    label_coords = new float[data.get_num_cols()][num_labels];
  }

  void draw_graph(float x_in, float y_in, float w_in, float h_in) {
    x = x_in;
    y = y_in;
    w = w_in;
    h = h_in;

    calculate_axes();
    calc_pts();
    calc_labels();

    draw_axes();
    draw_lines();
    draw_pts();
    draw_labels();
  }

  void find_bounds() {
    for (int i = 0; i < data.get_num_cols (); i++) {
      mins[i] = min(data.vals[i]);
      maxes[i] = max(data.vals[i]);
    }
  }

  void calculate_axes() {
    float x_spacing = w/(data.get_num_cols()+1);
    for (int i = 0; i < x_coords.length; i++) {
      x_coords[i] = x_spacing * (i+1);
    }

    y_top = y + 20;
    y_bott = y + h - 60;
  }

  void calc_pts() {
    for (int i = 0; i < data.get_num_cols (); i++) {
      for (int k = 0; k < data.get_num_rows (); k++) {
        //y_coords[i][k] = map(data.vals[i][k], maxes[i], mins[i], y_bott, y_top);
        y_coords[i][k] = map(data.vals[i][k], mins[i], maxes[i], y_bott, y_top);
      }
    }
  }

  void calc_labels() {
    for (int i = 0; i < data.get_num_cols (); i++) {
      for (int k = 0; k < num_labels; k++) {
        float label = ((maxes[i] - mins[i])/num_labels)*k;
        //print(label, '\n');
        //label_coords[i][k] = map(label, maxes[i], mins[i], y_bott, y_top);
        labels[i][k] = label;
        label_coords[i][k] = map(label, mins[i], maxes[i], y_bott, y_top);
      }
      println(label_coords[i]);
    }
  }

  void draw_axes() {
    for (int i = 0; i < x_coords.length; i++) {
      fill(0, 0, 0);
      line(x_coords[i], y_top, x_coords[i], y_bott);
      textSize(15);
      textAlign(CENTER);
      text(data.get_header(i), x_coords[i], y_bott + 20);
    }
  }

  void draw_pts() {
    for (int i = 0; i < data.get_num_cols (); i++) {
      for (int k = 0; k < data.get_num_rows (); k++) {
        fill(0, 0, 0);
        ellipse(x_coords[i], y_coords[i][k], 5, 5);
      }
    }
  }

  void draw_lines() {
    for (int i = 0; i < (data.get_num_rows ()); i++) {
      for (int k = 0; k < data.get_num_cols () - 1; k++) {
        //coloring is temporary
        stroke(0,255,0);
        line(x_coords[k], y_coords[k][i], x_coords[k+1], y_coords[k+1][i]);
        stroke(0,0,0);
      }
    }
  }

  void draw_labels() {
    for (int i = 0; i < data.get_num_cols (); i++) {
      for (int k = 1; k < num_labels; k++) {
        fill(0, 0, 0);
        textSize(10);
        textAlign(RIGHT, CENTER);
        float len = y_bott - y_top;
        text(labels[i][k], x_coords[i]-5, y_bott - ((len*k)/num_labels));
      }
    }
  }
}

