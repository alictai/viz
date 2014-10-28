class Heatmap {
   float time_min, time_max;
   float time_interval;
   int num_intervals;
   int num_ports;
   Data data;
   int[][] hmap;
   String[] ports;
  
  Heatmap(Data parsed) {
     data = parsed;
     time_min = 100000;
     time_max = 0;
     time_interval = 0;
     num_intervals = 30;
     ports = new String[0];
     find_timebounds();
     time_interval = (time_max - time_min)/num_intervals;
     find_num_ports();
     hmap = new int[ports.length][num_intervals];
     print("time_min = ", time_min, " time max: ", time_max, " time interval: ", time_interval,"\n");
    
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
  
  void convert_time(float total) {
     float hour, minutes, seconds;
   
     hour = floor(total/3600);
     minutes = floor(total%3600/60);
     seconds = floor((total/3600)/60);
   
     print(hour, " ", minutes, " ", seconds, " ", total);
  }
  
  void find_num_ports () {
      for (int i = 0; i < data.events.length; i++) {
          if (find_port(data.events[i].dest_port) == -1) {
              ports = append(ports, data.events[i].dest_port);
          }
      }
      
      print("num ports", ports.length, "\n");
  }
 
  int find_port(String curr) {
     for (int i = 0; i < ports.length; i++) {
        if (curr.equals(ports[i])) {
           return i; 
        }
     }
     print(curr, "\n");
     
     return -1; 
  }
  
  void fill_hmap() {
      for (int i = 0; i < data.events.length; i++) {
        
        //hmap[find_port(data.events[i].dest_port)][which_interval(data.events[i].time))]++;  
      }
  }
  
  int which_interval(float curr) {
     return ((curr - time_min)/time_interval);
  }
  
}



