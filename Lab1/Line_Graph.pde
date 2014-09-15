//based on headers?

class Line_Graph {
  boolean visible;  
  Data data;
  String x_axis;
  String y_axis;
  int y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  //int[] yaxis_vals;

  Line_Graph(Data parsed) {
    data = parsed;
    y_max = max(data.value);
    num_points = data.name.length;
  }
  
  void draw_graph() {
    make_canvas(); 
    draw_axes();
  }
    
  void make_canvas() {
    canvas_y1 = 40;
    canvas_y2 = height - 90;
    canvas_x1 = 60;
    canvas_x2 = width - 10;
    
    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
  }
  
  void draw_axes() {
    fill(255, 255, 255);
    line(canvas_x1, canvas_y2, canvas_x2, canvas_y2);
    line(canvas_x1, canvas_y1, canvas_x1, canvas_y2);
    
    //Draw y axis
    int num_intervals = (y_max / 5) + 1;
    for (int i = 0; i <= num_intervals; i += 1) {
        float pos_y = canvas_y2 - (i * (canvas_h/num_intervals));
        float pos_x = canvas_x1 - 15;
        fill(0,0,0);
        textSize(10);
        text(i*5, pos_x, pos_y);
    }    
    
    
    //Draw x axis
    for (int i = 0; i < num_points; i += 1) {
        float pos_x = 10 + canvas_x1 + (i * (canvas_w/num_points));
        float pos_y = canvas_y2 + 10;
        
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
  
  void draw_line() {
      
  }
}
