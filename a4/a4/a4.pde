//This is the controller pretty much

int screenWidth = 800;
int screenHeight = 800;
Data data;
Heatmap heatmap;
int heatmap_x1, heatmap_x2;
int heatmap_y1, heatmap_y2;

void setup() {
   size(screenWidth, screenHeight);
   if (frame != null) {
      frame.setResizable(true);
    }
   data = new Data();
   data.parse("data_aggregate.csv");
   
   heatmap = new Heatmap(data);
   
}

void draw() {
   background(255, 255, 255);
   heatmap_x1 = 0;
   heatmap_x2 = width;
   heatmap_y1 = 2 * height/3;
   heatmap_y2 = height;
   heatmap.draw_heatmap(heatmap_x1, heatmap_x2, heatmap_y1, heatmap_y2);
}
