class Gsr extends Biosensor
{  
  

  public void init()
  {
    defaultValue = 5;
    sensorMin = 1;
    sensorMax = 10; 
  }
  
  public int getAnInt() // takes an int out of the current connection
  {
    int incoming = -1;
    
    if (global_connection != null )
      incoming = global_connection.getAnElement();  

    return incoming;
   
  }
  
}