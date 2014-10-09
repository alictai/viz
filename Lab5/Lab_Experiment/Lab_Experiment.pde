import controlP5.*;

final int DECIDE_YOURSELF = -1; // This is a placeholder for variables you will replace.

/**
 * This is a global variable for the dataset in your visualization. You'll be overwriting it each trial.
 */
Data d = null;

void setup() {
    totalWidth = displayWidth;
    totalHeight = displayHeight;
    chartLeftX = totalWidth / 2.0 - chartSize / 2.0;
    chartLeftY = totalHeight / 2.0 - chartSize / 2.0 - margin_top;

    size((int) totalWidth, (int) totalHeight);
    //if you have a Retina display, use the line below (looks better)
    //size((int) totalWidth, (int) totalHeight, "processing.core.PGraphicsRetina2D");

    background(255);
    frame.setTitle("Comp150-07 Visualization, Lab 5, Experiment");

    cp5 = new ControlP5(this);
    pfont = createFont("arial", fontSize, true); 
    textFont(pfont);
    page1 = true;

    /**
     ** Finish this: decide how to generate the dataset you are using (see DataGenerator)
     **/
    d = null;

    /**
     ** Finish this: how to generate participant IDs
     ** You can write a short alphanumeric ID generator (cool) or modify this for each participant (less cool).
     **/
    partipantID = DECIDE_YOURSELF;
}

void draw() {
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
         **  Finish this: decide the chart type. You can do this randomly.
         **/
        int chartType = DECIDE_YOURSELF;

        switch (chartType) {
            case -1: // This is a placeholder, you can remove it and use the other cases for the final version
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
     * We check their percentage input for you.
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
             ** Finish this: decide how to compute the right answer
             **/
            truePerc = DECIDE_YOURSELF; // hint: from your list of DataPoints, extract the two marked ones to calculate the "true" percentage

            reportPerc = ans / 100.0; // this is the participant's response
            
            /**
             ** Finish this: decide how to compute the log error from Cleveland and McGill (see the handout for details)
             **/
            error = DECIDE_YOURSELF;

            saveJudgement();
        }

        /**
         ** Finish this: decide the dataset (similar to how you did in setup())
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
     ** Change this if you need to do some final processing
     **/
    saveExpData();
    exit();
}

/**
 * Calling this method will set everything to the intro page. Use this if you want to run multiple participants without closing Processing (cool!). Make sure you don't overwrite your data.
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
