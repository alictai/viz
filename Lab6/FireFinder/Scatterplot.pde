
class Scatterplot {  
  String x_axis;
  String y_axis;
  float x_max, y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  int window_dim;
  float[] xs, ys;
  float[] x_coords;
  float[] y_coords;
  float x_interval, y_interval;
  int num_x_intervals, num_y_intervals;
  int isect;
  int shown_intervals;
  int offset;

  Scatterplot(int win_dim, float[] x_vals, float[] y_vals) {
    print("window dimension = ", win_dim, "\n");
    offset = 30;
    window_dim = win_dim;
    make_canvas();
    xs = x_vals;
    ys = y_vals;
    x_max = 10;
    y_max = 10;
    //if (xs != null) {x_max = max(xs);};
    //if (ys != null) {y_max = max(ys);};
    if (xs != null) {num_points = xs.length;};
    y_interval = 1;
    x_interval = 1;
    num_y_intervals = 10;
    num_x_intervals = 10;
    print("xs: \n");
    printArray(x_vals);
    print("ys: \n");
    printArray(y_vals);
  }
  
  void make_canvas() {
    canvas_y1 = 20;
    canvas_y2 = window_dim - 50;
    canvas_x1 = 60;
    canvas_x2 = window_dim - 60;
    
    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
  }

  void draw_graph() {
    draw_axes();
    draw_axes_titles();
    draw_axes_labels();
    get_x_coords();
    get_y_coords();
    draw_points();
  }

  void draw_axes() {
    stroke(0);
    line(canvas_x1, canvas_y1, canvas_x1, canvas_y2); // y axis
    line(canvas_x1, canvas_y2, canvas_x2, canvas_y2); // x axis
  }

  void draw_axes_labels() {    
    //Draw y axis
    for (int i = 0; i <= num_y_intervals; i += 1) {
      float pos_y = canvas_y2 - (i * (canvas_h/num_y_intervals));
      float pos_x = canvas_x1 - 15;

        fill(0);
        textSize(10);
        text(int(i*y_interval), pos_x, pos_y);
     
    }  
  
    for (int i = 0; i <= num_x_intervals; i += 1) {
      float pos_x = canvas_x1 + (i * (canvas_w/num_y_intervals));
      float pos_y = canvas_y2 + 15;

        fill(0);
        textSize(10);
        text(int(i*y_interval), pos_x, pos_y);
     
    }    

  }

  void get_x_coords() {
      x_coords = new float[0];
      float max_width = num_x_intervals*x_interval;
      
      for (int i = 0; i < num_points; i++) {
        float ratio = xs[i]/x_max;
        x_coords = append(x_coords, ((float(canvas_w)*ratio)+canvas_x1));
      }  
  }

  void get_y_coords() {
      y_coords = new float[0];
      float max_height = num_y_intervals*y_interval;

      for (int i = 0; i < num_points; i++) {
        float ratio = ys[i]/y_max;
        y_coords = append(y_coords, (float(canvas_h)-(float(canvas_h)*ratio))+canvas_y1);
      }  
  }

  void draw_axes_titles() {
    fill(0);
    textSize(15);
    textAlign(CENTER, CENTER);

    //x axis header
    text("X", window_dim/2, canvas_y2 + 30);

    //y axis header
    translate(15, height/2);
    rotate(-PI/2);
    text("Y", 0, 0); 
    rotate(PI/2);
    translate(-15, -height/2);

    textAlign(BASELINE);
  }

  void draw_points() {

    for (int i = 0; i < num_points; i++) {
      /*if (i == isect) {
        fill(255, 0, 0);
        ellipse(x_coords[i], y_coords[i], r, r);
        textSize(10);
        text("(" + data.name[i] + ", " + data.values[0][i] + ")", x_coords[i] + 8, y_coords[i] + 8);
      } else {*/
        //float gray = map(i, 0, data.name.length, 0, 255);
        fill(0);
        ellipse(x_coords[i], y_coords[i], 5, 5);
      
   }
 }
}

