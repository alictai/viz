int screenWidth = 800;
int screenHeight = 600;
XML xml;

void setup() {
  size(screenWidth, screenHeight); 
  xml = loadXML("Food_Display_Table.xml");
  //printArray(xml.listChildren());
  XML[] children = xml.getChildren("Food_Display_Row");

  //printArray(children[0].listChildren());

  print(children.length);
  /*for (int i = 0; i < children.length; i++) {
    XML[] kids = children[i].getChildren();
    String name = kids[1].get();
    println(name);
  }*/
}

void draw() {
  background(255, 255, 255); 
}
