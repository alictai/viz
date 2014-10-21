class Rels {
  int node1;
  int node2;
  float rest_edge;
  float act_edge;
  float r_edge_x, r_edge_y;
  float act_edge_x, act_edge_y;
  
  void update_act(float n1x, float n1y, float n2x, float n2y) {
      act_edge_x = abs(n1x - n2x);
      act_edge_y = abs(n1y - n2y);
      act_edge = sqrt((act_edge_x*act_edge_x) + (act_edge_y*act_edge_y));
      update_r();
  }
  
  void update_r() {
    //act_edge should be updated
    if (act_edge_x == 0) {
      r_edge_x = 0;
      r_edge_y = rest_edge;
    } else {
      float theta_rad = atan(act_edge_y / act_edge_x);
      r_edge_x = rest_edge * cos(theta_rad);
      r_edge_y = rest_edge * sin(theta_rad);
    }

    /*if(rest_edge > act_edge) { print("expanding\n"); }
    else if (rest_edge < act_edge) { print("compressing\n"); }
    else { print("SAME!!!!!!!\n"); }
    print("REST: ", rest_edge, "\n");
    print("ACTUAL: ", act_edge, "\n");*/

    
    //print("REST: ", r_edge_x, ", ", r_edge_y, "\n");
    //print("ACTUAL: ", act_edge_x, ", ", act_edge_y, "\n");
  }
}