/* TEST - how can we unfix screen dims though? */
int screenWidth = 800;
int screenHeight = 800;
/* END TEST */

Button button;
Data data;
Bar_Graph bar;
Line_Graph line;

void setup() {
    size(screenWidth, screenHeight);
    frame.setResizable(true);
    data = new Data();
    data.parse("lab1-data.csv");
    button = new Button();
    button.add_state("Line Graph", 100, 20, screenWidth-110, 10, color(200, 50, 200));
    button.add_state("Bar Chart", 100, 20, screenWidth-110, 10, color(150, 150, 150));
}

void draw() {
  background(255, 255, 255);
  button.draw_button();
  int curr_state = button.getState();
  
  if (curr_state == 0) {
    fill(0,0,0);
    textAlign(CENTER, CENTER);
    text("totally a line graph. yeah!", 150, 150);
  } else if (curr_state == 1) {
    fill(0,0,0);
    textAlign(CENTER, CENTER);
    text("totally a bar chart. yeah!", 150, 150);
  }
}

void mouseClicked() {
    button.intersect(mouseX, mouseY);
}
