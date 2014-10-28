//This is the controller pretty much

Data data;
Heatmap heatmap;

void setup() {
   data = new Data();
   data.parse("data_aggregate.csv");
   heatmap = new Heatmap(data);
}

void draw() {
   background(255, 255, 255);
}
