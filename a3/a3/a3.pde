int screenWidth = 400;
int screenHeight = 400;

Parser parser;
Node root;
Graph graph;

void setup() {
    // PUT INPUT FILE NAME HERE
    String file = "data3.csv";
    
    size(screenWidth, screenHeight);
    if (frame != null) {
      frame.setResizable(true);
    }
  
    parser = new Parser();
    graph = parser.parse(file);
}

void draw() {
    background(255);
    graph.calc_forces();
    graph.draw_graph();
}


