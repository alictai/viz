class Bar_Graph {
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
  float interval;
  float x_spacing;
  int num_intervals;
  int isect;
  int shown_intervals;
  
  //variables for transition
  int phase;
  float[] dum_y;
  float dum_width; //width correlates to xspacing/2, 

  Bar_Graph(Data parsed) {
    data = parsed;
    y_max = max(data.values[0]);
    num_points = data.name.length;
    interval = 5;
    num_intervals = 0;
    isect = -1;
    phase = 0;
  }
  
  void draw_graph() {
    make_canvas(); 
    draw_axes();
    draw_axes_titles();
    get_y_coords();
    //draw_bars();
    draw_bars(x_coords, y_coords, x_spacing/2);
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
    line(canvas_x1, canvas_y1, canvas_x1, canvas_y2);
    
    //Draw y axis
    num_intervals = int((y_max / interval) + 1);
    shown_intervals = num_intervals/10;
    for (int i = 0; i <= num_intervals; i += 1) {
        float pos_y = canvas_y2 - (i * (canvas_h/num_intervals));        
        float pos_x = canvas_x1 - 15;
        
        if (shown_intervals == 0) {
          fill(0,0,0);
          textSize(10);
          text(int(i*interval), pos_x, pos_y);
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
    text(data.header[0], width/2, height - 70);
    
    //y axis header
    translate(15, height/2);
    rotate(-PI/2);
    text(data.header[1], 0, 0); 
    rotate(PI/2);
    translate(-15, -height/2);
    
    textAlign(BASELINE);
  }
  
  void get_y_coords() {
      y_coords = new float[0];
      float max_height = num_intervals*interval;
        
      for (int i = 0; i < data.name.length; i++) {
          float ratio = data.values[0][i]/max_height;
          y_coords = append(y_coords, (float(canvas_h)-(float(canvas_h)*ratio))+canvas_y1);
      }
    
  }
  
  void draw_bars(float[] x, float[] y, float w) {
        float h = 0;
        //print("in draw bars, dum width: ", w, "\ngoal: ", x_spacing/2, "\n");
        for (int i = 0; i < data.name.length; i++) {
              if (phase == 0) {
                  h = canvas_y2 - y[i];
              } else if (phase == 1) {
                  h = 1;
              } else {
                  h = dum_y[i];
              }
              fill(200, 255, 200);
              // rect(x_coords[i]-(x_spacing/4), y_coords[i], x_spacing/2, canvas_y2 - y_coords[i]);
              rect(x[i]-(w/4), y[i], w, h);   
        }
  }
  
  boolean line_to_bar() {  
    make_canvas(); 
    draw_axes();
    draw_axes_titles();
    get_y_coords();
    
    if (phase == 0) {
        phase += set_dummy();
    } else if (phase == 1) {
        print("expanding points\n");
        phase += expand_point();
    } else if (phase == 2) {
        print("filling bar\n");
        phase += fill_bar();
    } else {
        phase = 0;
        return false;
    }

    draw_bars(x_coords, y_coords, dum_width);
    
    return true;
  }
  
  int set_dummy() {
    dum_y = new float[num_points];
    
    for (int i = 0; i < num_points; i++) {
      dum_y[i] = y_coords[i];
    }
   
    dum_width = 0;
    return 1;
  }
  
  int expand_point() {
    dum_width = lerp(dum_width, (x_spacing/2), .05);
    if(dum_width > x_spacing/2 - .1) {
        return 1;
    } else {
        return 0;
    }
  }
  
  int fill_bar() {
    for(int i = 0; i < num_points; i++) {
      dum_y[i] = lerp(dum_y[i], canvas_y2 - y_coords[i], .1);
    }
    
    boolean all_same = true;
    for(int i = 0; i < num_points; i++) {
      if((int)dum_y[i] != (int)(canvas_y2 - y_coords[i])) {
           all_same = false;
      }
    }
     
     if(all_same) {
       return 1;
     } else {
       return 0;
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

