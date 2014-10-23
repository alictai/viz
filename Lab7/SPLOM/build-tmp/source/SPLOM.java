import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 
import java.lang.Iterable; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SPLOM extends PApplet {

public void setup() {
    size(PApplet.parseInt(displayHeight * 0.925f), PApplet.parseInt(displayHeight * 0.925f)); //, "processing.core.PGraphicsRetina2D");
    background(255, 255, 255);
    initSettings();
    frame.setResizable(true);
    frame.setTitle("SPLOM on - " + path);
}

public void draw() {
    if (isResized()) {
        contrl.setPosition();
    }

    background(255, 255, 255);
    textSize(fontSize);
    textLeading(lineHeight);

    contrl.hover();

    contrl.drawViews();
    contrl.drawSelectedArea();
    contrl.handleSelectedArea();
}

public void initSettings() {
    readData();
    marks = new boolean[data.getRowCount()];
    contrl = new SPLOMController();
    contrl.initViews();
}

public boolean isResized() {
    if (pw != width || ph != height) {
        pw = width;
        ph = height;
        return true;
    }
    return false;
}

public void mouseClicked(MouseEvent e) {
    contrl.cleanSelectedArea();
    pressPos = null;
}

public void mouseDragged(MouseEvent e) {
    if (e.getButton() == RIGHT) {
        contrl.cleanSelectedArea();
        return;
    }
    if (pressPos != null) {
        contrl.setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
    }  
}

public void mousePressed(MouseEvent e) {
    contrl.cleanSelectedArea();
    pressPos = new PVector(mouseX, mouseY);
    contrl.setSelectedArea(pressPos.x, pressPos.y, mouseX, mouseY);
}


public void readData(){
   data = loadTable(path, "header");
   header = data.getColumnTitles();
}

abstract class AbstractView {
    protected float leftX = -1;
    protected float leftY = -1;
    protected float w = -1;
    protected float h = -1;

    protected Controller contrl = null;
    protected String name = null;
    protected Table data = null;
    
    protected boolean[] marks = null;
    protected String[] header = null;

    public abstract void hover();
    public abstract void handleThisArea(Rectangle rect);
    public abstract void display();

    AbstractView() {
    }

    public AbstractView setController(Controller contrl) {
        this.contrl = contrl;
        return this;
    }

    public AbstractView setMarks(boolean[] ms) {
        this.marks = ms;
        return this;
    }

    public AbstractView setName(String name) {
        this.name = name;
        return this;
    }

    public AbstractView setDataSrc(Table t, String[] str, boolean[] marks) {
        this.data = t;
        this.header = str;
        this.marks = marks;
        return this;
    }

    public AbstractView setPosition(float x, float y) {
        this.leftX = x;
        this.leftY = y;
        return this;
    }

    public AbstractView setSize(float w, float h) {
        this.w = w;
        this.h = h;
        return this;
    }

    public void sendMsg(Message msg) {
        if(contrl != null){
            contrl.receiveMsg(msg);
        }
    }
    
    public boolean isOnMe() {
        return mouseX >= leftX && mouseX <= (leftX + w) && mouseY >= leftY && mouseY <= (leftY + h);
    }

    public boolean isIntersected(Rectangle rect1, Rectangle rect2) {
       boolean flag1 = abs(rect2.p2.x + rect2.p1.x - rect1.p2.x - rect1.p1.x) - (rect1.p2.x - rect1.p1.x + rect2.p2.x - rect2.p1.x) <= 0;
       boolean flag2 = abs(rect2.p2.y + rect2.p1.y - rect1.p2.y - rect1.p1.y) - (rect1.p2.y - rect1.p1.y + rect2.p2.y - rect2.p1.y) <= 0;
       return flag1 && flag2;
    }

    public Rectangle getIntersectRegion(Rectangle rect) {
        Rectangle rect2 = new Rectangle(leftX, leftY, leftX + w, leftY + h);
        return getIntersectRegion(rect, rect2);
    }

    private Rectangle getIntersectRegion(Rectangle rect1, Rectangle rect2){
          if(isIntersected(rect1, rect2)){
              float x1 = max(rect1.p1.x, rect2.p1.x);
              float y1 = max(rect1.p1.y, rect2.p1.y);
              float x2 = min(rect1.p2.x, rect2.p2.x);
              float y2 = min(rect1.p2.y, rect2.p2.y);
              return new Rectangle(x1, y1, x2, y2);
          }
          return null;
     }
}
class Condition {
    String col = null;
    String operator = null;
    float value = -1; 

    // create a new Condition object that specifies some data column
    // should have some relationship to some value
    //   col: column name of data the relationship applies to
    //   op: operator (e.g. "<=")
    //   value: value to compare to
    Condition(String col, String op, float value) {
        this.col = col;
        this.operator = op;
        this.value = value;
    }
    
    public String toString() {
        return col + " " + operator + " " + value + " ";
    }
    
    public boolean equals(Condition cond){
        return operator.equals(cond.operator) && 
        value == cond.value && 
        col.equals(cond.col);
    }
}


public boolean checkConditions(Condition[] conds, TableRow row) {
    if(conds == null || row == null){
        return false;
    }
    boolean and = true;
    for (int i = 0; i < conds.length; i++) {
        and = and && checkCondition(conds[i], row);
    }
    return and;
}

public boolean checkCondition(Condition cond, TableRow row) {
    if (cond.operator.equals("=")) { // no need to know col
        float cur = row.getFloat(cond.col);
        return abs(cur - cond.value) < 0.0001f;
    }

    if (cond.operator.equals("<=")) {
        float cur = row.getFloat(cond.col);
        return cur - cond.value <= 0.0001f;
    }

    if (cond.operator.equals(">=")) {
        float cur = row.getFloat(cond.col);
        return cur - cond.value >= -0.0001f;
    }
    return false;
}



abstract class Controller {
    protected ArrayList < AbstractView > vizs = null;
    protected Rectangle selectArea = null;
    protected Message preMsg = null;

    public abstract void receiveMsg(Message msg);
    public abstract void initViews();
    public abstract void setPosition();
    public abstract void handleSelectedArea();

    public void hover() {
        for (AbstractView v: vizs) {
            if (v.isOnMe()) {
                v.hover();
                break;
            }
        }
    }

    public void drawSelectedArea() {
        pushStyle();
        if (selectArea != null) {
            fill(selectColor);
            stroke(selectColor);
            rectMode(CORNER);
            rect(selectArea.p1.x, selectArea.p1.y,
                selectArea.p2.x - selectArea.p1.x, selectArea.p2.y - selectArea.p1.y);

        }
        popStyle();
    }

    public void drawViews() {
        for (AbstractView v: vizs) {
            v.display();
        }
    }

    public void cleanSelectedArea() {
        if (selectArea != null) {
            Message msg = new Message();
            msg.setSource("controller")
                .setAction("clean");
            receiveMsg(msg);
            selectArea = null;
        }
    }

    public void setSelectedArea(float x, float y, float x1, float y1) {
        selectArea = new Rectangle(x, y, x1, y1);
    }

    public void resetMarks() {
        // marks are global
        marks = new boolean[data.getRowCount()];
    }

    public void setMarksOfViews(){
        for (AbstractView abv: vizs) {
            abv.setMarks(marks);
        }
    }
}

class SPLOMController extends Controller {
    SPLOMController() {
        vizs = new ArrayList < AbstractView > ();
        selectArea = null;
    }

    public void initViews() {
        int row = data.getRowCount();
        int col = data.getColumnCount();

        float curX = margin, curY = margin;
        float xSeg = (width - margin * 2) / col;
        float ySeg = (height - margin * 2) / col;

        for (int i = 0; i < col; i++) {
            for (int j = 0; j < col; j++) {
                float[] xArray = data.getFloatColumn(i);
                float[] yArray = data.getFloatColumn(j);

                ScatterplotView spView = new ScatterplotView();
                spView
                    .setController(this)
                    .setName(i + "-" + j)
                    .setPosition(curX + i * xSeg, curY + j * ySeg)
                    .setSize(xSeg, ySeg)
                    .setMarks(marks)
                    ;

                spView.setData(xArray, yArray)
                    .setTitles(header[i], header[j])
                    .setXYIndice(i, j)
                    .initXYRange()
                    ;
              
                vizs.add(spView);
            }
        }
    }

    public void setPosition() {
        int row = data.getRowCount();
        int col = data.getColumnCount();

        float curX = margin, curY = margin;
        float xSeg = (width - margin * 2.0f) / col;
        float ySeg = (height - margin * 2.0f) / col;

        for (int i = 0; i < col; i++) {
            for (int j = 0; j < col; j++) {
                AbstractView spView = vizs.get(i * col + j);
                spView
                    .setPosition(curX + i * xSeg, curY + j * ySeg)
                    .setSize(xSeg, ySeg);
            }
        }
    }

    public void receiveMsg(Message msg) {
        if (msg.equals(preMsg)) {
            return;
        }

        preMsg = msg;

        if (msg.action.equals("clean")) {
            resetMarks();
            return;
        }

        Iterator it = data.rows().iterator();
        int index = 0;
        while (it.hasNext()) {
            if (checkConditions(msg.conds, (TableRow) it.next())) {
                marks[index] = true;
            } 
            index++;
        }
        setMarksOfViews();
    }


    public void handleSelectedArea() {
        Message msg = new Message();
        msg.action = "clean";
        receiveMsg(msg);

        if (selectArea != null) {
            for (AbstractView absv: vizs) {
                absv.handleThisArea(selectArea);
            }
        }
    }
}
class Message {
    String src = null;
    Condition[] conds = null;
    String action = "normal";

    Message() {

    }

    public Message setSource(String str) {
        this.src = str;
        return this;
    }

    public Message setAction(String str) {
        this.action = str;
        return this;
    }

    public Message setConditions(Condition[] conds) {
        this.conds = conds;
        return this;
    }

    public boolean equals(Message msg) {
        if (msg == null) {
            return false;
        }
        if (src == null && msg.src == null) {
            return true;
        }
        if (src == null || msg.src == null) {
            return false;
        }
        if (!src.equals(msg.src)) {
            return false;
        }
        if (conds != null && msg.conds != null) {
            if (conds.length != msg.conds.length) {
                return false;
            }
            for (int i = 0; i < conds.length; i++) {
                if (!conds[i].equals(msg.conds[i])) {
                    return false;
                }
            }
            return true;
        } else {
            if (conds == null && msg.conds == null) {
                return true;
            } else {
                return false;
            }
        }
    }

    public String toString() {
        String str = "";
        for (Condition cond: conds) {
            str += cond.toString();
        }
        return str + "\n\n";
    }
}
class Rectangle { // model dragging area
    PVector p1 = null;
    PVector p2 = null;

    Rectangle(float x1_, float y1_, float x2_, float y2_) {
        float x1 = x1_ < x2_ ? x1_ : x2_;
        float x2 = x1_ >= x2_ ? x1_ : x2_;
        float y1 = y1_ < y2_ ? y1_ : y2_;
        float y2 = y1_ >= y2_ ? y1_ : y2_;
        p1 = new PVector(x1, y1);
        p2 = new PVector(x2, y2);
    }
}
class ScatterplotView extends AbstractView {
    float[] xArray = null;
    float[] yArray = null;
    String xTitle = null;
    String yTitle = null;

    float xMax = -1;
    float yMax = -1;
    float xMin = -1;
    float yMin = -1;

    int xIndex = -1;
    int yIndex = -1;

    // get the radius of points for drawing
    public float getRadius() {
        return w / 70.0f;
    }

    // this deals with selection when items are under the mouse cursor
    public void hover() {
        // create the highlight Conditions to send as a message to all other scatter plots
        // through the Controller using the messages architecture
        // (highlight based on square surrounding the point with width 2*radius)
        Condition cond1 = new Condition(xTitle, "<=", inverseToXReal(mouseX + getRadius()));
        Condition cond2 = new Condition(xTitle, ">=", inverseToXReal(mouseX - getRadius()));
        Condition cond3 = new Condition(yTitle, "<=", inverseToYReal(mouseY - getRadius()));
        Condition cond4 = new Condition(yTitle, ">=", inverseToYReal(mouseY + getRadius()));
        Condition[] conds = new Condition[4];
        conds[0] = cond1;
        conds[1] = cond2;
        conds[2] = cond3;
        conds[3] = cond4;
         
        // Finish this:
        // Send a message to the Controller to provide the current conditions for highlighting
        // 1. create a new message instance (see Message.pde)
        // 2. set the source of this message (see Message.pde)
        // 3. set the conditions of this message (see Message.pde)
        // 4. send the message (see AbstractView.pde) 

        Message msg = new Message();
        msg.setSource(name);
        msg.setConditions(conds);
        sendMsg(msg);
    }

    // handle sending messages to the Controller when a rectangle is selected
    public void handleThisArea(Rectangle rect) {
        // this rectangle holds the _pixel_ coordinates of the selection rectangle 
        Rectangle rectSub = getIntersectRegion(rect);

        if (rectSub != null) {
            //Condition[] conds = null;
            Condition cond1 = new Condition(xTitle, "<=", inverseToXReal(rectSub.p2.x));
            Condition cond2 = new Condition(xTitle, ">=", inverseToXReal(rectSub.p1.x));
            Condition cond3 = new Condition(yTitle, "<=", inverseToYReal(rectSub.p1.y));
            Condition cond4 = new Condition(yTitle, ">=", inverseToYReal(rectSub.p2.y));
            Condition[] conds = new Condition[4];
            conds[0] = cond1;
            conds[1] = cond2;
            conds[2] = cond3;
            conds[3] = cond4;

            //printArray(conds);

            // Finish this:
            // Create the conditions for what points to highlight to send
            // in the message below. (reference Condition.pde, Rectangle.pde,
            // hover function above)
            // The getIntersectRegion() call above gets you the selection rectangle
            // in the current view.
            
            // send out the message
            Message msg = new Message();
            msg.setSource(name)
               .setConditions(conds);
            sendMsg(msg);
        }
    }

    public void display() {
        pushStyle();
        stroke(0);
        strokeWeight(1);
        fill(255);
        rectMode(CORNER);

        rect(leftX, leftY, w, h);

        ellipseMode(CENTER);
        for (int i = 0; i < xArray.length; i++) {
            if (marks[i]) {
                fill(pointHighLight);
            } else {
                fill(pointColor);
            }
            noStroke();
            // draw points
            ellipse(xScale(xArray[i]), yScale(yArray[i]), getRadius() * 2, getRadius() * 2);
        }

        textAlign(CENTER);
        fill(0);
        
        // draw labels
        if(yIndex == 0){
            text(xTitle, leftX + w / 2.0f, leftY - fontSize / 2.0f);
        }

        if(xIndex == 0){
            pushMatrix();
            translate(leftX - fontSize / 2.0f, leftY + w / 2.0f);
            rotate(radians(-90));
            text(yTitle, 0, 0);
            popMatrix();
        }
        popStyle();
    }

    public ScatterplotView setXYIndice(int x, int y) {
        this.xIndex = x;
        this.yIndex = y;
        return this;
    }

    // set the indice of columns that this view can see
    public ScatterplotView setData(float[] xArray, float[] yArray) {
        this.xArray = xArray;
        this.yArray = yArray;
        return this;
    }

    public ScatterplotView setTitles(String xStr, String yStr) {
        this.xTitle = xStr;
        this.yTitle = yStr;
        return this;
    }

    public ScatterplotView initXYRange() {
        xMin = 0;//min(xArray);
        xMax = max(xArray) * 1.2f;
        yMin = 0;//min(yArray);
        yMax = max(yArray) * 1.2f;

        return this;
    }

    public float xScale(float x) {
        return leftX + (x - xMin) / (xMax - xMin) * w;
    }

    public float yScale(float y) {
        return leftY + h - ((y - yMin) / (yMax - yMin) * h);
    }

    // convert from pixel coordinates to data coordinates
    public float inverseToXReal(float px) {
        return (px - leftX) / w * (xMax - xMin) + xMin;
    }

    // convert from pixel coordinates to data coordinates
    public float inverseToYReal(float py) {
        return (h - (py - leftY)) / h * (yMax - yMin) + yMin;
    }


}
float margin = 20;
int pw = -1, ph = -1;

float tipHeight = 10;
float tipWidth = 20;

int labelBackground = color(204,204,204,90);
int pointColor = color(69,117,180,128);
int pointHighLight = color(244,109,67,128);
int selectColor = color(171,217,233,80);

PVector pressPos = null;
int fontSize = 12;
float lineHeight = 10;

String path = "data/iris.csv";

Table data = null;
boolean[] marks = null;
String[] header = null;

Controller contrl = null;
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SPLOM" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
