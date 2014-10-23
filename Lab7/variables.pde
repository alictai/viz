float margin = 20;
int pw = -1, ph = -1;

float tipHeight = 10;
float tipWidth = 20;

color labelBackground = color(204,204,204,90);
color pointColor = color(69,117,180,128);
color pointHighLight = color(244,109,67,128);
color selectColor = color(171,217,233,80);

PVector pressPos = null;
int fontSize = 12;
float lineHeight = 10;

String path = "data/iris.csv";

Table data = null;
boolean[] marks = null;
String[] header = null;

Controller contrl = null;