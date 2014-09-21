class Treemap {
  Canvas root;
  Row[] rows;
  
  Treemap(Canvas node) {
    root = node;
    rows = new Row[0];
  }
  
  void draw_treemap() {
      float canvas_area = width*height;
      float total_value = root.total_value;
      float VA_ratio = canvas_area/total_value;
      rows = new Row[0];
      calculate_areas(root, VA_ratio);
      squarify(root, 0, 0, width, height, 0);
  }
  
  float calculate_areas(Canvas node, float ratio) {
      node.area = 0;
      if (node.is_leaf == true) {
          node.area = node.total_value * ratio;
          /*print(node.id);
          print(" area is ");
          print(node.area);
          print("\n");*/
          return node.area;
      } else {
          for (int i=0; i < node.children.length; i++) {
                node.area += calculate_areas(node.children[i], ratio);    
          }
          return node.area;
      }
  }
  
 void squarify(Canvas root, float x, float y, float wid, float hgt, int level) {
      if(root.is_leaf == true) {
          return;
      }
    
      new_row(root.children[0], x, y, wid, hgt);  
      for(int i = 1; i < root.children.length; i++) {
         add_new_node(root.children[i]);
      }
      
      draw_rows(level);
      
      for(int i = 0; i < root.children.length; i++) {
          float w = root.children[i].wid;
          float h = root.children[i].hgt;
          if (w < 0) { w = 0; }
          if (h < 0) { h = 0; }
          squarify(root.children[i], root.children[i].x, root.children[i].y, w, h, level + 1);
      }
  }
  
  //x, y, wid, and hgt represent the blank area being drawn on
  void new_row(Canvas node, float x, float y, float wid, float hgt) {
      Row temp = new Row(x, y);
      rows = (Row[])append(rows, temp);
      int curr = rows.length - 1;
      
      rows[curr].values = (Canvas[])append(rows[curr].values, node);
      
      if (wid > hgt) {
          rows[curr].horizontal = false;
          node.hgt = hgt;
          node.wid = node.area/hgt;
          node.aspect_ratio = node.wid/node.hgt;
          rows[curr].hgt = hgt;
          rows[curr].wid = node.wid;
      } else {
          rows[curr].horizontal = true;
          node.hgt = node.area/wid;
          node.wid = wid;
          node.aspect_ratio = node.wid/node.hgt;
          rows[curr].wid = wid;
          rows[curr].hgt = node.hgt;
      }
      
      rows[curr].worst_aspect = node.aspect_ratio;
      rows[curr].total_value = node.total_value;
      rows[curr].ctxt_w = wid;
      rows[curr].ctxt_h = hgt;
  }
  
  void add_new_node(Canvas node) {
      int curr = rows.length - 1;
      float aspect;
      float hgt, wid;
      
      if(rows[curr].horizontal == false) {
           hgt = (node.total_value/(rows[curr].total_value+node.total_value)) * rows[curr].hgt;
           wid = node.area/hgt;
           aspect = wid/hgt;
           
           if (dist_to_one(aspect) < dist_to_one(rows[curr].worst_aspect)) {
               node.wid = wid;
               node.hgt = hgt;
               node.aspect_ratio = aspect;
               insert_node(node);
           } else {
               float w = rows[curr].ctxt_w - rows[curr].wid;
               float h = rows[curr].hgt;
               float x = rows[curr].x + rows[curr].wid;
               float y = rows[curr].y;
               new_row(node, x, y, w, h);
           }
      } else {
           wid = node.total_value/(rows[curr].total_value+node.total_value) * rows[curr].wid;
           hgt = node.area/wid;
           aspect = wid/hgt;
           
           if (dist_to_one(aspect) < dist_to_one(rows[curr].worst_aspect)) {
               node.wid = wid;
               node.hgt = hgt;
               node.aspect_ratio = aspect;
               insert_node(node);
           } else {
               float w = rows[curr].wid;
               float h = rows[curr].ctxt_h - rows[curr].hgt;
               float x = rows[curr].x;
               float y = rows[curr].y + rows[curr].hgt;
               new_row(node, x, y, w, h);
           }
      }
  }
  
  void insert_node(Canvas node) {
      int curr = rows.length - 1;
      float worst_ratio = node.aspect_ratio;
      
      for(int i = 0; i < rows[curr].values.length; i++) {
         if (rows[curr].horizontal == false) {
             rows[curr].values[i].wid = node.wid;
             rows[curr].values[i].hgt = rows[curr].values[i].area/node.wid;
             rows[curr].values[i].aspect_ratio = rows[curr].values[i].wid/rows[curr].values[i].hgt;
         } else {
             rows[curr].values[i].hgt = node.hgt;
             rows[curr].values[i].wid = rows[curr].values[i].area/node.hgt;
             rows[curr].values[i].aspect_ratio = rows[curr].values[i].wid/rows[curr].values[i].hgt;
         }
         
         if (dist_to_one(rows[curr].values[i].aspect_ratio) > dist_to_one(worst_ratio)) {
             worst_ratio = rows[curr].values[i].aspect_ratio;
         }
      } 
      
      if (rows[curr].horizontal == false) {
          rows[curr].wid = node.wid;
      } else {
          rows[curr].hgt = node.hgt;
      }
      
      rows[curr].worst_aspect = worst_ratio;
      rows[curr].values = (Canvas[])append(rows[curr].values, node);
      rows[curr].total_value = rows[curr].total_value + node.total_value;
  } 
  
  float dist_to_one(float ratio) {
       float distance = 1 - ratio;
       if (distance >= 0) {
           return distance;
       } else {
           return -distance;
       }
  }
  
  void draw_rows(int level) {
      float curr_x, curr_y;
      
      for(int i = 0; i < rows.length; i++) {
          curr_x = rows[i].x;
          curr_y = rows[i].y;
          for(int k = 0; k < rows[i].values.length; k++) {
              int cushion = 3*(level+1);
              float w = rows[i].values[k].wid - (2*cushion);
              float h = rows[i].values[k].hgt - (2*cushion);
              if (w < 0) { w = 0; }
              if (h < 0) { h = 0; }
              
              if(rows[i].values[k].intersection == true && rows[i].values[k].is_leaf == true) {
                  fill(255, 0, 0);
                  print("intersecting with: ");
                  print(rows[i].values[k].id);
                  print("/n");
              } else {
                  fill(200, 200, 200); 
              }
              rect(curr_x + cushion, curr_y + cushion, w, h);
              fill(0,0,0);
              textSize(10);
              textAlign(CENTER, CENTER);
              text(rows[i].values[k].id, curr_x+(rows[i].values[k].wid/2), curr_y+(rows[i].values[k].hgt/2));
              if (rows[i].horizontal == false) {
                  rows[i].values[k].x = curr_x;
                  rows[i].values[k].y = curr_y;
                  curr_y = curr_y + rows[i].values[k].hgt;
              } else {
                  rows[i].values[k].x = curr_x;
                  rows[i].values[k].y = curr_y;
                  curr_x = curr_x + rows[i].values[k].wid;
              }
          }
      }
  }
}
