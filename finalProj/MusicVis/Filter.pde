class Filter {
  float x, y;
  float wid, hgt;
  
  Slider    slider;
  Gen_Check male;
  Gen_Check female;
  
  VisLabel cloud;
  VisLabel par;
  VisLabel pie;
  VisLabel tbd2;
 
  Filter(float _x, float _y, float w, float h) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    
    float s_x = x + 20;
    float s_y = y + 75; 
    float s_w = wid - 400;

    slider = new Slider(x + 20, y + 25, w - 400);

    male   = new Gen_Check(wid - 470, y + 60, 30, 10, true, "Male");
    female = new Gen_Check(x + 70,    y + 60, 45, 10, true, "Female");   
    
    cloud = new VisLabel(835, y + 25, 85, 50, "HistoricGoat.jpg", true);
    par   = new VisLabel(925, y + 25, 85, 50, "SadGoat.jpg", false);
    pie  = new VisLabel(1015, y + 25, 85, 50, "PattyGoat.jpg", false);
    tbd2  = new VisLabel(1105, y + 25, 85, 50, "VikingsGoat.jpg", false);
  } 
  
  void draw_filter() {
    fill(100);
    strokeWeight(0);
    rect(x, y, wid, hgt); 
    
    draw_prompt();
    slider.draw_slider(); 
    male.draw_gen();
    female.draw_gen();
    cloud.draw_label();
    par.draw_label();
    pie.draw_label();
    tbd2.draw_label();
  }
  
  void draw_prompt() {
    PFont font;
    font = loadFont("DejaVuSans-20.vlw");
    textFont(font, 20);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);
    textLeading(18);
    text("SELECT AGE AND\nGENDER DEMOGRAPHIC", x + 420, y + 65);
    
  }
  
  
  Range get_range() {
    Range toRet = new Range();;
    boolean m, f;
    
    m = male.active;
    f = female.active;
    
    toRet = slider.get_range(toRet); 
    
    if(m) {
      if(f) {
        toRet.gender = "both";
      } else {
        toRet.gender = "male";
      }
    } else {
      if(f) {
        toRet.gender = "female";
      } else {
        toRet.gender = "neither";
      }
    }
    
    if(cloud.active) {
      toRet.curVis = "cloud";
    } else if(par.active) {
      toRet.curVis = "par";
    } else if(pie.active) {
      toRet.curVis = "pie";
    } else if(tbd2.active) {
      toRet.curVis = "tbd2";
    } else {
      toRet.curVis = "";
    }
    
    return toRet;
  }
  
  void pressed() {
    slider.check_brackets(); 
    male.check_activate();
    female.check_activate();
    
    String visp = which();
    
    if(visp.equals("cloud")) {
      cloud.activate();
      par.deactivate();
      pie.deactivate();
      tbd2.deactivate();
    } else if(visp.equals("par")) {
      cloud.deactivate();
      par.activate();
      pie.deactivate();
      tbd2.deactivate();
    } else if(visp.equals("pie")) {
      cloud.deactivate();
      par.deactivate();
      pie.activate();
      tbd2.deactivate();
    } else if(visp.equals("tbd2")) {
      cloud.deactivate();
      par.deactivate();
      pie.deactivate();
      tbd2.activate();
    }
  }
  
  String which() {
    if(cloud.was_pressed()) {
      return "cloud";
    } else if(par.was_pressed()) {
      return "par";
    } else if(pie.was_pressed()) {
      return "pie";
    } else if(tbd2.was_pressed()) {
      return "tbd2";
    } else {
      return "";
    }
  }

  void released() {
    slider.unactivate(); 
  }
  
}

class Range {
  int low;
  int high;
  String gender; //can be male, female, or both
  String curVis; //can be cloud, par, pie, or tbd2
}

class Gen_Check {
  float x, y;
  float wid, hgt;
  
  String title;
  
  boolean active;
  boolean deac;
  boolean reac;
  
  int transNum;
 
  Gen_Check(float _x, float _y, float w, float h, boolean act, String t) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    active = act;
    title = t;
    deac = false;
    reac = false;
    transNum = 0;
  } 
  
  void draw_gen() {
    if(active) {
      if(reac) {
        float col = map(transNum, 0, 30, 70, 200);
        fill(col);
        transNum++;
        
        if(transNum == 30) {
          reac = false;
          transNum = 0;
        }
      } else {
        fill(200);
      }
    } else {
      if(deac) {
        float col = map(transNum, 0, 30, 200, 70);
        fill(col);
        transNum++;
        
        if(transNum == 30) {
          deac = false;
          transNum = 0;
        }
      } else {
        fill(70);
      }
    }
   
    
    PFont font;
    font = loadFont("DejaVuSans-20.vlw");
    textFont(font, 20);
    textAlign(CENTER, CENTER);
    textSize(25);
    text(title, x, y);
  }
  
  
  void check_activate() {
    if(mouseX > x - wid && mouseX < x + wid) {
      if (mouseY > y - hgt && mouseY < y + hgt) {
        if(active) {
          active = false;
          deac = true;
        } else {
          active = true;
          reac = true;
        }
      }
    }
  }
}

class VisLabel {
  float x, y;
  float wid, hgt;
  PImage img;
  boolean active;
  boolean deac;
  boolean reac;
  int transNum;
 
  VisLabel(float _x, float _y, float w, float h, String path, boolean act) {
    x = _x;
    y = _y;
    wid = w;
    hgt = h;
    img = loadImage(path);
    active = act;
    reac = false;
    deac = false;
    transNum = 0;
  }
  
  void draw_label() {
    if (!active) {
      if(deac) {
        float col = map(transNum, 0, 20, 255, 100);
        tint(col);
        
        transNum++;
        if(transNum == 20) {
          transNum = 0;
          deac = false; 
        }
      } else {
        tint(100);
      } 
    } else {
      if(reac) {
        float col = map(transNum, 0, 20, 100, 255);
        tint(col);
        
        transNum++;
        if(transNum == 20) {
          transNum = 0;
          reac = false; 
        }
      } else {
        tint(255);
      }
    }

    image(img, x, y, wid, hgt);
  }
  
  void activate() {
    if(!active) {
      active = true;
      reac = true; 
    }
  }
  
  void deactivate() {
    if(active) {
      active = false;
      deac = true;
    }
  }
  
  void check_activate() {
    if(mouseX > x && mouseX < x + wid) {
      if(mouseY > y && mouseY < y + hgt) {
        if(active) {
          active = false;
          deac = true;
        } else {
          active = true;
          reac = true;
        }
      }
    }
  }
  
  boolean was_pressed() {
    if (mouseX > x && mouseX < x + wid) {
      if(mouseY > y && mouseY < y + hgt) {
        return true;
      }
    }
    
    return false;
  }
}


