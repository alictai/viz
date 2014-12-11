import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MusicVis extends PApplet {

int screenWidth = 1200;
int screenHeight = 700;

Parser   parser;
Display  toShow;
Slider   slider;

public void setup() {
  parser = new Parser();
  toShow = new Display();
  slider = new Slider(0, 650, 1200, 50);
  
  frameRate(30);
  
  size(screenWidth, screenHeight);
  /*
  if (frame != null) {
    frame.setResizable(true);
  }
  */
   
}


public void draw() {
  background(230);
  slider.draw_slider();
  //find range from slider
  //pass range into Display's draw
  //display has range, pulls data, updates vizs
  
}

/* events */
class AgeGroup {
  final int NUM_QS = 20;
  final int NUM_WORDS = 80;
  boolean contains_data;
  int[]   word_freqs;    //size 80, each index = same word
  float[] avg_q_score; 
  int[]   num_ppl_per_q; //if performance issues, fix this first
  
  AgeGroup() {
     word_freqs    = new int[NUM_WORDS];
     
     avg_q_score   = new float[NUM_QS];
     num_ppl_per_q = new int[NUM_QS];
     
     contains_data = false; //handle this differently?
  }
}
class Cloud {
  boolean active;
  
  float x_coord;
  float y_coord;
  float hgt;
  float wid; 
  
}
class Display {
  //data for visualizations
  UserData ud;      //contains an array of AgeGroups for m & f
  
  //list of visualizations, may be active or nah
  Cloud    cloud; 
  ParGraph par_graph;
  /* more to be added */


  Display() {
    ud = new UserData();
    cloud = new Cloud();
    //par_graph = new ParGraph(data);
  }

  
}
//Needs UserData to have:
//  int get_num_rows() { return vals[0].length; }
//  String get_header(int index) { return header[index]; };

class ParGraph {
  //initializations for final project
  boolean active;
  int num_cols;
  int num_rows;

  //default initializations
  UserData data;
  float[] mins;
  float[] maxes;
  float[] x_coords;
  float[][] y_coords;
  float[][] label_coords;
  float[][] labels;
  float x, y;
  float w, h;
  float y_top, y_bott;
  float x_spacing;
  int num_labels;
  PGraphics pg;
  int colored_col;
  int hover_col;
  int[][] colors;
  int[] color_list;
  boolean curve;
  boolean flip;
  boolean[] flipped_cols;

  ParGraph (UserData d) {
    //initializations for final project
    num_cols = 19;
    num_rows = 100000;

    //default initializations
    data = d;
    mins = new float[num_cols];
    maxes = new float[num_cols];
    find_bounds();
    x_coords = new float[num_cols];
    y_coords = new float[num_cols][num_rows];
    num_labels = 5;
    labels = new float[num_cols][num_labels];
    label_coords = new float[num_cols][num_labels];
    pg = null;
    colored_col = num_cols - 1;
    hover_col = -1;
    colors = new int[num_cols][num_rows];
    curve = false;
    flip = false;
    flipped_cols = new boolean[num_cols];
    for (int i = 0; i < flipped_cols.length; i++) {
      flipped_cols[i] = false;
    }

    //generating colors
    color_list = new int[num_labels-1];
    if (num_labels - 1 == 4) {
      color_list[0] = color(255, 0, 146);
      color_list[1] = color(182, 255, 0);
      color_list[2] = color(34, 141, 255);
      color_list[3] = color(255, 202, 27);
    } else {
      for (int i = 0; i < color_list.length; i++) {
        color_list[i] = color(random(0, 255), random(0, 255), random(0, 255));
      }
    }
  }

  public void draw_graph(float x_in, float y_in, float w_in, float h_in) {
    x = x_in;
    y = y_in;
    w = w_in;
    h = h_in;

    calculate_axes();
    calc_pts();
    calc_labels();
    calc_colors();

    draw_axes();
    draw_lines();
    draw_pts();
    draw_labels();
  }

  public void find_bounds() {
    for (int i = 0; i < num_cols; i++) {
      mins[i] = min(data.vals[i]);
      maxes[i] = max(data.vals[i]);
    }
  }

  public void calculate_axes() {
    x_spacing = w/(num_cols+1);
    for (int i = 0; i < x_coords.length; i++) {
      x_coords[i] = x + x_spacing * (i+1);
    }

    y_top = y+20;
    y_bott = y + h - 40;
  }

  public void calc_pts() {
    for (int i = 0; i < num_cols; i++) {
      for (int k = 0; k < num_rows; k++) {
        y_coords[i][k] = map(data.vals[i][k], mins[i], maxes[i], y_bott, y_top);
      }
    }
    for (int i = 0; i < flipped_cols.length; i++) {
      if (flipped_cols[i]) { 
        flip_pts(i);
      }
    }
  }

  public void calc_labels() {
    float y_spacing = (y_bott - y_top)/(num_labels-1);
    for (int i = 0; i < num_cols; i++) {
      for (int k = 0; k < num_labels; k++) {
        float label_spacing = (maxes[i] - mins[i])/(num_labels-1);
        float label = mins[i] + (label_spacing*k);
        labels[i][k] = label;
        label_coords[i][k] = y_bott - (y_spacing*k);
      }
    }
    for (int i = 0; i < flipped_cols.length; i++) {
      if (flipped_cols[i]) { 
        flip_labels(i);
      }
    }
  }

  public void calc_colors() {
    for (int i = 0; i < num_cols; i++) {
      for (int k = 0; k < num_rows; k++) {
        for (int m = 0; m < num_labels - 1; m++) {
          if (!flipped_cols[colored_col]) {
            if (data.vals[colored_col][k] >= labels[colored_col][m] &&
              data.vals[colored_col][k] <= labels[colored_col][m+1]) {
              colors[i][k] = color_list[m];
            }
          } else {
            if (data.vals[colored_col][k] <= labels[colored_col][m] &&
              data.vals[colored_col][k] >= labels[colored_col][m+1]) {
              colors[i][k] = color_list[m];
            }
          }
        }
      }
    }
  }

  public void draw_axes() {
    for (int i = 0; i < x_coords.length; i++) {
      if (i == colored_col) {
        strokeWeight(2); 
        stroke(186, 141, 255);
        fill(186, 141, 255);
      } else if (i == hover_col) {
        strokeWeight(1); 
        stroke(0, 255, 173);
        fill(0, 255, 173);
      }

      line(x_coords[i], y_top, x_coords[i], y_bott);
      textSize(10);
      textAlign(CENTER);
      text(data.get_header(i), x_coords[i], y_bott + 20);

      strokeWeight(1);
      stroke(0);
      fill(0);
    }
  }

  public void draw_pts() {
    for (int i = 0; i < num_cols; i++) {
      for (int k = 0; k < num_rows; k++) {
        fill(0, 0, 0);
        ellipse(x_coords[i], y_coords[i][k], 5, 5);
      }
    }
  }

  public void draw_lines() {
    if (curve) {
      noFill();
      int num_cols = num_cols;
      for (int i = 0; i < (num_rows); i++) {
        //for (int i = 0; i < 1; i++) {
        stroke(colors[0][i]);
        for (int k = 0; k < num_cols - 1; k++) {
          if (y_coords[k][i] > y_coords[k+1][i]) {
            bezier(x_coords[k], y_coords[k][i], 
            x_coords[k]+(x_spacing/4), y_coords[k][i]+((3/4)*(y_coords[k][i]-y_coords[k+1][i])), 
            x_coords[k]+3*(x_spacing/4), y_coords[k+1][i]-((1/4)*(y_coords[k][i]-y_coords[k+1][i])), 
            x_coords[k+1], y_coords[k+1][i]);
          } else {
            bezier(x_coords[k], y_coords[k][i], 
            x_coords[k]+3*(x_spacing/4), y_coords[k][i]-((1/4)*(y_coords[k+1][i]-y_coords[k][i])), 
            x_coords[k]+(x_spacing/4), y_coords[k+1][i]+((3/4)*(y_coords[k+1][i]-y_coords[k][i])), 
            x_coords[k+1], y_coords[k+1][i]);
          }
        }
      }
      stroke(0);
    } else {
      for (int i = 0; i < (num_rows); i++) {
        for (int k = 0; k < num_cols - 1; k++) {
          stroke(colors[k][i]);
          line(x_coords[k], y_coords[k][i], x_coords[k+1], y_coords[k+1][i]);
          stroke(0, 0, 0);
        }
      }
    }
  }

  public void draw_labels() {
    for (int i = 0; i < num_cols; i++) {
      for (int k = 0; k < num_labels; k++) {
        fill(0, 0, 0);
        textSize(10);
        textAlign(RIGHT, CENTER);
        float len = y_bott - y_top;
        text(labels[i][k], x_coords[i]-5, label_coords[i][k]);
      }
    }
  }

  public void col_change(int mousex) {
    int num_cols = num_cols;
    for (int i = 0; i < num_cols; i++) {
      if (mousex > (width/num_cols)*i && mousex < (width/num_cols)*(i+1)) {
        colored_col = i;
      }
    }
  }

  public void hover(int mousex) {
    int num_cols = num_cols;
    for (int i = 0; i < num_cols; i++) {
      if (mousex > (w/num_cols)*i && mousex < (w/num_cols)*(i+1)) {
        hover_col = i;
      }
    }
  }

  public void flip_dim() { 
    flipped_cols[hover_col] = true;
  }
  public void unflip() { 
    flipped_cols[hover_col] = false;
  }

  public void flip_pts(int i) {
    //print("flipping points\n");
    for (int k = 0; k < num_rows; k++) {
      y_coords[i][k] = map(data.vals[i][k], maxes[i], mins[i], y_bott, y_top);
      //print("flipped: ", y_coords[i][0], "\n");
    }
  }

  public void flip_labels(int i) {
    float y_spacing = (y_bott - y_top)/(num_labels-1);
    for (int k = 0; k < num_labels; k++) {
      float label_spacing = (maxes[i] - mins[i])/(num_labels-1);
      float label = maxes[i] - (label_spacing*k);
      labels[i][k] = label;
      label_coords[i][k] = y_bott - (y_spacing*k);
    }
  }

  public void view_bezier() { 
    curve = true;
  }
  public void view_line() { 
    curve = false;
  }
}

class Parser {
  
  
}
class Bracket {
  float x, y, w, h;
  int val;
 
  Bracket() {
    val = (int)random(94);
  } 
  
}

class Slider {
  float x, y;
  float wid, hgt;
 
  Bracket left, right;
 
  Slider(float xx, float yy, float w, float h) {
    x = xx;
    y = yy;
    wid = w;
    hgt = h;
    
    left = new Bracket();
    right = new Bracket();
  } 
  
  public void draw_slider() {
    stroke(100);
    strokeWeight(0);
    fill(100);
    rect(x, y, wid, hgt); 
    draw_range();
    //left.draw_self();
    //right.draw_self();
    
  }
  
  public void draw_range() {
    stroke(70);
    strokeWeight(4);
    float x1 = x + 100;
    float x2 = wid - 100;
    float yn  = y + (hgt / 2);
    line(x1, yn, x2, yn);
    draw_notches(x1, x2, yn);
  }
  
  public void draw_notches(float xl, float xr, float y) {
    float xloc;
    for(int i = 0; i < 94; i++) {
      xloc = lerp(xl, xr, (i / 94.0f));
      print(xloc, "\n");
    }
  }
  
  
  
  
}
class UserData {
  final int MAXAGE = 94;
  
  AgeGroup[] boys;
  AgeGroup[] girls;
  
  
  UserData() {
    boys = new AgeGroup[MAXAGE];
    girls = new AgeGroup[MAXAGE];
  }
  
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MusicVis" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
