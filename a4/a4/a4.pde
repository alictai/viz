//This is the controller pretty much

int screenWidth = 800;
int screenHeight = 800;
Data data;
Heatmap heatmap;
Message message;
//Cat_View categ;
int heatmap_x1, heatmap_x2;
int heatmap_y1, heatmap_y2;
int cat_x1, cat_x2;
int cat_y1, cat_y2;
Rect[] rect;

void setup() {
   size(screenWidth, screenHeight);
   if (frame != null) {
      frame.setResizable(true);
    }
   data = new Data();
   data.parse("data_aggregate.csv");
   
   heatmap = new Heatmap(data);
   //categ = new Cat_View(data);
   message = new Message();
   rect = new Rect[0];
}

void draw() {
   background(255, 255, 255);
   heatmap_x1 = 0;
   heatmap_x2 = width;
   heatmap_y1 = 2 * height/3;
   heatmap_y2 = height;
   message = heatmap.draw_heatmap(heatmap_x1, heatmap_x2, heatmap_y1, heatmap_y2, message);
   
   cat_x1 = 2 * width/3;
   cat_x2 = width;
   cat_y1 = height/6;
   cat_y2 = 2 * height/3;
   
   fill(0, 0, 0);
   rect(cat_x1, cat_y1, cat_x2 - cat_x1, cat_y2 - cat_y1);
}

void mouseClicked(MouseEvent e) {
   if (e.getButton() == RIGHT) {
     rect = new Rect[0];
   }
}

void mouseDragged(MouseEvent e) {
  
}


