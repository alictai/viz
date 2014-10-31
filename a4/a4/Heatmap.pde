class Heatmap {
  float time_min, time_max;
  float time_interval;
  int num_intervals;
  Data data;
  int[][] hmap;
  String[] ports;
  float[] intervals;
  int canvas_w, canvas_h;
  int interval_w, interval_h;
  int min_val, max_val;
  int buffer_w, buffer_h;

  Heatmap(Data parsed) {
    data = parsed;
    time_min = 100000;
    time_max = 0;
    time_interval = 0;
    num_intervals = 30;
    ports = new String[0];
    intervals = new float[num_intervals + 1];
    find_timebounds();
    time_interval = (time_max - time_min)/num_intervals;
    num_intervals++;
    find_num_ports();
    find_intervals();
    hmap = new int[ports.length][num_intervals];
    fill_hmap();
    find_val_bounds();
    //print("time_min = ", time_min, " time max: ", time_max, " time interval: ", time_interval,"\n");
    //print_hmap();
  }

  void find_timebounds() {
    for (int i = 0; i < data.events.length; i++) {
      if (data.events[i].time < time_min) {
        time_min = data.events[i].time;
      } 
      if (data.events[i].time > time_max) {
        time_max = data.events[i].time;
      }
    }
  }

  void find_num_ports() {
    for (int i = 0; i < data.events.length; i++) {
      if (find_port(data.events[i].dest_port) == -1) {
        ports = append(ports, data.events[i].dest_port);
      }
    }
  }
  
  void find_intervals() {
    float curr_time = time_min;
    
    for (int i = 0; i < num_intervals; i++) {
      intervals[i] = curr_time;
      curr_time += time_interval;
    }
  }

  int find_port(String curr) {
    for (int i = 0; i < ports.length; i++) {
      if (curr.equals(ports[i])) {
        return i;
      }
    }
    return -1;
  }

  void fill_hmap() {
    for (int i = 0; i < data.events.length; i++) {
      hmap[find_port(data.events[i].dest_port)][which_interval(data.events[i].time)] += 1;
    }
  }

  void find_val_bounds() {
    for (int i = 0; i < ports.length; i++) {
      for (int j = 0; j < num_intervals; j++) {
        if (hmap[i][j] < min_val) {
          min_val = hmap[i][j];
        }
        if (hmap[i][j] > max_val) {
          max_val = hmap[i][j];
        }
      }
    }
  }

  int which_interval(float curr) {
    float difference = curr - time_min;
    return floor(difference/time_interval);
  }

  Message draw_heatmap(int x1, int x2, int y1, int y2, Message message) {
    if(intersect(x1, y1, x2, y2)) {
        message = new Message();
    }
    
    
    buffer_w = 90;
    buffer_h = 50;
    canvas_w = (x2 - x1) - buffer_w;
    canvas_h = (y2 - y1) - buffer_h;

    interval_w = canvas_w/(num_intervals);
    interval_h = canvas_h/(ports.length);

    int curr_x = x1 + buffer_w;
    int curr_y = y1;
    float c;

    draw_axis_labels(x1, x2, y1, y2);

    fill(255);
    stroke(0);
    textAlign(CENTER, CENTER);
    for (int i = 0; i < ports.length; i++) {
      for (int j = 0; j < num_intervals; j++) {
        c = map(hmap[i][j], min_val, max_val, 0, 255);
        
        
        if (intersect(curr_x, curr_y, curr_x + interval_w, curr_y + interval_h)) {
          fill(50, 50, 50);
          message.add_time(intervals[j]);
          message.add_dest_port(ports[i]);
        } else if (message.in_dest_port(ports[i]) && message.in_time(intervals[j])) {
          fill(50, 50, 50);
        } else {
          fill(c, 195 - c, 255 - c);
        }

        rect(curr_x, curr_y, interval_w, interval_h);
        fill(0);
        //text(hmap[i][j], curr_x + interval_w/2, curr_y + interval_h/2);
        curr_x += interval_w;
      }
      curr_y += interval_h;
      curr_x = x1 + buffer_w;
    }
    
    return message;
  }

  boolean intersect(int x1, int y1, int x2, int y2) {
    if ((mouseX > x1 && mouseX < x2) && (mouseY > y1 && mouseY < y2)) {
      return true;
    } else {
      return false;
    }
  }

  void draw_axis_labels(int x1, int x2, int y1, int y2) {
    int curr_x = x1 + buffer_w/3;
    int curr_y = y1;
    float curr_time = time_min;


    textAlign(CENTER, CENTER);
    for (int i = 0; i < ports.length; i++) {
      fill(0);
      text(ports[i], curr_x + interval_w/2, curr_y + interval_h/2);
      curr_y += interval_h;
    }

    curr_x = buffer_w;

    for (int i = 0; i < num_intervals; i++) {
      curr_time = intervals[i];
      fill(0);
      textSize(10);
      translate(curr_x + interval_w/2, curr_y + buffer_h/2);
      rotate(PI/2);
      text(convert_time(curr_time), 0, 0);
      rotate(-PI/2);
      translate(-(curr_x + interval_w/2), -(curr_y + buffer_h/2));
      curr_x += interval_w;
    }
  }

  String convert_time(float total) {
    int hour, minutes, seconds;

    hour = floor(total/3600);
    minutes = floor(total%3600/60);
    seconds = floor(total%3600)%60;

    String s = str(hour) + ":" + str(minutes) + ":" + str(seconds);

    return s;
  }
  /*  
   void print_hmap() {
   for (int i = 0; i < ports.length; i++) {
   print(ports[i], ": - ");
   for (int j = 0; j < num_intervals; j++) {
   print(hmap[i][j], " ");
   }
   print("\n"); 
   }
   }
   */
}


