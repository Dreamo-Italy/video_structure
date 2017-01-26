class Ecg extends Biosensor
{
  
        public void init()
        {
              sensorName = "ecg";   
        }
      
    
        public void update()
        {     
        println("DEBUG: ECG update.");     
        float BPM;        DSP dsp =new DSP();
        DSP bpm =new DSP();
        if(frameCount % 3 == 0)
        {
          int numToExtract = ceil (global_sampleRate/frameRate);
          long initTimeT = System.nanoTime();     
      
          incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
          float[] Analysis= incomingValues.array();
          float[] FilteredHp = dsp.HighPass (Analysis, 50.0,256.0);
          float[] FilteredLpHp = dsp.LowPass (FilteredHp, 100.0,256.0);
          //BPM=bpm.ECGBPM(FilteredHp);
          BPM=60;
           println("BPM:"+BPM );
          //long bufT = System.nanoTime() - initTimeT; // duration of ExtractFromBuffer
          
          println("Number of elements to extract: " + numToExtract );
          println("buffer size: "+ incomingValues.size() );   
     }
     else
       BPM = this.getValue();
        
     setValue  ( BPM );
     
     if ( ! ( incomingValues == null ) )
       checkCalibration();
       
    // println("    Extract from buffer time: "+ bufT/1000 + " us");
     println("");
    
  }
  
}