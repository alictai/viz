
/**********************************************************************************************
 ********************************Don't worry about the code in this file***********************
 ********************************Don't worry about the code in this file***********************
 ********************************Don't worry about the code in this file***********************
 **********************************************************************************************/

import controlP5.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;


ControlP5 cp5;
CheckBox checkboxMon;
CheckBox checkboxDay;
Range rangeTemp;
Range rangeHumidity;
Range rangeWind;
controlP5.Button bSubmit;
controlP5.Button bClose;

int monSize = MIN_INT;
int daySize = MIN_INT;
int margin = MIN_INT;
int textSize = 12;
int textSizeSmall = 10;
color mouseOnColor = color(158,202,225);
color mouseOnWarningColor = color(251,106,74);
color notcheckColor = color(210);
color checkedColor = color(54, 144, 192);
color labelColor = color(0);

String[] months = {
    "jan", "feb", "mar", "apr", "may", "jun",
    "jul", "aug", "sep", "oct", "nov", "dec"
};

String[] days = {
    "mon", "tue", "wed", "thu", "fri", "sat", "sun"
};

boolean queryReady = false;
boolean interfaceReady = false;

void setup() {
    size(int(displayWidth * 0.8), int(displayHeight * 0.8));
    background(245);
    canvasWidth = height;
    monSize = (width - height) / 14;
    daySize = (width - height) / 17;
    margin = int((height * 0.0425));
    
    cp5 = new ControlP5(this);
    rectMode(CORNER);
    ellipseMode(CORNER);
    textAlign(CENTER);
    textSize(textSize);

    //smooth();
    initSetting();

    drawMonth();
    drawDay();

    drawRangeTemp();
    drawRangeHumidity();
    drawRangeWind();
    drawButton();
    drawLegend();

    interfaceReady = true;

    frame.addWindowListener(new WindowAdapter() {
        public void windowClosing(WindowEvent we) {
            closeAll();
        }
    });
}

void clearCanvas() {
    fill(255);
    noStroke();
    rect(0, 0, canvasWidth, canvasWidth);
}

void drawLegend() {
    textSize(textSize);
    noStroke();
    fill(checkedColor);
    ellipse(height + 3 * margin, margin - 0.015 * height / 2, 0.015 * height, 0.015 * height);
    text("check", height + 4.5 * margin, margin + textSize / 3);

    fill(notcheckColor);
    ellipse(height + 9 * margin, margin - 0.015 * height / 2, 0.015 * height, 0.015 * height);
    text("not check", height + 11 * margin, margin + textSize / 3);
}

void drawMonth() {
    stroke(labelColor);
    fill(labelColor);
    line(height + monSize, 2 * margin,
        height + 6 * monSize, 2 * margin);
    line(height + 8.35 * monSize, 2 * margin,
        height + 13.35 * monSize, 2 * margin);
    text("Month", height + 7.15 * monSize, 2 * margin + textSize / 2);

    checkboxMon = cp5.addCheckBox("checkboxMon")
        .setPosition(height + margin, 3 * margin)
        .setColorForeground(mouseOnColor)
        .setColorActive(checkedColor)
        .setColorLabel(labelColor)
        .setColorBackground(notcheckColor)
        .setSize(monSize, monSize)
        .setItemsPerRow(6)
        .setSpacingColumn((int)(1.2 * monSize))
        .setSpacingRow((int)(monSize * 0.9))
        .addItem(months[0], 1)
        .addItem(months[1], 2)
        .addItem(months[2], 3)
        .addItem(months[3], 4)
        .addItem(months[4], 5)
        .addItem(months[5], 6)
        .addItem(months[6], 7)
        .addItem(months[7], 8)
        .addItem(months[8], 9)
        .addItem(months[9], 10)
        .addItem(months[10], 11)
        .addItem(months[11], 12);
    checkboxMon.activateAll();
}

void drawDay() {
    stroke(labelColor);
    fill(labelColor);
    line(height + monSize, 8 * margin + margin / 2,
        height + 6 * monSize, 8 * margin + margin / 2);
    line(height + 8.35 * monSize, 8 * margin + margin / 2,
        height + 13.35 * monSize, 8 * margin + margin / 2);
    text("Day", height + 7.25 * monSize, 8 * margin + margin / 2 + textSize / 2);

    checkboxDay = cp5.addCheckBox("checkboxDay")
        .setPosition(height + margin, 9 * margin)
        .setColorForeground(mouseOnColor)
        .setColorActive(checkedColor)
        .setColorLabel(labelColor)
        .setColorBackground(notcheckColor)
        .setSize(daySize, daySize)
        .setItemsPerRow(7)
        .setSpacingColumn(monSize)
        .setSpacingRow(daySize)
        .addItem(days[0], 1)
        .addItem(days[1], 2)
        .addItem(days[2], 3)
        .addItem(days[3], 4)
        .addItem(days[4], 5)
        .addItem(days[5], 6)
        .addItem(days[6], 7);
    checkboxDay.activateAll();
}

void drawRangeTemp() {
    stroke(labelColor);
    fill(labelColor);
    line(height + 1 * monSize, 12.5 * margin,
        height + 6 * monSize, 12.5 * margin);
    line(height + 8.35 * monSize, 12.5 * margin,
        height + 13.25 * monSize, 12.5 * margin);
    text("Indice", height + 7.35 * monSize, 12.5 * margin + textSize / 2);

    rangeTemp = cp5.addRange("Temp")
        // disable broadcasting since setRange and setRangeValues will trigger an event
        .setBroadcast(false)
        .setPosition(height + margin, 13 * margin + margin / 2)
        .setSize(int(((width - height) * 0.8)), int((height * 0.035)))
        .setHandleSize(5)
        .setRange(rangeTempValue[0], rangeTempValue[1])
        .setRangeValues(rangeTempValue[0], rangeTempValue[1]) // wait for data
        // after the initialization we turn broadcast back on again
        .setBroadcast(true)
        .setColorActive(mouseOnColor)
        .setColorBackground(notcheckColor)
        .setColorForeground(checkedColor)
        .setColorLabel(labelColor);
}

void drawRangeHumidity() {
    rangeHumidity = cp5.addRange("Humidity")
        // disable broadcasting since setRange and setRangeValues will trigger an event
        .setBroadcast(false)
        .setPosition(height + margin, 16 * margin)
        .setSize((int)((width - height) * 0.8), (int)(height * 0.035))
        .setHandleSize(5)
        .setRange(rangeHumidityValue[0], rangeHumidityValue[1])
        .setRangeValues(rangeHumidityValue[0], rangeHumidityValue[1]) // wait for data
        // after the initialization we turn broadcast back on again
        .setBroadcast(true)
        .setColorActive(mouseOnColor)
        .setColorBackground(notcheckColor)
        .setColorForeground(checkedColor)
        .setColorLabel(labelColor);

}

void drawRangeWind() {
    rangeWind = cp5.addRange("Wind")
        // disable broadcasting since setRange and setRangeValues will trigger an event
        .setBroadcast(false)
        .setPosition(height + margin,
            18 * margin + margin / 2)
        .setSize((int)((width - height) * 0.8), (int)(height * 0.035))
        .setHandleSize(5)
        .setRange(rangeWindValue[0], rangeWindValue[1])
        .setRangeValues(rangeWindValue[0], rangeWindValue[1]) // wait for data
        // after the initialization we turn broadcast back on again
        .setBroadcast(true)
        .setColorActive(mouseOnColor)
        .setColorBackground(notcheckColor)
        .setColorForeground(checkedColor)
        .setColorLabel(labelColor);
}

void drawButton() {
    stroke(labelColor);
    line(height + 1 * monSize, 20.5 * margin,
        height + 13.35 * monSize, 20.5 * margin);

    bClose = cp5.addButton("Close")
        .setPosition(height + 5 * margin, 21 * margin + margin / 4)
        .setColorBackground(notcheckColor)
        .setColorActive(checkedColor)
        .setColorForeground(mouseOnWarningColor)
        .setSize(int((0.3 * (width - height))), int((height * 0.05)))
        .updateSize();
}

public void destroy() {
    closeAll();
}

public void stop() {
    closeAll();
}