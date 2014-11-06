Data data;
Para_Coord graph;
int screenWidth = 800;
int screenHeight = 800;

void setup() {
  size(screenWidth, screenHeight);
  if (frame != null) {
    frame.setResizable(true);
  }

  data = new Data();
  data.parse("iris.csv");
  graph = new Para_Coord(data);
}

void draw() {
  background(255, 255, 255);
  graph.draw_graph(0, 0, width, height);
}

void mouseClicked() {
  graph.col_change(mouseX);
}

void mouseMoved() {
  graph.hover(mouseX); 
}

void keyPressed() {
  if(key == CODED) {
    if (keyCode == UP) {
      graph.view_bezier();
    } else if (keyCode == DOWN) {
      print("your mouse is at ", mouseX,", ", mouseY,"\n"); 
    }
  }
}

void keyReleased() {
  if(key == CODED) {
    if (keyCode == UP) {
      graph.view_line();
    }
  }
}
