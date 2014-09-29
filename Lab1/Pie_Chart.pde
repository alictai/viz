class Pie_Chart {
  boolean visible;  
  Data data;
  String x_axis;
  String y_axis;
  int y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  int isect;
  float[] angles;

  Pie_Chart(Data parsed) {
    data = parsed;
    y_max = max(data.value);
    num_points = data.name.length;
    isect = -1;
  }
  
  void draw_graph() {
    make_canvas(); 
    find_angles();
    draw_chart();
  }
    
  void make_canvas() {
    canvas_y1 = 40;
    canvas_y2 = height - 90;
    canvas_x1 = 60;
    canvas_x2 = width - 60;
    
    canvas_w = canvas_x2 - canvas_x1;
    canvas_h = canvas_y2 - canvas_y1;
  }
  
  void find_angles() {
      float total = 0;
      angles = new float[0];
      for (int i = 0; i < data.name.length; i++) {
         total += float(data.value[i]);
      }
      for (int k = 0; k < data.name.length; k++) {
         float angle = float(360) * float(data.value[k]) / total;
         angles = append(angles, angle);
      }
  }
  
  void draw_chart() {
      float lastAngle = 0;
      float diameter;
      if (width > height) {
          diameter = height/2;
      } else {
          diameter = width/2;
      }
      
      noStroke();
      for (int i = 0; i < data.value.length; i++) {
          float gray = map(i, 0, data.value.length, 0, 255);
          fill(gray);
          arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle+radians(angles[i]));
          lastAngle += radians(angles[i]);
          
          translate(width/2, height/2);
          rotate(lastAngle - radians(angles[i]/2));
          translate(diameter/2 + 10, 0);
          
          fill(200,150,200);
          textSize(15);
          textAlign(BASELINE);
          String label = data.name[i] + ", " + str(data.value[i]);
          text(label, 0, 0); 
          
          translate(-diameter/2 - 10, 0);
          rotate(-lastAngle + radians(angles[i]/2));
          translate(-width/2, -height/2);
      }
  }
  
  /*void point_intersect(int mousex, int mousey) {
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
  }*/
}
