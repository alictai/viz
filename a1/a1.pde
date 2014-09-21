int screenWidth = 600;
int screenHeight = 400;

Parser parser;
Canvas root;
Treemap treemap;

void setup() {
    size(screenWidth, screenHeight);
    if (frame != null) {
      frame.setResizable(true);
    }
  
    parser = new Parser();
    root = parser.parse("hierarchy2.shf");
    treemap = new Treemap(root);
}

void draw() {
    treemap.draw_treemap();
}

