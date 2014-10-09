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

void drawWarning() {
    fill(255);
    noStroke();
    rectMode(CORNER);
    rect(0, totalHeight / 2.0 + chartSize, totalWidth, fontSize * 3);
    if (warning != null) {
        fill(color(255, 0, 0));
        textSize(fontSize);
        textAlign(LEFT);
        text(warning, totalWidth / 2.0 - chartSize / 2.0, 
        totalHeight / 2.0 + chartSize + fontSize * 1.5);
    }
}

void drawInstruction() {
    fill(0);
    textAlign(CENTER);
    textSize(fontSize);
    text("Two values are marked with dots. \n " 
      + "What percentage is the smaller of the larger? \n" 
      + "Please put your answer below. \n" 
      + "e.g. If you think the smaller is exactly a half of the larger, \n" 
      + "please input \"50\"."
      , totalWidth / 2.0, totalHeight / 2.0 + chartSize / 2.0);
}

void clearInstruction() {
    fill(255);
    noStroke();
    rectMode(CORNER);
    rect(0, chartSize, totalWidth, margin);
}

void drawTextField() {
    cp5.addTextfield("answer")
        .setPosition(totalWidth / 2.0 - chartSize / 2.0, totalHeight / 2.0 + chartSize / 2.0 + margin * 2)
        .setSize(textFieldWidth, textFieldHeight)
        .setColorCaptionLabel(color(0, 0, 0))
        .setFont(createFont("arial", 14))
        .setAutoClear(true);

    cp5.addBang("next")
        .setPosition(totalWidth / 2.0 + chartSize / 2.0 - buttonWidth, totalHeight / 2.0 + chartSize / 2.0 + margin * 2)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}

void drawIntro() {
    fill(0);
    textSize(fontSizeBig);
    textAlign(CENTER);
    text("In this experiment, \n" 
          + "you are asked to judge \n" 
          + "ratios between graphical elements " 
          + "in serveral charts. \n\n" 
          + "We won't record any other information from you except your answers.\n" 
          + "Click the \"agree\" button to begin. \n\n" 
          + "Thank you!", totalWidth / 2.0, chartLeftY + chartSize / 4.0);

    cp5.addBang("agree")
        .setPosition(totalWidth / 2.0 + margin * 2, totalHeight / 2.0 + chartSize / 2.0)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);

    cp5.addBang("disagree")
        .setPosition(totalWidth / 2.0 - margin * 3, totalHeight / 2.0 + chartSize / 2.0)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}

void clearIntro() {
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

void mouseMoved() {
    warning = null;
}

void drawThanks() {
    background(255, 255, 255);
    fill(0);
    textSize(60);
    cp5.get(Textfield.class, "answer").remove();
    cp5.get("next").remove();
    textAlign(CENTER);
    text("Thanks!", totalWidth / 2.0, totalHeight / 2.0);
}

void drawClose() {
    cp5.addBang("close")
        .setPosition(totalWidth / 2.0 - buttonWidth / 2.0, totalHeight / 2.0 + margin_top + margin)
        .setSize(buttonWidth, textFieldHeight)
        .getCaptionLabel()
        .align(ControlP5.CENTER, ControlP5.CENTER);
}
