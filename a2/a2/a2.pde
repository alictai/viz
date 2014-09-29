int screenWidth = 600;
int screenHeight = 800;
String curr_chart;

Data data;
Button line_button;
Button bar_button;
Button pie_button;
Line_Graph line;

void setup() {
   size(screenWidth, screenHeight);
   background(255, 255, 255);
   data = new Data();
   data.parse("Dataset2.csv");
   if (frame!=null) { frame.setResizable(true); }
   buttons_set();
   curr_chart = "Line Graph";
   line = new Line_Graph(data);
}

void draw() {
    background(255, 255, 255);
    draw_buttons();
    
    if (curr_chart == "Line Graph") {
        line.draw_graph();
    } else if (curr_chart == "Bar Chart") {
        print("bar chart!\n");
    } else if (curr_chart == "Pie Chart") {
        print("pie chart!\n");
    }
}

void mouseClicked() {
    check_button();
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
        curr_chart = "Line Graph";
        bar_button.set_default();
        pie_button.set_default();
    } else {
        clicked = bar_button.intersect(mouseX, mouseY);
        if (clicked == true) {
            curr_chart = "Bar Chart";
            line_button.set_default();
            pie_button.set_default();
        } else {
            clicked = pie_button.intersect(mouseX, mouseY);
            if (clicked == true) {
                  curr_chart = "Pie Chart";
                  line_button.set_default();
                  bar_button.set_default();
            }
        }
    } 
}
