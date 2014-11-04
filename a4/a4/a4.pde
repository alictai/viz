//This is the controller pretty much

int screenWidth = 800;
int screenHeight = 800;
Data data;
Heatmap heatmap;
Message message;
Cat_View categ;
ForceGraph graph;
int heatmap_x1, heatmap_x2;
int heatmap_y1, heatmap_y2;
int cat_x1, cat_x2;
int cat_y1, cat_y2;
int graph_x1, graph_x2;
int graph_y1, graph_y2;
int press_x, press_y;
Rect[] rects;
Rect curr;

void setup() {
  size(screenWidth, screenHeight);
  if (frame != null) {
    frame.setResizable(true);
  }
  data = new Data();
  data.parse("data_aggregate.csv");

  graph_x1 = 0;
  graph_x2 = 2 * width/3 - 20;
  graph_y1 = 0;
  graph_y2 = 2 * height/3 - 75;

  graph = new ForceGraph(data, graph_x2 - graph_x1, graph_y2 - graph_y1);
  heatmap = new Heatmap(data);
  categ = new Cat_View(data);
  message = new Message();
  rects = new Rect[0];
  press_x = -1;
  press_y = -1;
}

void draw() {
  background(255, 255, 255);

  heatmap_x1 = 0;
  heatmap_x2 = width;
  heatmap_y1 = 2 * height/3;
  heatmap_y2 = height;

  cat_x1 = 2 * width/3;
  cat_x2 = width;
  cat_y1 = height/6;
  cat_y2 = 2 * height/3;

  graph_x1 = 0;
  graph_x2 = 2 * width/3;
  graph_y1 = 0;
  graph_y2 = 2 * height/3;
  graph.calc_forces();

  message = heatmap.draw_heatmap(heatmap_x1, heatmap_x2, heatmap_y1, heatmap_y2, message, rects);
  message = graph.draw_graph(graph_x1, graph_x2, graph_y1, graph_y2, message, rects);
  //fill(0, 0, 0);
  message = categ.draw_cat_view(cat_x1, cat_x2, cat_y1, cat_y2, message, rects);
  
  draw_rects();
}

void mouseMoved() {
  graph.intersect(mouseX, mouseY);
}

void mouseClicked(MouseEvent e) {
  if (e.getButton() == RIGHT) {
    rects = new Rect[0];
    message = new Message();
  }
}

void mousePressed(MouseEvent e) {
  if (e.getButton() == RIGHT) {
    rects = new Rect[0];
    message = new Message();
  }
  press_x = mouseX;
  press_y = mouseY;

  curr = new Rect(press_x, mouseX, press_y, mouseY);
  rects = (Rect[])append(rects, curr);
}

void mouseDragged(MouseEvent e) {
  if (e.getButton() == RIGHT) {
    rects = new Rect[0];
    message = new Message();
    return;
  }

  if ((press_x != -1) && (press_y != -1)) {
    curr.set_dim(press_x, mouseX, press_y, mouseY);
  }

  //graph.drag(mouseX, mouseY);
}

void draw_rects() {
  for (int i = 0; i < rects.length; i++) {
    rects[i].draw_rect();
  }
}

