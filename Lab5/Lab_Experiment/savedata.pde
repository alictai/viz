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
 * You can change the name, order, and number of elements in this array.
 */

String[] vis = {
    "BarChart", "PieChart", "StackedBarChart", "TreeMap", "LineChart"
};

/**
 * add the data for this judgement from the participant to the table.
 */ 
void saveJudgement() {
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
     ** finish this: decide the current visualization
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
 * This method is called when the participant reaches the "Thanks" page and hit the "CLOSE" button.
 */
void saveExpData() {
    /**
     ** Change this if you need 
     **/
    saveTable(expData, "expData.csv");
}
