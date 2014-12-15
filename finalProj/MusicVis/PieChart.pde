class PieChart {
  String x_axis;
  String y_axis;
  float y_max;
  int num_slices;
  float total_time;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  int isect;
  float list_own_angle;
  float list_back_angle;
  float rem_angle;
  MusicPref data;
  
  //variables matt made global
  float diameter; //set during draw function
  color text_color;  //(200, 150, 200)
  float avg_ang;
  

  PieChart(MusicPref d) {
    data = d;
    num_slices = 3;
    text_color = color(200, 150, 200);
    total_time = 24;
  }

  void draw_graph() {
    make_canvas(); 
    find_angles();
    find_diameter();
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
    list_own_angle = float(360) * data.listen_own_avg / total_time;
    list_back_angle = float(360) * data.listen_back_avg / total_time;
    rem_angle = float(360) - list_own_angle - list_back_angle;
  }

  

  void draw_chart() {
      print("drawing pie\n");
      float lastAngle = 0;
         noStroke();
         //float gray = map(i, 0, data.values[0].length, 0, 255);
         fill(200, 100, 200);
         arc(width/2, height/2, diameter, diameter, 0, 0 + radians(list_own_angle), PIE);
         lastAngle += radians(list_own_angle);
         fill(150, 0, 150);
         arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle + radians(list_back_angle), PIE);
         lastAngle += radians(list_back_angle);
         fill(220, 220, 255);
         arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle + radians(rem_angle), PIE);
         //draw_words(text_c, lastAngle, i);
          
  }
  /*
  void draw_words(color c, float lastAngle, int i) {
      //translate
      translate(width/2, height/2);
      rotate(lastAngle + radians(angles[i]/2));
      translate(diameter/2 + 10, 0);

      //print words
      fill(c);
      textSize(15);
      textAlign(BASELINE);
      String label = data.name[i] + ", " + str(data.values[0][i]);
      text(label, 0, 0); 

      //un-translate
      translate(-diameter/2 - 10, 0);
      rotate(-lastAngle - radians(angles[i]/2));
      translate(-width/2, -height/2);
  }
  */
  
  void find_diameter() {
    if (width > height) {
      diameter = height/2;
    } else {
      diameter = width/2;
    }
  }
}



