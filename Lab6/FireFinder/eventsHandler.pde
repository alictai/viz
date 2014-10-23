import java.sql.ResultSet;

String table_name = "forestfire";

/**
 * @author: Fumeng Yang
 * @since: 2014
 * we handle the events from the interface for you
 */

void controlEvent(ControlEvent theEvent) {
    if (interfaceReady) {
        if (theEvent.isFrom("checkboxMon") ||
            theEvent.isFrom("checkboxDay")) {
            submitQuery();
        }
        if (theEvent.isFrom("Temp") ||
            theEvent.isFrom("Humidity") ||
            theEvent.isFrom("Wind")) {
            queryReady = true;
        }

        if (theEvent.isFrom("Close")) {
            closeAll();
        }
    }
}

/**
 * generate and submit a query when mouse is released.
 * don't worry about this method
 */
void mouseReleased() {
    if (queryReady == true) {
        submitQuery();
        queryReady = false;
    }
}

void submitQuery() {
    /**
     ** Finish this
     **/

    /** abstract information from the interface and generate a SQL
     ** use int checkboxMon.getItems().size() to get the number of items in checkboxMon
     ** use boolean checkboxMon.getState(index) to check if an item is checked
     ** use String checkboxMon.getState(index).getName() to get the name of an item
     **
     ** checkboxDay (Mon-Sun) is similar with checkboxMon
     **/
    println("the " + checkboxMon.getItem(0).getName() + " is " + checkboxMon.getState(0));
    String[] months = new String [0];
    for (int i = 0; i < checkboxMon.getItems().size(); i++) {
        if (checkboxMon.getState(i)) {
            String s = checkboxMon.getItem(i).getName();
            months = append(months, s);
        }
    }
    
    String[] days = new String [0];
    for (int i = 0; i < checkboxDay.getItems().size(); i++) {
        if (checkboxDay.getState(i)) {
            String s = checkboxDay.getItem(i).getName();
            days = append(days, s);
        }
    }

    /** use getHighValue() to get the upper value of the current selected interval
     ** use getLowValue() to get the lower value
     **
     ** rangeHumidity and rangeWind are similar with rangeTemp
     **/
    float maxTemp = rangeTemp.getHighValue();
    float minTemp = rangeTemp.getLowValue();
    float maxHum = rangeHumidity.getHighValue();
    float minHum = rangeHumidity.getLowValue();
    float maxWind = rangeWind.getHighValue();
    float minWind = rangeWind.getLowValue();
    /** Finish this
     **
     ** finish the sql
     ** do read information from the ResultSet
     **/
    String sql = "select * from forestfire where (";
    for (int i = 0; i < months.length; i++) {
        if(i != 0) {
            sql += " OR ";
        }
            sql += "month='" + months[i] + "'";
    }
    
    sql += ") AND (";
    
    for (int i = 0; i < days.length; i++) {
        if(i != 0) {
            sql += " OR ";
        }
            sql += "day='" + days[i] + "'";
    }
    sql += ") AND temp BETWEEN " + String.valueOf(minTemp) + " AND " + String.valueOf(maxTemp);
    sql += " AND humidity BETWEEN " + String.valueOf(minHum) + " AND " + String.valueOf(maxHum);
    sql += " AND wind BETWEEN " + String.valueOf(minWind) + " AND " + String.valueOf(maxWind);
    
    ResultSet rs = null;
    
    try {
        // submit the sql query and get a ResultSet from the database
       rs  = (ResultSet) DBHandler.exeQuery(sql);
       
       xs = new float[0];
       ys = new float[0];
       
       while (rs.next()) {
          xs = append(xs, rs.getFloat("X"));
          ys = append(ys, rs.getFloat("Y"));
       }
    } catch (Exception e) {
        // should be a java.lang.NullPointerException here when rs is empty
        e.printStackTrace();
    } finally {
        closeThisResultSet(rs);
    }
}

void closeThisResultSet(ResultSet rs) {
    if(rs == null){
        return;
    }
    try {
        rs.close();
    } catch (Exception ex) {
        ex.printStackTrace();
    }
}

void closeAll() {
    DBHandler.closeConnection();
    frame.dispose();
    exit();
}
