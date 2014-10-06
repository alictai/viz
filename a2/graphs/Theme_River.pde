class Theme_River {
  Data data;
  String x_axis;
  String y_axis;
  float y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  float[] x_coords;
  float[][] y_coords;
  float[] max_y_coords;
  float y_interval;
  int num_intervals;
  int isect;
  int shown_intervals;
  float radius;

  Theme_River(Data parsed) {
    //phase = 0;
    data = parsed;
    y_max = max(data.row_totals);
    num_points = data.name.length;
    y_interval = 10;
    num_intervals = 0;
    radius = 3;
  }
  
  void draw_graph() {
    make_canvas(); 
    draw_axes();
    draw_axes_titles();
    get_y_coords();
    //draw_points();
    draw_line();
  }
    
  void make_canvas() {
    canvas_y1 = 40;
    canvas_y2 = height - 120;
    canvas_x1 = 60;
    canvas_x2 = width - 60;
    
    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
  }
  
  void draw_axes() {
    fill(255, 255, 255);
    line(canvas_x1, canvas_y2, canvas_x2, canvas_y2);
    //line(canvas_x1, canvas_y1, canvas_x1, canvas_y2);
    
    //Draw y axis labels
    num_intervals = int((y_max / y_interval) + 1);
    
    x_coords = new float[0];
    float spacing = canvas_w/num_points;
    
    for (int i = 0; i < num_points; i += 1) {
        float pos_x = (i*spacing) + (spacing/2) + canvas_x1;
        float pos_y = canvas_y2 + 10;
        
        x_coords = append(x_coords, pos_x + 10); 
        //fill(200, 200, 200);
        //line(pos_x + 10, canvas_y2, pos_x + 10, canvas_y1);
        
        translate(pos_x + 10, pos_y);
        rotate(PI/2);
        
        fill(0,0,0);
        textAlign(LEFT, CENTER);
        textSize(10);
        text(data.name[i], 0, 0);        
        
        rotate(-PI/2);
        translate(-pos_x - 10, -pos_y);
    }
  }
  
  void draw_axes_titles() {
    textSize(15);
    textAlign(CENTER, CENTER);
    
    //x axis header
    text(data.header[0], width/2, height - 70);
    /*
    //y axis header
    translate(15, height/2);
    rotate(-PI/2);
    text(data.header[1], 0, 0); 
    rotate(PI/2);
    translate(-15, -height/2);
    
    textAlign(BASELINE);
    
    */
  }
  
  void get_y_coords() {
      y_coords = new float[data.name.length][data.num_cols];
      float max_height = num_intervals*y_interval;
      float total_hratio, total_height, bottom_gutter, curr_y, sub_hratio, sub_height;
      print("max_height: ", max_height, "\n");
      
      for (int i = 0; i < data.name.length; i++) {
          total_hratio = data.row_totals[i]/max_height;
          total_height = total_hratio * canvas_h;
          bottom_gutter = (canvas_h - total_height)/2;
          curr_y = canvas_y2 - bottom_gutter;
          print("hratio: ", total_hratio, "\n");
          print("total_height: ", total_height, "\n");
          print("curr_y: ", curr_y, "\n");
          
          for (int j = 0; j < data.num_cols; j++) {
            sub_hratio = data.values[i][j]/data.row_totals[i];
            sub_height = sub_hratio * total_height;
            curr_y = curr_y - sub_height;
            y_coords[i][j] = curr_y;
            print("sub height: ", sub_height, "\n");
          }
        
      }
    
  }
 /*
 void draw_points() {
     for (int i = 0; i < 1; i++) {
       for (int j = 0; j < data.num_cols; j++) {
           ellipse(x_coords[i], y_coords[i][j], radius, radius);
       }
     }
 }
 */
 /* 
  void draw_points(float r) {
        y_coords = new float[data.name.length][data.num_cols];
        float tot_h = 0;
        float h_ratio = 0;
        float curr_y = canvas_y2;
        
        for (int i = 0; i < data.name.length; i++) {
            print("i is: ", i, "\n");
            curr_y = canvas_y2;
            tot_h = canvas_y2 - max_y_coords[i];
          for (int j = 0; j < data.num_cols-1; j++) {
                 h_ratio = data.values[i][j]/data.row_totals[i];
                 curr_y -= tot_h*h_ratio;  
            
            //y_coords = append(y_coords, canvas_y2 - ((canvas_h/(num_intervals*y_interval))*data.value[i]));
            fill(0,0,0);
            ellipse(x_coords[i], curr_y, r, r);
            y_coords[i][j] = curr_y;
          }
        }
  }
  */
  
  void draw_line() {
        print("data length: ", data.name.length, "\n");
        for (int j = 0; j < data.num_cols - 2; j++) {
          fill(j*(255/data.num_cols), j*(255/data.num_cols), 200);
          beginShape();
          curveVertex(canvas_x1 - 25, canvas_y1 + canvas_h/2);
          curveVertex(canvas_x1 - 15, canvas_y1 + canvas_h/2);
          for (int i = 0; i < data.name.length; i++) {
            curveVertex(x_coords[i], y_coords[i][j]);
          }
          
          curveVertex(canvas_x2 + 25, canvas_y1 + canvas_h/2);
          
          for (int i = data.name.length - 1; i >= 0; i--) {
            curveVertex(x_coords[i], y_coords[i][j+1]);
          }
          curveVertex(canvas_x1 - 15, canvas_y1 + canvas_h/2);
          curveVertex(canvas_x1 - 25, canvas_y1 + canvas_h/2);
          endShape();
          
        }
  }
  
}
