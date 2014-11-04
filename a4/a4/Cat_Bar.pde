class Cat_Bar {
  String title;
  Event[] data_big;
  String[] data;
  int num_points;
  int index_key;

  float xl, xr;
  float yt, yb;
  float wid, hgt;
  
  int num_fields;
  String[] fields;

  Cat_Bar(Event[] parsed, String category, int _key) {
    xl = 0;
    xr = 0;
    yt = 0;
    yb = 0;
    wid = 0;
    hgt = 0;
    
    data_big = parsed;
    title = category;
    index_key = _key;
    
    num_points = data_big.length;
    data = new String[num_points];
    extract_data();
    
    num_fields = 0;
    fields = new String[0];
    find_fields();
  }

  void extract_data() {
    switch(index_key) {
    case 5: //Syslog priority
      for (int i = 0; i < num_points; i++) {
        data[i] = data_big[i].priority;
      }
      break;
    case 6: //Operation
      for (int i = 0; i < num_points; i++) {
        data[i] = data_big[i].operation;
      }
      break;
    case 7: //Protocol
      for (int i = 0; i < num_points; i++) {
        data[i] = data_big[i].protocol;
      }
      break;
    default:
      print("ERROR: Data headings not in expected format");
    }
  }
  
  void find_fields() {
    for(int i = 0; i < num_points; i++) {
      if(!member(data[i], fields)) {
        fields = append(fields, data[i]);
        num_fields++;
      }
    }
  }
  
  boolean member(String data, String[] array) {
    for(int i = 0; i < array.length; i++) {
      if(data.equals(array[i])) {
         return true;
      }
    } 
    return false;
  }

  void draw_graph(float xl, float xr, float yt, float yb) {
    make_canvas(xl, xr, yt, yb); 
    print_header();
    draw_bars();
  }

  void make_canvas(float _xl, float _xr, float _yt, float _yb) {
    yt = _yt;
    yb = _yb;
    xl = _xl;
    xr = _xr;

    wid = xr - xl;
    hgt = yb - yt;
  }
  
  void print_header() {
    textSize(10);
    fill(200, 0, 0);
    text(title, ((xl + xr) / 2), (yt - 12));
  }

  void print_data() {
    print(title, '\n');
    printArray(data);
  }


  void draw_bars() {
    float run_top = yt;
    float temp_h = 0;
    
    for(int i = 0; i < num_fields; i++) {
      if(num_fields == 1) {
        fill(0, 195, 255);
      } else {
        fill(map(i, 0, num_fields - 1, 0, 255), map(i, 0, num_fields - 1, 195, 0), map(i, 0, num_fields - 1, 255, 0));
      }
      float percent = (count_occurrence(fields[i], data) / num_points);    
      
      temp_h = percent * hgt;
      rect(xl, run_top, wid, temp_h);
      
      //draw message rectangle on top
      //  go through data_big, maybe use index_key
      
      fill(0, 0, 0);
      text(fields[i], (xl + xr) / 2, run_top + (temp_h / 2));
      
      run_top += temp_h;   
    }
  }

  float count_occurrence(String s, String[] array) {
    float count = 0;
    for(int i = 0; i < num_points; i++) {
      if(s.equals(array[i])) {count++;}
    } 
    
    return count;
  }

}

