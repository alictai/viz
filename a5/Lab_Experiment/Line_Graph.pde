class Line_Graph {
  boolean visible;  
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
  float radius;
  int display_x, display_y;
  color axes_color;

  //variables for transition
  int phase;
  float[] dum_x;
  float[] dum_y;
  float dum_radius;
  float dum_y_x, dum_y_y;
  float dum_x_x, dum_x_y;
  color dum_color;

  Line_Graph(Data parsed, int c_x1, int c_y1, int c_x2, int c_y2) {
    phase = 0;
    data = parsed;
    find_ymax();
    num_points = data.getLength();
    y_interval = 5;
    num_intervals = 0;
    isect = -1;
    radius = 5;
    axes_color = color(0, 0, 0);
    canvas_x1 = c_x1;
    canvas_y1 = c_y1;
    canvas_x2 = c_x2;
    canvas_y2 = c_y2;
    canvas_h = c_y2 - c_y1;
    canvas_w = c_x2 - c_x1;
  }
  
  void find_ymax() {
    y_max = 0;
    for (int i = 0; i < data.getLength(); i++) {
      if (data.getVal(i) > y_max) {
         y_max = data.getVal(i);
      }
    }
  }

  void draw_graph() {
    calc_y_interval();
    update_x();
    update_y();
    //draw_axes(canvas_x2, canvas_y2, canvas_x1, canvas_y2);
    //draw_axes_labels(axes_color);
    //draw_axes_titles();
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
/*
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
  */
  void update_x() {
      x_coords = new float[0];
      float spacing = canvas_w/num_points;
      for (int i = 0; i < num_points; i += 1) {
        float pos_x = (i*spacing) + (spacing/2) + canvas_x1;
        x_coords = append(x_coords, pos_x + 10); 
      }
  }
/*
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
*/
  void draw_points(float r) {
    update_y();

    for (int i = 0; i < data.getLength(); i++) {
      if(data.isMarked(i)) {
          fill(255, 0, 0);
          stroke(255, 0, 0);
       } else {
          fill(0);
          stroke(0);
       }
     
       ellipse(x_coords[i], y_coords[i], r, r);
       fill(0);
       stroke(255);
    }
    
  }
  
  void update_y() {
      y_coords = new float[0];
      float max_height = num_intervals*y_interval;

      for (int i = 0; i < data.getLength(); i++) {
        float ratio = data.getVal(i)/max_height;
        y_coords = append(y_coords, (float(canvas_h)-(float(canvas_h)*ratio))+canvas_y1);
      }
  }

  void draw_line(float[] x1, float[] y1, float[] x2, float[] y2) {
    for (int i = 0; i < (data.getLength() - 1); i++) {
      line(x1[i], y1[i], x2[i+1], y2[i+1]);
    }
  }
/*
  void update() {
    make_canvas();
    calc_y_interval();
    update_x();
    update_y();
  }

  void point_intersect(int mousex, int mousey) {
    boolean intersection = false;

    for (int i = 0; i < data.name.length; i++) {
      float posx = x_coords[i];
      float posy = y_coords[i];
      float radius = 5;

      float distance = sqrt((mousex - posx) * (mousex - posx) + 
        (mousey - posy) * (mousey - posy));
      if (distance < radius) {
        isect = i;
        intersection = true;
      }
    }

    if (intersection == false) {
      isect = -1;
    }
  }
*/
  float[] get_y() { return y_coords; }
  float[] get_x() { return x_coords; }
}

