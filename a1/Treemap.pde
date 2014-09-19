class Treemap {
  Canvas root;
  
  Treemap(Canvas node) {
    root = node;
  }
  
  void draw_treemap() {
      //initialize root
      root.wid = width;
      root.hgt = height;
      root.xl = 0;
      root.xr = width;
      root.yt = 0;
      root.yb = height;
    
      //calculate canvas area
      int area = width * height;
      
      //calculate total value
      int total_val; /*******/
      
      //call recursively?
      calc_width_height(root);
  }
  
  void calc_width_height(Canvas parent) {
      Canvas[] children = parent.children;
      int canvas_area = parent.wid * parent.hgt;
      float VA_ratio = float(parent.total_value)/float(canvas_area);
      int short_side;
      
      //sort values from biggest to smallest
      
      if (parent.wid < parent.hgt) {
          short_side = parent.wid;
      } else {
          short_side = parent.hgt;
      }
      
      Canvas c1 = children[0];
      c1.wid = VA_ratio * parent.wid * children.total_value;
      c1.hgt = VA_ratio * parent.hgt * children.total_value;
      //draw c1 on short_side
      
      float ratio_c1 = float(c1.wid)/float(c1.hgt);
      
      
  }
}
