void setup() {
    size(800, 600);

    //Parse data
    Data data = new Data();
    data.parse("spongebob.csv");
    
    //line = new Line_Graph(data);
}

void draw() {
  rect(10, 10, 10, 10);
}
