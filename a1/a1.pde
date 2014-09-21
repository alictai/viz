int screenWidth = 1200;
int screenHeight = 800;

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

void mouseClicked() {
   //use for zoom in and zoom out 
}

void mouseMoved() {
   root.intersect(mouseX, mouseY);
}
