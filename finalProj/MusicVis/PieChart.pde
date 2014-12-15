/*
class PieChart {
  boolean visible;
  String x_axis;
  String y_axis;
  float y_max;
  int num_points;
  int canvas_x1, canvas_x2;
  int canvas_y1, canvas_y2;
  int canvas_w, canvas_h;
  int isect;
  float[] angles;
  
  //variables matt made global
  float diameter; //set during draw function
  color text_color;  //(200, 150, 200)
  float avg_ang;
  

  PieChart() {
    UserData = d;
    num_points = data.name.length;
    isect = -1;
    text_color = color(200, 150, 200);
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
      total += data.values[0][i];
    }
    for (int k = 0; k < data.name.length; k++) {
      float angle = float(360) * data.values[0][k] / total;
      angles = append(angles, angle);
    }
  }

  void draw_chart() {
      find_diameter();
  
        //make_chart(text color,     wedge locations, wedge rotation)
        //make_chart(color text_c,   bool spreading,  bool rotating)
      if(phase == 0) {          //normal draw
          make_chart(text_color, false, false, false, false);
      } else if (phase == 1) {  //fading text color out
          make_chart(dum_text_color, false, false, false, false);
      } else if (phase == 2) {  //shrinking graph
          make_chart(255, true, false, false, false);
      } else if (phase == 3) {  //spreading wedges out
          make_chart(255, true, true, false, false);
      } else if (phase == 4) {  //phase == 4, turn wedges up
          make_chart(255, true, true, true, false);
      } else {                  //phase == 5, collapse wedges
          make_chart(255, true, true, true, true);
      }
  }
  
  void draw_chart_r() {
      find_diameter();
  
      if(phase == 0) {          //normal draw
          make_chart(text_color, false, false, false, false);
      } else if (phase == 1) {  //fading text color out
          make_chart(dum_text_color, false, false, false, false);
      } else if (phase == 2) {  //shrinking graph
          make_chart(255, true, false, false, false);
      } else {  //smoothing wedges
          make_chart(255, true, false, true, false);
      }
  }
  
  void draw_chart_rev() {
    find_diameter();
  
        //make_chart(text color,     wedge locations, wedge rotation)
        //make_chart(color text_c,   bool spreading,  bool rotating)
      if((phase == 0) || (phase == 1)) { //just coming out of bar & initialize
          make_chart(255, true, true, true, true);
      } else if (phase == 2) {  //expand wedges
          make_chart(255, true, true, true, true);
      } else if (phase == 3) {  //wedges rotate back home
          make_chart(255, true, true, true, false);
      } else if (phase == 4) {  //wedges reconvene
          make_chart(255, true, true, false, false);
      } else if (phase == 5) {  //graph expands
          make_chart(255, true, false, false, false);
      } else {                  //fade text back in
          make_chart(dum_text_color, false, false, false, false);
      }
  }


  void make_chart(color text_c, boolean shrink, boolean spread, boolean rotate, boolean collapse) {
      float lastAngle = 0;
      
      for (int i = 0; i < data.values[0].length; i++) {
          float gray = map(i, 0, data.values[0].length, 0, 255);
          fill(150, gray, 150);
         
          if(!shrink && !spread && !rotate && !collapse) {
              arc(width/2, height/2, diameter, diameter, lastAngle, lastAngle + radians(angles[i]), PIE);
              draw_words(text_c, lastAngle, i);
          } else if (shrink && !spread && !rotate && !collapse) {
              arc(width/2, height/2, dum_dia, dum_dia, lastAngle, lastAngle + radians(angles[i]), PIE);
          } else if (shrink && !spread && rotate && !collapse) {  //special pie_to_rose mode
              arc(width/2, height/2, dum_dia, dum_dia, radians(dum_last_ang[i]), radians(dum_last_ang[i] + dum_angles[i]), PIE);
          } else if (shrink && spread && !rotate && !collapse) {
              arc(spread_loc[i], dum_height[i], dum_dia, dum_dia, lastAngle, lastAngle + radians(angles[i]), PIE);
          } else if (shrink && spread && rotate && !collapse) {
              arc(spread_loc[i], dum_height[i], dum_dia, dum_dia, dum_last_ang[i], dum_last_ang[i] + radians(angles[i]), PIE);
          } else {//(shrink && spread && rotate && collapse)
              arc(spread_loc[i], dum_height[i], dum_dia, dum_dia, dum_last_ang[i], radians(dum_angles[i]), PIE);
          }
          
          lastAngle += radians(angles[i]);
      }
  }
  
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
  
  void find_diameter() {
    if (width > height) {
      diameter = height/2;
    } else {
      diameter = width/2;
    }
  }

   
}
*/


