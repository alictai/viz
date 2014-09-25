class Bar_Graph {
  p;
  data;
  boolean visible;  
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

  Bar_Graph(d_input, processing_instance) {
    p = processing_instance;
    data = d_input;
    y_max = p.max(data.Rating);
    num_points = data.Season.length;
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
    canvas_y2 = p.height - 90;
    canvas_x1 = 60;
    canvas_x2 = p.width - 60;
    
    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
  }
  
  void draw_axes() {
    p.fill(255, 255, 255);
    p.line(canvas_x1, canvas_y2, canvas_x2, canvas_y2);
    p.line(canvas_x1, canvas_y1, canvas_x1, canvas_y2);
    
    //Draw y axis
    num_intervals = (y_max / interval) + 1;
    shown_intervals = num_intervals/10;
    for (i = 0; i <= num_intervals; i += 1) {
        pos_y = canvas_y2 - (i * (p.float(canvas_h)/p.float(num_intervals)));
        pos_x = canvas_x1 - 15;
        
        if (shown_intervals == 0) {
          p.fill(0,0,0);
          p.textSize(10);
          p.text(i*interval, pos_x, pos_y);
          shown_intervals = num_intervals/10;
        } else {
           shown_intervals--;
        }
    }    
    
    
    //Draw x axis
    x_coords = new float[0];
    x_spacing = canvas_w/num_points;
    
    for (i = 0; i < num_points; i += 1) {
        pos_x = (i*x_spacing) + (x_spacing/2) + canvas_x1;
        pos_y = canvas_y2 + 10;
        
        x_coords = p.append(x_coords, pos_x + 10); 
        
        p.translate(pos_x + 10, pos_y);
        p.rotate(PI/2);
        
        p.fill(0,0,0);
        p.textAlign(LEFT, CENTER);
        p.textSize(10);
        p.text(data.Title[i], 0, 0);        
        
        p.rotate(-PI/2);
        p.translate(-pos_x - 10, -pos_y);
    }
  }
  
  void draw_axes_titles() {
    p.textSize(15);
    p.textAlign(CENTER, CENTER);
    
    //x axis header
    p.text("Title of Episode", width/2, height - 15);
    
    //y axis header
    p.translate(15, height/2);
    p.rotate(-PI/2);
    p.text("Rating", 0, 0); 
    p.rotate(PI/2);
    p.translate(-15, -height/2);
    
    p.textAlign(BASELINE);
  }
  
  void draw_bars() {
        y_coords = new float[0];
        max_height = num_intervals*interval;
        
        for (i = 0; i < data.Title.length; i++) {
            ratio = data.Rating[i]/max_height;
            y_coords = p.append(y_coords, (p.float(canvas_h)-(p.float(canvas_h)*ratio))+canvas_y1);
            if (i == isect) {
              p.fill(0, 0, 255);
              p.rect(x_coords[i]-(x_spacing/4), y_coords[i], x_spacing/2, canvas_y2 - y_coords[i]);
              p.textSize(10);
              p.textAlign(CENTER, CENTER);
              p.text("(" + data.Title[i] + ", " + data.Rating[i] + ")", x_coords[i], y_coords[i] - 10);
              p.textAlign(BASELINE);
            } else {
              p.fill(200, 255, 200);
              p.rect(x_coords[i]-(x_spacing/4), y_coords[i], x_spacing/2, canvas_y2 - y_coords[i]);
            }
            
        }
  }
  
  /*void bar_intersect(mousex, mousey) {
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
  }*/
}
