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
  
  //variables for transition
  int phase;
  float[] dum_x;
  float[] dum_y;
  float dum_radius;

  Line_Graph(Data parsed) {
    phase = 0;
    data = parsed;
    y_max = max(data.values[0]);
    num_points = data.name.length;
    y_interval = 5;
    num_intervals = 0;
    isect = -1;
    radius = 10;
  }
  
  void draw_graph() {
    make_canvas(); 
    draw_axes();
    draw_axes_titles();
    draw_points(radius);
    draw_line(x_coords, y_coords, x_coords, y_coords);
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
    
    //Draw y axis labels
    num_intervals = int((y_max / y_interval) + 1);
    shown_intervals = num_intervals/10;
    for (int i = 0; i <= num_intervals; i += 1) {
        float pos_y = canvas_y2 - (i * (canvas_h/num_intervals));
        float pos_x = canvas_x1 - 15;

        /*fill(0,0,0);
        textSize(10);
        text(i*y_interval, pos_x, pos_y);*/
        
        if (shown_intervals == 0) {
          fill(0,0,0);
          textSize(10);
          text(int(i*y_interval), pos_x, pos_y);
          shown_intervals = num_intervals/10;
        } else {
           shown_intervals--;
        }
    }    
    
    //Draw x axis labels
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
    
    //y axis header
    translate(15, height/2);
    rotate(-PI/2);
    text(data.header[1], 0, 0); 
    rotate(PI/2);
    translate(-15, -height/2);
    
    textAlign(BASELINE);
  }
  
  void draw_points(float r) {
        y_coords = new float[0];
        float max_height = num_intervals*y_interval;
        
        for (int i = 0; i < data.name.length; i++) {
            float ratio = data.values[0][i]/max_height;
            y_coords = append(y_coords, (float(canvas_h)-(float(canvas_h)*ratio))+canvas_y1);
            //y_coords = append(y_coords, canvas_y2 - ((canvas_h/(num_intervals*y_interval))*data.value[i]));
            if (i == isect) {
              fill(255, 0, 0);
              ellipse(x_coords[i], y_coords[i], r, r);
              textSize(10);
              text("(" + data.name[i] + ", " + data.values[0][i] + ")", x_coords[i] + 8, y_coords[i] + 8);
            } else {
              fill(0,0,0);
              ellipse(x_coords[i], y_coords[i], r, r);
            }
            
        }
  }
  
  void draw_line(float[] x1, float[] y1, float[] x2, float[] y2) {
        for (int i = 0; i < (data.name.length - 1); i++) {
            line(x1[i], y1[i], x2[i+1], y2[i+1]);
        }
  }
  
  boolean line_to_bar() {
    if (phase == 0) {
        phase += set_dummy();
    } else if (phase == 1) {
        phase += shrink_lines();
    } else if (phase == 2) {
        phase += shrink_points();
    } else {
        phase = 0;
        return true;
    }
        
    make_canvas(); 
    draw_axes();
    draw_axes_titles();
    draw_points(dum_radius);
    draw_line(x_coords, y_coords, dum_x, dum_y);
    
    return false;
  }
  
  int set_dummy() {
      dum_y = new float[num_points];
      dum_x = new float[num_points];
      dum_radius = radius;
    
      for(int i = 0; i < num_points; i++) {
          dum_y[i] = y_coords[i];
          dum_x[i] = x_coords[i];
      }
      return 1;
  }
  
  int shrink_lines() {
     for(int i = 1; i < num_points; i++) {
         dum_y[i] = lerp(dum_y[i], y_coords[i-1], .1);
         dum_x[i] = lerp(dum_x[i], x_coords[i-1], .1);
     }
     
     boolean all_same = true;
     for(int i = 1; i < num_points; i++) {
         if((int)dum_y[i] != (int)y_coords[i-1]) {
             all_same = false;
         } else if ((int)dum_x[i] != (int)x_coords[i-1]) {
             all_same = false;
         }
     }
     
     if(all_same) {
       return 1;
     } else {
       return 0;
     }
  }
  
  int shrink_points() {
      dum_radius = lerp(dum_radius, 1, .05);
      print(dum_radius, "\n");

      if(dum_radius < 1.2) {
        return 1;
      } else {
        return 0;
      }
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
}
