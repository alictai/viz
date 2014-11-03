class ForceParse {
  ForceNode[] nodes;
  ForceRels[] relations;
  Data data;
  int f_place;
  int ult_root;
  int fixed_mass;

  ForceParse(Data d) {       
    nodes = new ForceNode[0];
    relations = new ForceRels[0];
    data = d;
    fixed_mass = 10;

    find_rels();
    find_nodes();
    change_lengths();
    //attach_nodes();

    print_rels();
  }

  void find_nodes() {
    ForceNode temp1, temp2;
    for (int i = 0; i < relations.length; i++) {
      int exists_index = node_exists(relations[i].node1);
      if (exists_index == -1) {
        temp1 = new ForceNode(relations[i].node1, fixed_mass);
        nodes = (ForceNode[])append(nodes, temp1);
      } else {
        temp1 = nodes[exists_index];
      }

      exists_index = node_exists(relations[i].node2);
      if (exists_index == -1) {
        temp2 = new ForceNode(relations[i].node2, fixed_mass);
        nodes = (ForceNode[])append(nodes, temp2);
      } else {
        temp2 = nodes[exists_index];
      }

      relations[i].update_curr(temp1.x, temp1.y, temp2.x, temp2.y);
    }
  }

  void find_rels() { 
    for (int i = 0; i < data.events.length; i++) {
      int exists_index = rel_exists(data.events[i]);
      if (exists_index != -1) {
        relations[exists_index].targ_edge += 1;
      } else {
        ForceRels temp = new ForceRels();
        temp.node1 = data.events[i].src_ip;
        temp.node2 = data.events[i].dest_ip;
        temp.targ_edge = 1;
        relations = (ForceRels[])append(relations, temp);
      }
    }
  }

  int rel_exists(Event event) {
    for (int i = 0; i <  relations.length; i++) {
      if (relations[i].node1.equals(event.src_ip)) {
        if (relations[i].node2.equals(event.dest_ip)) {
          return i;
        }
      }
    }
    return -1;
  }

  int node_exists(String node_ip) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id.equals(node_ip)) {
        return i;
      }
    }
    return -1;
  }

  ForceNode lookup(String id) {
    ForceNode toret = null;
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == id) {
        toret = nodes[i];
      }
    }
    return toret;
  }
  
  void change_lengths() {
      //find max
      float max = 0;
      for(int i = 0; i < relations.length; i++) {
         if (relations[i].targ_edge > max) { max = relations[i].targ_edge; }
      }
      //find min
      float min = max;
      for(int j = 0; j < relations.length; j++) {
         if (relations[j].targ_edge < min) { min = relations[j].targ_edge; }
      }
      
      for(int k = 0; k < relations.length; k ++) {
         relations[k].targ_edge = map(relations[k].targ_edge, min, max, 0, 100); 
         //print(relations[k].targ_edge, "\n");
      }
      
  }
  /*  
   void attach_nodes() {
   for (int i = 0; i < relations.length; i++) {
   for (int j = 0; j < nodes.length; j++) {
   if (relations[i].node1 == nodes[j].id) {
   relations[i].node1 = nodes[j].id;
   }
   if (relations[i].node2 == nodes[j].id) {
   relations[i].node2 = nodes[j];
   }
   }
   }
   }
   
   */
  void print_rels() {
    for (int i = 0; i < relations.length; i++) {
      print("REL ", i, ": node1 = ", relations[i].node1, "node2 = ", relations[i].node2, "edge = ", relations[i].targ_edge, "\n");
    }
    for (int i = 0; i < nodes.length; i++) {
      print("NODE ", i, " = ", nodes[i].id, "\n");
    }
  }
}

