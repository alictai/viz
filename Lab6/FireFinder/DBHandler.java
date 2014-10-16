
/**********************************************************************************************
 ********************************Don't worry about the code in this file***********************
 ********************************Don't worry about the code in this file***********************
 ********************************Don't worry about the code in this file***********************
 **********************************************************************************************/

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
  * @author: Fumeng Yang 
  * @since: 2010 <p>
  * this is a class to interact with a database <p>
  * you don't have to worry about the code in this lab even later ones <p>
  * you can directly cpoy this class
  */

public class DBHandler {
    
    private static Connection connection = getConnection();
    private static Statement smt = null;
    private static int sqlID = 0;

    public static Connection getConnection() {
        String url = "jdbc:mysql://mysql-user.cs.tufts.edu:3306/150VIZ"; // change if you use a differen database instance
        
        try {
            Class.forName("com.mysql.jdbc.Driver"); // change if you use different types of database
            String name = "150vizstudent"; // change if you use a differen account
            String password = "150vizstudent";// change if you use a differen account
            return (DriverManager.getConnection(url, name, password));
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    // execute SQL for inquring
    public static ResultSet exeQuery(String query) throws SQLException {
        if(query == null){
            System.out.println("an empty SQL");
            return null;
        }

        if(query.contains("*") && !query.contains("where")){
           System.out.println("Cry! Remco is not happy.");
           return null;
        }

        if (connection == null) {
            connection = getConnection();
        }
        if (smt == null) {
            smt = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                        ResultSet.CONCUR_READ_ONLY);
        }
        System.out.println(sqlID + ": " + query);
        sqlID++;
        return smt.executeQuery(query);
    }
    
    // execute SQL for updating (add, update, delete)
    public static void exeUpdateQuery(String query) throws SQLException {
        if (smt == null) {
            smt = connection.createStatement();
        }
        System.out.println(sqlID + ": " + query);
        sqlID++;
        smt.execute(query);
    }
    
    // close the connection
    public static void closeConnection(){
      try{
          smt.close();
          connection.close();
      }catch(Exception e){
          System.out.println(e.toString());
      }    
    }
   
}
