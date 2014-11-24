import controlP5.*;

final int DECIDE_YOURSELF = -1; // This is a placeholder for variables you will replace.

/**
 * This is a global variable for the dataset in your visualization. You'll be overwriting it each trial.
 */
Data d = null;
int chartType = int(random(6));
int num_trials = 180;
int size_offset = 75;
int[] counter;

void setup() {
  totalWidth = displayWidth;
  totalHeight = displayHeight;
  chartLeftX = totalWidth / 2.0 - chartSize / 2.0;
  chartLeftY = totalHeight / 2.0 - chartSize / 2.0 - margin_top;
  counter = new int[6];
  for(int i = 0; i < 6; i++) {
      counter[i] = 0;
  }

  size((int) totalWidth, (int) totalHeight);
  //if you have a Retina display, use the line below (looks better)
  //size((int) totalWidth, (int) totalHeight, "processing.core.PGraphicsRetina2D");

  background(255);
  frame.setTitle("Comp150-07 Visualization, Lab 5, Experiment");

  cp5 = new ControlP5(this);
  pfont = createFont("arial", fontSize, true); 
  textFont(pfont);
  page1 = true;

  
  d = new Data();

  //partipantID = 2;
  partipantID = int(random(100000));
}

void draw() {
  textSize(fontSize);
  /**
   ** add more: you may need to draw more stuff on your screen
   **/
  if (index < 0 && page1) {
    drawIntro();
    page1 = false;
  } else if (index >= 0 && index < num_trials) {
    if (index == 0 && page2) {
      clearIntro();
      drawTextField();
      drawInstruction();
      page2 = false;
    }

    clearCanvas();
    
    
    switch (chartType) {
    case -1: // This is a placeholder, you can remove it and use the other cases for the final version
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      /*
                  * all your charts must be inside this rectangle - BUT NOT ANYMORE
       */
      rect(chartLeftX, chartLeftY, chartSize, chartSize);
      break;
    case 0:  //Tiny Bar Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      
      rect(chartLeftX + size_offset, chartLeftY + 2*size_offset, chartSize - 2*size_offset, chartSize - 2*size_offset);
      Bar_Graph bar1 = new Bar_Graph(d, int(chartLeftX + size_offset), int(chartLeftY + 2*size_offset), int(chartLeftX + chartSize - size_offset), int(chartLeftY + chartSize) );
      bar1.draw_graph();
      
      break;
    
    case 1:  //Regular Bar Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      
      rect(chartLeftX, chartLeftY, chartSize, chartSize);
      Bar_Graph bar2 = new Bar_Graph(d, int(chartLeftX), int(chartLeftY), int(chartLeftX + chartSize), int(chartLeftY + chartSize) );
      bar2.draw_graph();
      
      break;
    
    case 2:  //Bigger Bar Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      
      rect(chartLeftX - size_offset, chartLeftY - 2*size_offset, chartSize + 2*size_offset, chartSize + 2*size_offset);
      Bar_Graph bar3 = new Bar_Graph(d, int(chartLeftX - size_offset), int(chartLeftY - 2*size_offset), int(chartLeftX + chartSize + size_offset), int(chartLeftY + chartSize) );
      bar3.draw_graph();
      
      break;
    
    case 3:  //Tiny Pie Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);

      rect(chartLeftX + size_offset, chartLeftY + 2*size_offset, chartSize - 2*size_offset, chartSize - 2*size_offset);
      Pie_Chart pie1 = new Pie_Chart(d, int(chartLeftX + size_offset), int(chartLeftY + 2*size_offset), int(chartLeftX + chartSize - size_offset), int(chartLeftY + chartSize) );
      pie1.draw_graph();
      
      break;
      
    case 4:  //Regular Pie Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);

      rect(chartLeftX, chartLeftY, chartSize, chartSize);
      Pie_Chart pie2 = new Pie_Chart(d, int(chartLeftX), int(chartLeftY), int(chartLeftX + chartSize), int(chartLeftY + chartSize) );
      pie2.draw_graph();
      
      break;
      
    case 5:  //Bigger Bar Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      
      rect(chartLeftX - size_offset, chartLeftY - 2*size_offset, chartSize + 2*size_offset, chartSize + 2*size_offset);
      Pie_Chart pie3 = new Pie_Chart(d, int(chartLeftX - size_offset), int(chartLeftY - 2*size_offset), int(chartLeftX + chartSize + size_offset), int(chartLeftY + chartSize) );
      pie3.draw_graph();
      
      break;
      
    case 6:  //Tiny Line Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);

      rect(chartLeftX + size_offset, chartLeftY + 2*size_offset, chartSize - 2*size_offset, chartSize - 2*size_offset);
      Line_Graph line1 = new Line_Graph(d, int(chartLeftX + size_offset - 10), int(chartLeftY + 2*size_offset), int(chartLeftX + chartSize - size_offset - 10), int(chartLeftY + chartSize) );
      line1.draw_graph();
      
      break;
      
    case 7:  //Regular Line Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      
      rect(chartLeftX, chartLeftY, chartSize, chartSize);
      Line_Graph line2 = new Line_Graph(d, int(chartLeftX), int(chartLeftY), int(chartLeftX + chartSize), int(chartLeftY + chartSize) );
      line2.draw_graph();
      
      break;
      
    case 8:  //Bigger Line Graph
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      
      rect(chartLeftX - size_offset, chartLeftY - 2*size_offset, chartSize + 2*size_offset, chartSize + 2*size_offset);
      Line_Graph line3 = new Line_Graph(d, int(chartLeftX - size_offset), int(chartLeftY - 2*size_offset), int(chartLeftX + chartSize + size_offset), int(chartLeftY + chartSize) );
      line3.draw_graph();
      
      break;
/*
    case 2:  //Squarified Treemap - now obsolete
      stroke(0);
      strokeWeight(1);
      fill(255);
      rectMode(CORNER);
      
      rect(chartLeftX, chartLeftY, chartSize, chartSize);
      Treemap_Parser parser = new Treemap_Parser();
      Canvas root = parser.parse(d);
      Treemap tree = new Treemap(root, int(chartLeftX), int(chartLeftY), int(chartSize), int(chartSize));
      tree.draw_treemap();
      break;
*/      
    }


    drawWarning();
  } else if (index > num_trials - 1 && pagelast) {
    drawThanks();
    drawClose();
    pagelast = false;
  }
}

void clearCanvas() {
  stroke(255);
  fill(255,255,255);
  rect(0, 0, width, chartLeftY + chartSize + 10);

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
    if (index >= 0 && index < num_trials) {
      float ans = parseFloat(cp5.get(Textfield.class, "answer").getText());

      float val1 = 0;
      float val2 = 0;
      int counter = 0;
       
      for (int i = 0; i < d.getLength(); i++) {
         if (d.isMarked(i) && counter == 0) {
             val1 = d.getVal(i);
             counter++;
         } else if (d.isMarked(i) && counter == 1) {
             val2 = d.getVal(i);
             counter = 0;
         }
      }
      
      if (val1 < val2) {
        truePerc = (val1/val2) * 100;
      } else {
        truePerc = (val2/val1) * 100;
      }
//      print("vals = ", val1, " ", val2, " percentage = ", truePerc, "\n");

      reportPerc = ans; // this is the participant's response

      /**
       ** Finish this: decide how to compute the log error from Cleveland and McGill (see the handout for details)
       **/
      error = log(abs(reportPerc - truePerc) + 1/8) / log(2);
      
      saveJudgement(chartType);
    }

    /**
     ** Finish this: decide the dataset (similar to how you did in setup())
     **/
    d = new Data();
    /*
        fill(255);
     rect(chartLeftX-5, chartLeftY-5, chartSize+10, chartSize+10);  
     fill(0);
     */

    counter[chartType] += 1;
    cp5.get(Textfield.class, "answer").clear();
    index++;
    
    if (index == num_trials) {
            pagelast = true;    
    } else {
        chartType = int(random(6));
        while (counter[chartType] >= 30) {
          chartType = int(random(6));
        }
    }
    
    print(index, "\n");
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
public void reset() {
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

