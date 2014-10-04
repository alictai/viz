class Pie_Chart {
  boolean visible;  
  Data data;
  String x_axis;
  String y_axis;
  float y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  int isect;
  float[] angles;
  
  //variables for transition
  int phase;
  float[] dum_angles;

  Pie_Chart(Data parsed) {
    phase = 0;
    data = parsed;
    y_max = max(data.values[0]);
    num_points = data.name.length;
    isect = -1;
  }

  void draw_graph() {
    make_canvas(); 
    find_angles();
    draw_chart(width/2, height/2, angles);
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
      total += data.values[0][i];
    }
    for (int k = 0; k < data.name.length; k++) {
      float angle = float(360) * data.values[0][k] / total;
      angles = append(angles, angle);
    }
  }

  void draw_chart(int x, int y, float[] ang_to_draw) {
    float lastAngle = 0;
    float diameter;
    if (width > height) {
      diameter = height/2;
    } else {
      diameter = width/2;
    }

    for (int i = 0; i < data.values[0].length; i++) {
      //find gray colors, draw arcs
      float gray = map(i, 0, data.values[0].length, 0, 255);
      fill(gray);
      arc(x, y, diameter, diameter, lastAngle, lastAngle+radians(ang_to_draw[i]));
      lastAngle += radians(angles[i]);

      //translate for words
      translate(width/2, height/2);
      rotate(lastAngle - radians(angles[i]/2));
      translate(diameter/2 + 10, 0);

      //print words
      fill(200, 150, 200);
      textSize(15);
      textAlign(BASELINE);
      String label = data.name[i] + ", " + str(data.values[0][i]);
      text(label, 0, 0); 

      //un-translate
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
   
   boolean pie_to_bar() {
     //needs to return true
       make_canvas(); 
       find_angles();
       draw_chart(width/2, height/2, angles);
     
       return true;
     
     
   }
}


