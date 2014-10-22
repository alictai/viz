class Rels {
  int node1;
  int node2;
  float targ_edge;
  float curr_edge;
  float targ_edge_x, targ_edge_y;
  float curr_edge_x, curr_edge_y;
  boolean compressed;
  
  void update_curr(float n1x, float n1y, float n2x, float n2y) {
      curr_edge_x = abs(n1x - n2x);
      curr_edge_y = abs(n1y - n2y);
      curr_edge = sqrt((curr_edge_x*curr_edge_x) + (curr_edge_y*curr_edge_y));
      update_targ();
  }
  
  void update_targ() {
    //curr_edge should be updated
    compressed = (curr_edge < targ_edge);

    if (curr_edge_x == 0) {
      targ_edge_x = 0;
      targ_edge_y = targ_edge;
    } else {
      float theta_rad = atan(curr_edge_y / curr_edge_x);
      targ_edge_x = targ_edge * cos(theta_rad);
      targ_edge_y = targ_edge * sin(theta_rad);
      //print("theta: ", (180 / PI) * theta_rad, "\n");
    }

    //print("targ:  x-", targ_edge_x, " y-", targ_edge_y, " tot-", targ_edge, "\n");
    //print("curr: x-", curr_edge_x, " y-", curr_edge_y, " tot-", curr_edge, "\n");

    /*if(rest_edge > curr_edge) { print("expanding\n"); }
    else if (rest_edge < curr_edge) { print("compressing\n"); }
    else { print("SAME!!!!!!!\n"); }
    print("REST: ", rest_edge, "\n");
    print("currUAL: ", curr_edge, "\n");*/

    
    //print("REST: ", r_edge_x, ", ", r_edge_y, "\n");
    //print("currUAL: ", curr_edge_x, ", ", curr_edge_y, "\n");
  }
}
