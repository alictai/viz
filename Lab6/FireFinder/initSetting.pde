/** the first element of is the min value of the column
 ** the second element of is the max value of the column
 **/

float[] rangeTempValue = {0, 1};  // slider of temp 
float[] rangeHumidityValue = {0, 1}; // slider of humidity 
float[] rangeWindValue = {0, 1}; // slider of wind 

/**
 * this function is called before initializing the interface
 */
void initSetting() {
    /** Finish this
     **
     ** initialize those three arrays
     ** initialize the first element of each array to the min value of the column
     ** initialize the second element of each array to the max value of the column
     **/

    String sql = "select min(temp), max(temp), min(humidity), max(humidity), min(wind), max(wind) from forestfire";
    ResultSet rs = null;
     
    try {
        // submit the sql query and get a ResultSet from the database
        rs = (ResultSet) DBHandler.exeQuery(sql);
        
        while (rs.next()) {
           rangeTempValue[0] = rs.getFloat(1);
           rangeTempValue[1] = rs.getFloat(2);
           rangeHumidityValue[0] = rs.getFloat(3);
           rangeHumidityValue[1] = rs.getFloat(4);
           rangeWindValue[0] = rs.getFloat(5);
           rangeWindValue[1] = rs.getFloat(6);
        }

    } catch (Exception e) {
        // should be a java.lang.NullPointerException here when rs is empty
        e.printStackTrace();
    } finally {
        closeThisResultSet(rs);
    }
}
