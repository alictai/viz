/*
class Scatterplot {  
  Data data;
  String x_axis;
  String y_axis;
  float y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  float[] x_coords;
  float[] y_coords;
  float y_interval;
  int num_intervals;
  int isect;
  int shown_intervals;

  Scatterplot(Data parsed, int canvas_dim) {
    canvas_x1 = 0;
    canvas_y1 = 0;
    canvas_w = canvas_dim;
    canvas_h = canvas_dim;
    canvas_x2 = canvas_x1 + canvas_w;
    canvas_y2 = canvas_x1 + canvas_h;
    data = parsed;
    y_max = max(data.values[0]);
    num_points = data.name.length;
    y_interval = 5;
    num_intervals = 0;
  }

  void draw_graph() {
    calc_y_interval();
    draw_axes(canvas_x2, canvas_y2, canvas_x1, canvas_y2);

    draw_axes_titles();
    draw_line(x_coords, y_coords, x_coords, y_coords);
    draw_points(radius);
  }

  void calc_y_interval() {
    num_intervals = int((y_max / y_interval) + 1);
    shown_intervals = num_intervals/10;
  }

  void draw_axes(float x_x, float x_y, float y_x, float y_y) {
    fill(255, 255, 255);
    line(canvas_x1, canvas_y1, y_x, y_y); // y axis
    line(canvas_x1, canvas_y2, x_x, x_y); // x axis
  }

  void draw_axes_labels(color c) {    
    //Draw y axis
    for (int i = 0; i <= num_intervals; i += 1) {
      float pos_y = canvas_y2 - (i * (canvas_h/num_intervals));
      float pos_x = canvas_x1 - 15;

      if (shown_intervals == 0) {
        fill(c);
        textSize(10);
        text(int(i*y_interval), pos_x, pos_y);
        shown_intervals = num_intervals/10;
      } else {
        shown_intervals--;
      }
    }    

    //Draw x axis labels
    update_x();
    for (int i = 0; i < num_points; i += 1) {
      float pos_x = x_coords[i];
      float pos_y = canvas_y2 + 10;
      translate(pos_x, pos_y);
      rotate(PI/2);

      fill(c);
      textAlign(LEFT, RIGHT);
      textSize(10);
      text(data.name[i], 0, 0);        

      rotate(-PI/2);
      translate(-pos_x, -pos_y);
    }
  }

  void draw_axes_titles() {
    textSize(15);
    textAlign(CENTER, CENTER);

    //x axis header
    text(data.header[0], width/2, height - 70);

    //y axis header
    translate(15, height/2);
    rotate(-PI/2);
    text(data.header[1], 0, 0); 
    rotate(PI/2);
    translate(-15, -height/2);

    textAlign(BASELINE);
  }

  void draw_points(float r) {
    update_y();

    for (int i = 0; i < data.name.length; i++) {
      if (i == isect) {
        fill(255, 0, 0);
        ellipse(x_coords[i], y_coords[i], r, r);
        textSize(10);
        text("(" + data.name[i] + ", " + data.values[0][i] + ")", x_coords[i] + 8, y_coords[i] + 8);
      } else {
        float gray = map(i, 0, data.name.length, 0, 255);
        fill(150, gray, 150);
        ellipse(x_coords[i], y_coords[i], r, r);
    }
  }
  
  void draw_line(float[] x1, float[] y1, float[] x2, float[] y2) {
    for (int i = 0; i < (data.name.length - 1); i++) {
      line(x1[i], y1[i], x2[i+1], y2[i+1]);
    }
  }
  
}
*/
