class PieControl {
  final int NUM_STATEMENTS = 5;
  UserData   data;
  MusicPref[]  statements;
  int statements_x1, statements_x2;
  int statements_y1, statements_y2;
  int statement_yinterval;
  
  PieControl(UserData d) {
    data = d;
    statements_x1 = 20;
    statements_y1 = 500;
    statements_x2 = 120;
    statements_y2 = 600;
    statement_yinterval = 10;
  }
  
  void draw_pies(Range range, String gender) {
     statements = data.get_pie_stats(range, gender);
     print_statements();
  }
  
  void print_statements() {
     int curr_y = statements_y1;
     fill(0);
     stroke(0);
     for (int i = 0; i < NUM_STATEMENTS; i++) {
       text(data.girls[0].music_statements[i], statements_x1, curr_y);
       curr_y += statement_yinterval;
     }
    
  }
  
  
}
