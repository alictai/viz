int screenWidth = 600;
int screenHeight = 800;
String curr_chart;
String next_chart;
Data data;
//Button line_button;
//Button bar_button;
//Button pie_button;
//Line_Graph line;
//Bar_Graph bar;
//Pie_Chart pie;
Stacked_Bar stack;
Theme_River triver;
boolean half_complete;
boolean line_to_bar;

void setup() {
   size(screenWidth, screenHeight);
   background(255, 255, 255);
   data = new Data();
   data.parse("Dataset2.csv");
   if (frame!=null) { frame.setResizable(true); }
   curr_chart = "Line Graph";
   next_chart = "Line Graph";
   stack = new Stacked_Bar(data);
   triver = new Theme_River(data);
   half_complete = false;
   line_to_bar = false;
}

void draw() {
    background(255, 255, 255);
    stack.draw_graph();
    //triver.draw_graph();
}

