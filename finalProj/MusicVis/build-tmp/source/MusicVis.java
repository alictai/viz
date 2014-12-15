import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.geom.Area; 
import java.awt.geom.Rectangle2D; 
import java.awt.Shape; 
import wordcram.*; 

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
Filter   filter;
WordCram wc;
Range    range;
Range    prev_range;

//PGraphics canvas = this.createGraphics(screenWidth - 100, screenHeight - 100, P2D\\);
PImage image = createImage(1000, 650, RGB);
Shape imageShape = new ImageShaper().shape(image, 0xff000000);
ShapeBasedPlacer placer = new ShapeBasedPlacer(imageShape);

public void setup() {
  size(screenWidth, screenHeight);
  background(255);
  frameRate(60);

  parser = new Parser();
  UserData data = parser.parse("../merged.csv");
  wc = new WordCram(this);
  //wc.withCustomCanvas(this.canvas);
  toShow = new Display(wc, data);
  filter = new Filter(0, 600, 1200, 100);
  prev_range = new Range();
  prev_range.low = 0;
  prev_range.high = 93;



  /*
  if (frame != null) {
   frame.setResizable(true);
   }
   */
}


public void draw() {
  //slider.draw_slider();
  filter.draw_filter();
  
  range = filter.get_range();
  if (range.low >= range.high) {
    range.high = range.low + 1;
  }
  
  boolean freqs_changed = toShow.get_freqs(range);
  
  if ((range_changed() == true) && (freqs_changed == true)) {
    wc = new WordCram(this);
    fill(255);
    noStroke();
    rect(0, 0, 1200, 600);
    //delete this line and change 650 to 600 before pulling
  }
  
  toShow.draw_graphs(wc);
  
  
  //print("Range: ", range.low, " to ", range.high, "\n");
  //find range from slider
  //pass range into Display's draw
  //display has range, pulls data, updates vizs
}

public boolean range_changed() {
  if((range.low == prev_range.low) && (range.high == prev_range.high)) {
      return false;
  } else {
      prev_range = range;
      return true;
  }
}

/* events */

public void mouseClicked() {
  toShow.check_click();
}

public void mousePressed() {
  filter.check_brackets();
}

public void mouseReleased() {
  filter.unactivate();
}

class AgeGroup {
  final int NUM_QS = 20;
  final int NUM_WORDS = 82;
  boolean contains_data;
  int[]   word_freqs;    //size 80, each index = same word
  float[] total_q_score; 
  int[]   num_per_q; //if performance issues, fix this first
  
  AgeGroup() {
     word_freqs    = new int[NUM_WORDS];
     
     total_q_score   = new float[NUM_QS];
     
     num_per_q = new int[NUM_QS];
     
     contains_data = false; //handle this differently?
  }
  
  
}
class Cloud {
  boolean active;
  
  float x_coord;
  float y_coord;
  float hgt;
  float wid; 
  
  WordCram wc;
  UserData data;
  int freq_range;
  int prev_freq_range = 0;
  String gender = "female";
  
  String[] words = {"Uninspired","Sophisticated","Aggressive","Edgy","Sociable","Laid back","Wholesome",
    "Uplifting","Intriguing","Legendary","Free","Thoughtful","Outspoken","Serious","Good lyrics",
    "Unattractive","Confident","Old","Youthful","Boring","Current","Colourful","Stylish","Cheap",
    "Irrelevant","Heartfelt","Calm","Pioneer","Outgoing","Inspiring","Beautiful","Fun","Authentic",
    "Credible","Way out","Cool","Catchy","Sensitive","Mainstream","Superficial","Annoying","Dark",
    "Passionate","Not authentic","Good Lyrics","Background","Timeless","Depressing","Original",
    "Talented","Worldly","Distinctive","Approachable","Genius","Trendsetter","Noisy","Upbeat",
    "Relatable","Energetic","Exciting","Emotional","Nostalgic","None of these","Progressive","Sexy",
    "Over","Rebellious","Fake","Cheesy","Popular","Superstar","Relaxed","Intrusive","Unoriginal",
    "Dated","Iconic","Unapproachable","Classic","Playful","Arrogant","Warm","Soulful"};
  
  Cloud(WordCram w, UserData d) {
    wc = w;
    data = d;
  }
  
  public int[] get_freqs(Range range, String gen) {
    int[] freqs = data.get_freqs(range, gender);
    gender = gen;
    
    freq_range = max(freqs) - min(freqs);
    
    return freqs;
  }
  
  public void set_weights(WordCram w, int[] freqs) {
    wc = w;
    //wc.withColors(color(134, 56, 57), color(32, 68, 110), color(187, 5, 100));
    
    Word[] wordArray = new Word[words.length];
    for (int i = 0; i < words.length; i++) {
      wordArray[i] = new Word(words[i], freqs[i]);
      if (freqs[i] < freq_range/3) {
        wordArray[i].setProperty("value", "low");
      } else if (freqs[i] > 2*freq_range/3) {
        wordArray[i].setProperty("value", "high");
      } else {
        wordArray[i].setProperty("value", "medium");
      }
    }
    
    wc.fromWords(wordArray);
    wc.withColorer( new WordColorer() {
      public int colorFor(Word w) {
         if (w.getProperty("value") == "low") {
           return color(134, 56, 57);
         } else if (w.getProperty("value") == "medium") {
           return color(32, 68, 110);
         } else if (w.getProperty("value") == "high") {
           return color(187, 5, 100);
         }
         
         return 0;
      } 
    });
  }
  
  public void draw_cloud() {
      if (freq_range != 0) {
          wc.drawAll();
          if (wc.hasMore()) {
            print("drawing more\n");
             wc.drawNext();
          }
          prev_freq_range = freq_range;
      }
      
  }
  
  public boolean freq_changed() {
    if (freq_range == prev_freq_range) {
      return false;
    } else {
      return true;
    }
  }
  
  //code below for generating bar graphs
  
  public void check_click() {
    Word clicked = wc.getWordAt(mouseX, mouseY);
    
    if (clicked == null) {
      print("no word clicked\n");
    } else {
      print(clicked, "\n");
      String[] split_line = splitTokens(clicked.toString(), " ");
      String word = split_line[0];
      int index = get_word_index(word);
      int[] bar_stats = data.get_bar_stats(index, gender);
      
    }
  }
  
  public int get_word_index(String w) {
      for (int i = 0; i < words.length; i++) {
        if (w.equals(words[i])) {
          return i;
        }
      }
      return -1;
  }
}
class Display {
  //data for visualizations
  UserData data;      //contains an array of AgeGroups for m & f
  
  //list of visualizations, may be active or nah
  Cloud    cloud; 
  //ParGraph par_graph;
  /* more to be added */
  
  int[] word_freqs;

  Display(WordCram wc, UserData d) {
    data = d;
    cloud = new Cloud(wc, data);
    //par_graph = new ParGraph(data);
  }
  
  //returns true if frequencies change
  public boolean get_freqs(Range range) {
      word_freqs = cloud.get_freqs(range, "female");
      return cloud.freq_changed();
  }

  public void draw_graphs(WordCram wc) {
      cloud.set_weights(wc, word_freqs);
      //cloud.draw_cloud();
      //uncomment b4 pull
  }
  
  public void check_click() {
      cloud.check_click();
  }
  
  
  
  
}
class Filter {
  float x, y;
  float wid, hgt;
  
  Slider slider;
 
 
 
  Filter(float _x, float _y, float w, float h) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    
    float s_x = x + 20;
    float s_y = y + 75; 
    float s_w = wid - 400;
    slider = new Slider(x + 20, y + 75, w - 400);
   
  } 
  
  public void draw_filter() {
    fill(100);
    strokeWeight(0);
    rect(x, y, wid, hgt); 
    slider.draw_slider(); 
  }
  
  public Range get_range() {
    return slider.get_range(); 
  }
  
  public void check_brackets() {
    slider.check_brackets(); 
  }
  
  public void move_brackets() {
    slider.move_brackets();
  }
  
  public void unactivate() {
    slider.unactivate(); 
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
  Range range;
  String gender;
  int[] vals;

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
    num_cols = data.NUM_QS;
    num_rows = 0;

    //default initializations
    // data = d;
    // mins = new float[num_cols];
    // maxes = new float[num_cols];
    // find_bounds();
    // x_coords = new float[num_cols];
    // y_coords = new float[num_cols][num_rows];
    num_labels = 20;
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

  public void draw_graph(int x_in, int y_in, int w_in, int h_in, Range r, String g) {
    x = x_in;
    y = y_in;
    w = w_in;
    h = h_in;

    calculate_data(r,g);
    calculate_axes();
    calc_pts();
    calc_labels();
    calc_colors();

    draw_axes();
    draw_lines();
    draw_pts();
    draw_labels();
  }

  public void calculate_data(Range r, String g) {
  	range = r;
  	gender = g;
  	num_rows = range.high - range.low;

    vals = data.get_qs_avg(range, gender);

	mins = new float[num_cols];
    maxes = new float[num_cols];
    find_bounds();
    
    x_coords = new float[num_cols];
    y_coords = new float[num_cols][num_rows];
  }

  public void find_bounds() {
    for (int i = 0; i < num_cols; i++) {
      mins[i] = min(vals);
      maxes[i] = max(vals);
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
  UserData data;
  int num_quest;
  int num_words;
  int quest_index;
  int word_index;
  
  Parser() {
    data = new UserData();
    num_quest = 19;
    num_words = 82;
    quest_index = 8;
    word_index = 27;
  }
  
  public UserData parse(String file) {
    String[] lines = loadStrings(file);
    String[] split_line;
    
    for (int i = 1; i < lines.length; i++) {
      split_line = splitTokens(lines[i], ",");
      
      getUser(split_line);
      
    }
    
    //printtest();
    
    return data;
  }
  
  public void getUser(String[] split_line) {
    String gender = split_line[1];
    int age = PApplet.parseInt(split_line[2]);
    if (age == -1) {return;}
    
    if (gender.equals("Female")) {
      data.girls[age].contains_data = true;
      
      for (int i = 0; i < num_quest; i++) {
         data.girls[age].total_q_score[i] += PApplet.parseFloat(split_line[quest_index + i]);
         data.girls[age].num_per_q[i] += 1;
      }
      
      for (int i = 0; i < num_words; i++) {
         data.girls[age].word_freqs[i] += PApplet.parseInt(split_line[word_index + i]);
      }
    } else {
      data.boys[age].contains_data = true;
      
      for (int i = 0; i < num_quest; i++) {
         data.boys[age].total_q_score[i] += PApplet.parseFloat(split_line[quest_index + i]);
         data.boys[age].num_per_q[i] += 1;
      }
      
      for (int i = 0; i < num_words; i++) {
         data.boys[age].word_freqs[i] += PApplet.parseInt(split_line[word_index + i]);
      }
    }
  }
  
  public void printtest() {
     for (int i = 0; i < 82; i++) {
        print(data.girls[40].word_freqs[i], "\n");
     } 
  }
  
}
class Range {
  int low;
  int high;
  String gender; //can be male, female, or both
}

/*************************************************************************/
/*                            BRACKET CLASS                              */
/*************************************************************************/
class Bracket {
  float x, y;                       //pos on slide line
  float w, h;                       //static width and height
  float int_l, int_r, int_t, int_b; //box for intersecting
  float l_bound, r_bound;           //
  int val;                          //value held on slider bar
  boolean isLeft;
  boolean active;                   //currently being dragged
 
  Bracket(float _x, float _y, float _l, float _r, int start, boolean l) {
    x = _x;
    y = _y;
    l_bound = _l;
    r_bound = _r;
    w = 8;
    h = 30;
    
    int_l = x - w/2;
    int_r = x + w/2;
    int_t = y - h/2;
    int_b = y + h/2;
    
    val = start;
    isLeft = l;
    active = false;
  } 
  
  public void draw_self() {
    float x2;
    
    if (isLeft) {
      x2 = x + (w/2);
    } else {
      x2 = x - (w/2);
    }
    
    stroke(200, 0, 0);
    strokeWeight(5);
    
    line(x, y - (h/2), x,  y + (h/2)); //vert part of bracket
    line(x, y - (h/2), x2, y - (h/2)); //top horiz of bracket
    line(x, y + (h/2), x2, y + (h/2)); //bot horiz of bracket
  }
  
  public void draw_val() {
    float rect_x = x - (2 * w);
    float rect_y = y - (1.5f * h);
    float rect_w = 4 * w;
    float rect_h = .75f * h;
    strokeWeight(0);
    noStroke();
    fill(255);
    rect(rect_x, rect_y, rect_w, rect_h, 4); 
    //triangle(rect_x + (.25 * rect_w), rect_y + rect_h, rect_x + (.5 * rect_w), rect_y + rect_h + 3, rect_x + (.75 * rect_w), rect_y + rect_h);
    textAlign(CENTER, CENTER);
    fill(200, 0, 0);
    text(val, x, (y - 1.125f * h));
    
  }
  
  public void check_click() {
    if((mouseX > int_l && mouseX < int_r) && (mouseY > int_t && mouseY < int_b)) {
      active = true;
    } 
  }
  
  public void move(float oth_x) {
    if(active) {
      float lb, rb;
      
      //determining bracket's range
      if(isLeft) {
        lb = l_bound;
        rb = oth_x;
      } else {
        lb = oth_x;
        rb = r_bound;
      }
            
      if(mouseX > lb && mouseX < rb) {
        float curr, l, r;
        curr = map(val, 0, 93, l_bound, r_bound);
        l    = map(val - 1, 0, 93, l_bound, r_bound);
        r    = map(val + 1, 0, 93, l_bound, r_bound);
                
        //while (! (abs(mouseX - l) < abs(mouseX - curr)) || (abs(mouseX - r) < abs(mouseX - curr))) {
          if (abs(mouseX - l) < abs(mouseX - curr)) {
             val--;
             x = l;
             int_l = x - w/2;
             int_r = x + w/2;
          } else if (abs(mouseX - r) < abs(mouseX - curr)) {
             val++;
             x = r;
             int_l = x - w/2;
             int_r = x + w/2;
          }
        //}
      }
    } 
  }
  
  public void unactivate() {
    active = false; 
  }
}

/*************************************************************************/
/*                             SLIDER CLASS                              */
/*************************************************************************/

class Slider {
  float x, y;
  float wid;
  
  Bracket left, right;
 
  Slider(float _x, float _y, float w) {
    x = _x;
    y = _y;
    wid = w;
    
    left  = new Bracket(x,       y, x, x + wid, 0,  true);
    right = new Bracket(x + wid, y, x, x + wid, 93, false); 
  } 
  
  public void draw_slider() {
    if(mousePressed) {
      move_brackets();
    }

    draw_range();    
  }
  
  public void draw_range() {
    stroke(70);
    strokeWeight(4);
    float x1 = x;
    float x2 = x + wid;
    //float yn  = y + (hgt / 2);
    line(x1, y, x2, y);
    draw_notches(x1, x2);
  }
  
  public void draw_notches(float xl, float xr) {
    float xloc;
    int l_id = left.val;
    int r_id = right.val;
    for(int i = 0; i < 94; i++) {
      xloc = lerp(xl, xr, (i / 93.0f));
      line(xloc, y - 8, xloc, y + 8);
      
      if(i == l_id) {
        left.draw_self(); 
        if (left.active) {
          left.draw_val();
        }
        stroke(200);
        strokeWeight(4);
      }
      
      if(i == r_id) {
        right.draw_self(); 
        if (right.active) {
          right.draw_val();
        }
        stroke(70);
        strokeWeight(4);
      }
    }
  }
  
  public Range get_range() {
    Range toRet = new Range();
    toRet.low = left.val;
    toRet.high = right.val;
    toRet.gender = "both";
    
    return toRet;
  } 
  
  public void check_brackets() {
    left.check_click();
    if (left.val != right.val) {
      right.check_click();
    }
  }
  
  public void move_brackets() {
    left.move(right.x);
    right.move(left.x);
  }
  
  public void unactivate() {
    left.unactivate();
    right.unactivate(); 
  }
  
  
}
class UserData {
  final int MAXAGE = 95;
  final int NUM_QS = 20;
  final int NUM_WORDS = 82;
  
  AgeGroup[] boys;
  AgeGroup[] girls;
  
  
  UserData() {
    boys = new AgeGroup[MAXAGE];
    girls = new AgeGroup[MAXAGE];
    
    for (int i = 0; i < MAXAGE; i++) {
      girls[i] = new AgeGroup();
      boys[i] = new AgeGroup();
    }
  }
  
  public int[] get_freqs(Range range, String gender) {
    int[] total = new int[NUM_WORDS];
    for (int i = range.low; i < range.high; i++) {
      for (int j = 0; j < NUM_WORDS; j++) {
        if (gender.equals("female")) {
          total[j] += girls[i].word_freqs[j];
        } else if (gender.equals("male")) {
          total[j] += boys[i].word_freqs[j];
        } else {
          total[j] += girls[i].word_freqs[j];
          total[j] += boys[i].word_freqs[j];
        }
      }
    }
    
    return total;
  }
  
  public int[] get_bar_stats(int word_index, String gender) {
     int[] toret = new int[MAXAGE];
     
     for (int i = 0; i < MAXAGE; i++) {
        if (gender.equals("female")) {
          toret[i] = girls[i].word_freqs[word_index];
        } else if (gender.equals("male")) {
          toret[i] = boys[i].word_freqs[word_index];
        } else {
          toret[i] += girls[i].word_freqs[word_index];
          toret[i] += boys[i].word_freqs[word_index];
        }
      }
      
      return toret;
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
