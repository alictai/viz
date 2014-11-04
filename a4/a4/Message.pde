class Message {
  boolean empty;
  float[] time;
  String[] src_ip;
  String[] src_port;
  String[] dest_ip;
  String[] dest_port;
  String[] priority;
  String[] operation;
  String[] protocol; 


  Message() {
  	empty = true;
    time = new float[0];
    src_ip = new String[0];
    src_port = new String[0];
    dest_ip = new String[0];
    dest_port = new String[0];
    priority = new String[0];
    operation = new String[0];
    protocol = new String[0];
  }

  void add_time(float val) { time = append(time, val); }
  void add_src_ip(String val) { src_ip = append(src_ip, val); }
  void add_src_port (String val) { src_port = append(src_port, val); }
  void add_dest_ip (String val) { dest_ip = append(dest_ip, val); }
  void add_dest_port(String val) { dest_port = append(dest_port, val); }
  void add_priority (String val) { priority = append(priority, val); }
  void add_operation (String val) { operation = append(operation, val); }
  void add_protocol (String val) { protocol = append(protocol, val); }

  int in_dest_port(String port) {
    for (int i = 0; i < dest_port.length; i++) {
      if (port.equals(dest_port[i])) {
        return i;
      }
    }
    return -1;
  }

  int in_time(float t) {
    for (int i = 0; i < time.length; i++) {
      if (t == time[i]) {
        return i;
      }
    }
    return -1;
  }
}