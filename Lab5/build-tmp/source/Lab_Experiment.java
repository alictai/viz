import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Lab_Experiment extends PApplet {



final int DECIDE_YOURSELF = -1;

/**
 * this should be the global variable, the dataset in your visualization
 */
Data d = null;

public void setup() {
    totalWidth = displayWidth;
    totalHeight = displayHeight;
    chartLeftX = totalWidth / 2.0f - chartSize / 2.0f;
    chartLeftY = totalHeight / 2.0f - chartSize / 2.0f - margin_top;

    size((int) totalWidth, (int) totalHeight);
    //if you use a Retina displayer, please use the line below (better looklike)
    //size((int) totalWidth, (int) totalHeight, "processing.core.PGraphicsRetina2D");

    background(255);
    frame.setTitle("Comp150-07 Visualization, Lab 5, Experiment");

    cp5 = new ControlP5(this);
    pfont = createFont("arial", fontSize, true); 
    textFont(pfont);
    page1 = true;

    /**
     ** finish this: decide how to control dataset you are using
     **/
    d = null;

    /**
     ** finish this: how to control the id of the partipant
     **/
    partipantID = DECIDE_YOURSELF;
}

public void draw() {
    textSize(fontSize);
    /**
     ** add more: you may need to draw more stuff on your screen
     **/
    if (index < 0 && page1) {
        drawIntro();
        page1 = false;
    } else if (index >= 0 && index < vis.length) {
        if (index == 0 && page2) {
            clearIntro();
            drawTextField();
            drawInstruction();
            page2 = false;
        }

        /**
         **  finish this: decide the chart type
         **/
        int chartType = DECIDE_YOURSELF;

        switch (chartType) {
            case DECIDE_YOURSELF:
                 stroke(0);
                 strokeWeight(1);
                 fill(255);
                 rectMode(CORNER);
                 /*
                  * all your charts must be inside this rectangle
                  */
                 rect(chartLeftX, chartLeftY, chartSize, chartSize);
                 break;
            case 0:
                /**
                 ** finish this: 1st visualization
                 **/
                break;
            case 1:
                /**
                 ** finish this: 2nd visualization
                 **/
                break;
            case 2:
                /**
                 ** finish this: 3rd visualization
                 **/
                break;
            case 3:
                /**
                 ** finish this: 4th visualization
                 **/
                break;
            case 4:
                /**
                 ** finish this: 5th visualization
                 **/
                break;
        }

        drawWarning();

    } else if (index > vis.length - 1 && pagelast) {
        drawThanks();
        drawClose();
        pagelast = false;
    }
}

/**
 * This method is called when the participant clicked the "NEXT" button.
 */
public void next() {
    String str = cp5.get(Textfield.class, "answer").getText().trim();
    float num = parseFloat(str);
    /*
     * We check the input for you.
     */
    if (!(num >= 0)) {
        warning = "Please input a number!";
        if (num < 0) {
            warning = "Please input a non-negative number!";
        }
    } else if (num > 100) {
        warning = "Please input a number between 0 - 100!";
    } else {
        if (index >= 0 && index < vis.length) {
            float ans = parseFloat(cp5.get(Textfield.class, "answer").getText());

            /**
             ** finish this: decide how to compute the right anwer
             **/
            truePerc = DECIDE_YOURSELF;

            reportPerc = ans / 100.0f;
            
            /**
             ** finish this: decide how to compute the log error
             **/
            error = DECIDE_YOURSELF;

            saveJudgement();
        }

        /**
         ** finish this: decide the dataset in the next visualization
         **/
        d = null;

        cp5.get(Textfield.class, "answer").clear();
        index++;

        if (index == vis.length - 1) {
            pagelast = true;
        }
    }
}

/**
 * This method is called when the participant clicked "CLOSE" button on the "Thanks" page.
 */
public void close() {
    /**
     ** Change this if you need 
     **/
    saveExpData();
    exit();
}

/**
 * Calling this method will set everything to the intro page
 */
public void reset(){
    /**
     ** Finish/Use/Change this method if you need 
     **/
    partipantID = DECIDE_YOURSELF;
    d = null;

    /**
     ** Don't worry about the code below
     **/
    background(255);
    cp5.get("close").remove();
    page1 = true;
    page2 = false;
    pagelast = false;
    index = -1;
}
/**
 * These five variables are the data you need to collect from participants.
 */
int partipantID = -1;
int index = -1;
float error = -1;
float truePerc = -1;
float reportPerc = -1;

/**
 * The table saves information for each judgement as a row.
 */
Table expData = null;

/**
 * The visualizations you need to plug in.
 * You can change the name and order of elements in this array if you don't like.
 * But please don't delete the array.
 */

String[] vis = {
    "BarChart", "PieChart", "StackedBarChart", "TreeMap", "HorizonBarChart"
};

/**
 * add the data in this judgement to the table.
 */ 
public void saveJudgement() {
    if (expData == null) {
        expData = new Table();
        expData.addColumn("PartipantID");
        expData.addColumn("Index");
        expData.addColumn("Vis");
        expData.addColumn("VisID");
        expData.addColumn("Error");
        expData.addColumn("TruePerc");
        expData.addColumn("ReportPerc");
    }

    TableRow newRow = expData.addRow();
    newRow.setInt("PartipantID", partipantID);
    newRow.setInt("Index", index);

    /**
     ** finish this: decide current visualization
     **/
    newRow.setString("Vis", "" + DECIDE_YOURSELF);

    /**
     ** finish this: decide current vis id
     **/
    newRow.setInt("VisID", DECIDE_YOURSELF);
    newRow.setFloat("Error", error);
    newRow.setFloat("TruePerc", truePerc);
    newRow.setFloat("ReportPerc", reportPerc);
}

/**
 * Save the table
 * This method is called when the participant reaches the Thanks page and hit the "CLOSE" button.
 */
public void saveExpData() {
    /**
     ** Change this if you need 
     **/
    saveTable(expData, "expData.csv");
}
class Data {
    class DataPoint {
        private float value = -1;
        private boolean marked = false;

        DataPoint(float f, boolean m) {
            this.value = f;
            this.marked = m;
        }

        public boolean isMarked() {
            return marked;
        }

        public void setMark(boolean b) {
            this.marked = b;
        }

        public float getValue() {
            return this.value;
        }
    }

    private DataPoint[] data = null;

    Data() {
        // NUM is a global varibale in support.pde
        data = new DataPoint[NUM];

        /**
         ** finish this: how to generate a dataset and mark two of the datapoints
         ** 
         **/
    }
    
        /**
         ** finish this: the rest medthods and variables you might use
         ** 
         **/
}
/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/
/************************ Don't worry about the code in this file ***************************/
/********************************************************************************************/
/********************************************************************************************/
/********************************************************************************************/

float margin = 50, margin_small = 20, margin_top = 40, chartSize = 300, answerHeight = 100;
float totalWidth = -1, totalHeight = -1;
float chartLeftX = -1, chartLeftY = -1;
int NUM = 10;

int fontSize = 14, fontSizeBig = 20;
int textFieldWidth = 200, textFieldHeight = 30;
int buttonWidth = 60;
int totalMenuWidth = textFieldWidth + buttonWidth + (int) margin_small;

String warning = null;

ControlP5 cp5 = null;
Textarea myTextarea = null;
PFont pfont = null; 
boolean page1 = false, page2 = false, pagelast = false;

public void drawWarning() {
    fill(255);
    noStroke();
    rectMode(CORNER);
    rect(0, totalHeight / 2.0f + chartSize, totalWidth, fontSize * 3);
    if (warning != null) {
        fill(color(255, 0, 0));
        textSize(fontSize);
        textAlign(LEFT);
        text(warning, totalWidth / 2.0f - chartSize / 2.0f, 
        totalHeight / 2.0f + chartSize + fontSize * 1.5f);
    }
}

public void drawInstruction() {
    fill(0);
    textAlign(CENTER);
    textSize(fontSize);
    text("Two values are marked with dots. \n " 
      + "What do you think the percent of the smaller value to the larger value? \n" 
      + "Please put your answer below. \n" 
      + "e.g. If you think the smaller one is exactly a half of the bigger one, \n" 
      + "please input \"50\"."
      , totalWidth / 2.0f, totalHeight / 2.0f + chartSize / 2.0f);
}

public void clearInstruction() {
    fill(255);
    noStroke();
    rectMode(CORNER);
    rect(0, chartSize, totalWidth, margin);
}

public void drawTextField() {
    cp5.addTextfield("answer")
        .setPosition(totalWidth / 2.0f - chartSize / 2.0f, totalHeight / 2.0f + chartSize / 2.0f + margin * 2)
        .setSize(textFieldWidth, textFieldHeight)
        .setColorCaptionLabel(color(0, 0, 0))
        .setFont(createFont("arial", 14))
        .setAutoClear(true);

    cp5.addBang("next")
        .setPosition(totalWidth / 2.0f + chartSize / 2.0f - buttonWidth, totalHeight / 2.0f + chartSize / 2.0f + margin * 2)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}

public void drawIntro() {
    fill(0);
    textSize(fontSizeBig);
    textAlign(CENTER);
    text("In this experiment, \n" 
          + "you are asked to judge \n" 
          + "what is the percent of a smaller value to a larger value " 
          + "in serveral charts. \n\n" 
          + "We won't record any other information from you except your answers.\n" 
          + "Click the \"agree\" button to begin. \n\n" 
          + "Thank you!", totalWidth / 2.0f, chartLeftY + chartSize / 4.0f);

    cp5.addBang("agree")
        .setPosition(totalWidth / 2.0f + margin * 2, totalHeight / 2.0f + chartSize / 2.0f)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);

    cp5.addBang("disagree")
        .setPosition(totalWidth / 2.0f - margin * 3, totalHeight / 2.0f + chartSize / 2.0f)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}

public void clearIntro() {
    background(color(255));
    cp5.get("agree").remove();
    cp5.get("disagree").remove();
}

public void agree() {
    index++;
    page2 = true;
}

public void disagree() {
    exit();
}

public void mouseMoved() {
    warning = null;
}

public void drawThanks() {
    background(255, 255, 255);
    fill(0);
    textSize(60);
    cp5.get(Textfield.class, "answer").remove();
    cp5.get("next").remove();
    textAlign(CENTER);
    text("Thanks!", totalWidth / 2.0f, totalHeight / 2.0f);
}

public void drawClose() {
    cp5.addBang("close")
        .setPosition(totalWidth / 2.0f - buttonWidth / 2.0f, totalHeight / 2.0f + margin_top + margin)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Lab_Experiment" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
