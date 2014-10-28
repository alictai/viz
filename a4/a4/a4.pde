//This is the controller pretty much

Data data;

void setup() {
   data = new Data();
   data.parse("data_aggregate.csv");
}

void draw() {
   background(255, 255, 255);
}
