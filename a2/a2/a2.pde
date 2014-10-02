//pie & line - Ali
//pie & bar - Matt
//bar & line - Kirk

int screenWidth = 600;
int screenHeight = 800;
String curr_chart;
String next_chart;
Data data;
Button line_button;
Button bar_button;
Button pie_button;
Line_Graph line;
Bar_Graph bar;
Pie_Chart pie;
boolean half_complete;
boolean line_to_bar;

void setup() {
   size(screenWidth, screenHeight);
   background(255, 255, 255);
   data = new Data();
   data.parse("Dataset2.csv");
   if (frame!=null) { frame.setResizable(true); }
   buttons_set();
   curr_chart = "Line Graph";
   next_chart = "Line Graph";
   line = new Line_Graph(data);
   bar = new Bar_Graph(data);
   pie = new Pie_Chart(data);
   half_complete = false;
   line_to_bar = false;
}

void draw() {
    background(255, 255, 255);
    draw_buttons();
    
    if (curr_chart != next_chart) {
        draw_transition();
    } else {
        if (curr_chart == "Line Graph") {
            line.draw_graph();
        } else if (curr_chart == "Bar Chart") {
            bar.draw_graph();
        } else if (curr_chart == "Pie Chart") {
            pie.draw_graph();
        }
    }
}

void mouseClicked() {
    check_button();
}

void draw_transition() {
    //REMEMBER TO REMOVE CURR_CHART = NEXT_CHART <-- JUST FOR RUNNING CODE
    if (curr_chart == "Line Graph") {
        if (next_chart == "Bar Chart") {
            //print("line to bar\n");
            line_to_bar();
            //curr_chart = next_chart;
        } else if (next_chart == "Pie Chart") {
            print ("line to pie\n");
            curr_chart = next_chart;
        }
    } else if (curr_chart == "Bar Chart") {
        if (next_chart == "Line Graph") {
            print("bar to line\n");
            bar_to_line();
            //curr_chart = next_chart;
        } else if (next_chart == "Pie Chart") {
            print("bar to pie\n");
            curr_chart = next_chart;
        }
    } else if (curr_chart == "Pie Chart") {
        if (next_chart == "Line Graph") {
             print("pie to line\n");
             curr_chart = next_chart;
        } else if (next_chart == "Bar Chart") {
             print ("pie to bar\n");
             curr_chart = next_chart;
        } 
    }
}

void line_to_bar() {
    if (half_complete == false) {
       half_complete = line.line_to_bar();
    } else {
       half_complete = bar.line_to_bar();
        if (half_complete == false) {
            print("transition complete\n");
            curr_chart = next_chart;
        }
    }
}

//need to finish this transition
void bar_to_line() {
    if (half_complete == false) {
        print("half complete is false, calling bar to line\n");
       half_complete = bar.bar_to_line();
    } else {
      print("half complete is true, calling bar to line\n");
       //half_complete = line.bar_to_line();
       
       //REMOVE - for testing only
       half_complete = false; 
       // ********
        if (half_complete == false) {
             print("transition complete\n");
            curr_chart = next_chart;
        }
    }
    
}

void draw_buttons() {
    line_button.draw_button(width/4, height-30);
    bar_button.draw_button(width/2, height-30);
    pie_button.draw_button(3*width/4, height-30);
}

void buttons_set() {
    line_button = new Button();
    line_button.add_state("Line Graph", 100, 20, width/4, height-30, color(100, 100, 100));
    line_button.add_state("Line Graph", 100, 20, width/4, height-30, color(200, 200, 255));
    line_button.update();
    
    bar_button = new Button();
    bar_button.add_state("Bar Chart", 100, 20, width/2, height-30, color(100, 100, 100));
    bar_button.add_state("Bar Chart", 100, 20, width/2, height-30, color(200, 200, 255));
     
    pie_button = new Button();
    pie_button.add_state("Pie Chart", 100, 20, 3*width/4, height-30, color(100, 100, 100));
    pie_button.add_state("Pie Chart", 100, 20, 3*width/4, height-30, color(200, 200, 255));
}

void check_button() {
    boolean clicked;
    
    clicked = line_button.intersect(mouseX, mouseY);
    if (clicked == true) {
        next_chart = "Line Graph";
        //curr_chart = "Line Graph";
        bar_button.set_default();
        pie_button.set_default();
    } else {
        clicked = bar_button.intersect(mouseX, mouseY);
        if (clicked == true) {
            next_chart = "Bar Chart";
            line_button.set_default();
            pie_button.set_default();
        } else {
            clicked = pie_button.intersect(mouseX, mouseY);
            if (clicked == true) {
                  next_chart = "Pie Chart";
                  line_button.set_default();
                  bar_button.set_default();
            }
        }
    } 
}
