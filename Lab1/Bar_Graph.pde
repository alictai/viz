class Bar_Graph {
  boolean visible;  
  Data data;
  String x_axis;
  String y_axis;
  int y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  float[] x_coords;
  float[] y_coords;
  int interval;
  float x_spacing;
  int num_intervals;
  int isect;
  int shown_intervals;

  Bar_Graph(Data parsed) {
    data = parsed;
    y_max = max(data.value);
    num_points = data.name.length;
    interval = 5;
    num_intervals = 0;
    isect = -1;
  }
  
  void draw_graph() {
    make_canvas(); 
    draw_axes();
    draw_axes_titles();
    draw_bars();
  }
    
  void make_canvas() {
    canvas_y1 = 40;
    canvas_y2 = height - 90;
    canvas_x1 = 60;
    canvas_x2 = width - 60;
    
    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
  }
  
  void draw_axes() {
    fill(255, 255, 255);
    line(canvas_x1, canvas_y2, canvas_x2, canvas_y2);
    line(canvas_x1, canvas_y1, canvas_x1, canvas_y2);
    
    //Draw y axis
    num_intervals = (y_max / interval) + 1;
    shown_intervals = num_intervals/10;
    for (int i = 0; i <= num_intervals; i += 1) {
        float pos_y = canvas_y2 - (i * (float(canvas_h)/float(num_intervals)));
        float pos_x = canvas_x1 - 15;
        
        if (shown_intervals == 0) {
          fill(0,0,0);
          textSize(10);
          text(i*interval, pos_x, pos_y);
          shown_intervals = num_intervals/10;
        } else {
           shown_intervals--;
        }
        /*fill(0,0,0);
        textSize(10);
        text(i*interval, pos_x, pos_y);*/
    }    
    
    
    //Draw x axis
    x_coords = new float[0];
    x_spacing = canvas_w/num_points;
    
    for (int i = 0; i < num_points; i += 1) {
        float pos_x = (i*x_spacing) + (x_spacing/2) + canvas_x1;
        float pos_y = canvas_y2 + 10;
        
        x_coords = append(x_coords, pos_x + 10); 
        
        translate(pos_x + 10, pos_y);
        rotate(PI/2);
        
        fill(0,0,0);
        textAlign(LEFT, CENTER);
        textSize(10);
        text(data.name[i], 0, 0);        
        //translate(0, canvas_w/num_points);
        
        rotate(-PI/2);
        translate(-pos_x - 10, -pos_y);
    }
  }
  
  void draw_axes_titles() {
    textSize(15);
    textAlign(CENTER, CENTER);
    
    //x axis header
    text(data.header[0], width/2, height - 15);
    
    //y axis header
    translate(15, height/2);
    rotate(-PI/2);
    text(data.header[1], 0, 0); 
    rotate(PI/2);
    translate(-15, -height/2);
    
    textAlign(BASELINE);
  }
  
  void draw_bars() {
        y_coords = new float[0];
        float max_height = num_intervals*interval;
        
        for (int i = 0; i < data.name.length; i++) {
            float ratio = data.value[i]/max_height;
            y_coords = append(y_coords, (float(canvas_h)-(float(canvas_h)*ratio))+canvas_y1);
            if (i == isect) {
              fill(0, 0, 255);
              rect(x_coords[i]-(x_spacing/4), y_coords[i], x_spacing/2, canvas_y2 - y_coords[i]);
              textSize(10);
              textAlign(CENTER, CENTER);
              text("(" + data.name[i] + ", " + data.value[i] + ")", x_coords[i], y_coords[i] - 10);
              textAlign(BASELINE);
            } else {
              fill(200, 255, 200);
              rect(x_coords[i]-(x_spacing/4), y_coords[i], x_spacing/2, canvas_y2 - y_coords[i]);
            }
            
        }
  }
  
  void bar_intersect(int mousex, int mousey) {
        boolean intersection = false;
        
        for (int i = 0; i < data.name.length; i++) {
            float x1 = x_coords[i]-(x_spacing/4);
            float x2 = x1 + x_spacing/2;
            float y1 = y_coords[i];
            float y2 = canvas_y2;
            
            if (mousex < x2 && mousex > x1) {
              if (mousey < y2 && mousey > y1) {
                  isect = i;
                  intersection = true;
              }
            }
        }
        
        if (intersection == false) {
          isect = -1;
        }
  }
}

