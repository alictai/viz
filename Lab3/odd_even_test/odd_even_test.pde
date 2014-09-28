int numPoints = 20;
Point[] shape;

Point endP;

void setup() {
    size(400, 400);
    smooth();
    shape = new Point[numPoints];
    endP = new Point();

    makeRandomShape();

    frame.setResizable(true);
}

void draw() {
    background(255, 255, 255);
    stroke(0, 0, 0);

    drawShape();
    if (mousePressed == true) {
        stroke(255, 0, 0);
        line(mouseX, mouseY, endP.x, endP.y);

        fill(0, 0, 0);
        boolean isect = isectTest();
        if (isect == true) {
            text("Inside", mouseX, mouseY);
        } else {
            text("Outside", mouseX, mouseY);
        }
    }
}

void mousePressed() {
    endP.x = random(-1, 1) * 2 * width;
    endP.y = random(-1, 1) * 2 * height;
}

void drawShape() {
    for (int i = 0; i < numPoints; i++) {
        int start = i;
        int end = (i + 1) % numPoints;

        line(shape[start].x + width/2.0f, 
             shape[start].y + height/2.0f,
             shape[end].x + width/2.0f, 
             shape[end].y + height/2.0f);
    }
}

boolean isectTest() {
  //something like translate(width/2, height/2);
  int num_intersects = 0;
  Point a, b, c;
  c = new Point();
  /* Subtract w/2 and h/2 because does_intersect thinks         */
  /* the shape is centered in the top-left corner of the screen */
  c.x = mouseX - width/2;
  c.y = mouseY - height/2;
  
  for(int i = 0; i < shape.length; i++) {
    a = shape[i];
    b = shape[(i + 1) % shape.length];
    /* Debugging statements */
    //fill(255, 0, 0);
    //line(a.x, a.y, b.x, b.y);
    /*                      */
    if(does_intersect(a, b, c, endP)) {
      num_intersects++;
    }
  }
  if (num_intersects % 2 == 1) {
    return true;
  } else {
    return false;
  }
}

boolean does_intersect(Point p2, Point q2, Point p1, Point q1) {
 //our line is mouseX, mouseY, endP.x, endP.y
 //their line is a.x, a.y, b.x, b.y
 //do math to see if they intersect
  
  float a1 = p1.y - q1.y;
  float b1 = q1.x - p1.x;
  float c1 = q1.x * p1.y - p1.x * q1.y;
  
  float a2 = p2.y - q2.y;
  float b2 = q2.x - p2.x;
  float c2 = q2.x * p2.y - p2.x * q2.y;
 
  float det = a1 * b2 - a2 * b1;

   if (isBetween(det, -.0000001, .0000001)) {
     return false;
   } else {
     float isectx = (b2 * c1 - b1 * c2) / det;
     float isecty = (a1 * c2 - a2 * c1) / det;
     
     if ((isBetween(isecty, p1.y, q1.y) == true) &&
         (isBetween(isecty, p2.y, q2.y) == true) &&
         (isBetween(isectx, p1.x, q1.x) == true) &&
         (isBetween(isectx, p2.x, q2.x) == true)) {
           return true;
         }
   }
   
   return false;
 
}


boolean same_sign(float a, float b){

  return (( a * b) >= 0);
}

boolean isBetween(float val, float range1, float range2) {
    float largeNum = range1;
    float smallNum = range2;
    if (smallNum > largeNum) {
        largeNum = range2;
        smallNum = range1;
    }

    if ((val < largeNum) && (val > smallNum)) {
        return true;
    }
    return false;
}

void makeRandomShape() {
    float slice = 360.0 / (float) numPoints;
    for (int i = 0; i < numPoints; i++) {
        float radius = (float) random(5, 100);
        shape[i] = new Point();
        shape[i].x = radius * cos(radians(slice * i));
        shape[i].y = radius * sin(radians(slice * i));
    }
}
