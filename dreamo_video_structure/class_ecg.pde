class Ecg extends Biosensor
{
  
  private FloatList StoreEcg;
  DSP dsp, bpm;
  float BPM;
  //StoreEcg = new FloatList();
  
        public void init()
        {
              sensorName = "ecg";   
              BPM = 20;
              setValue( BPM );
              StoreEcg = new FloatList();
              dsp =new DSP();
              bpm = new DSP();
        }
      
    
        public void update()
        {     
        println("DEBUG: ECG update.");     


        if(frameCount % 1 == 0)
        {
          //int numToExtract = ceil (global_sampleRate/frameRate);
      // Per GIOVA: la connessione offline sembra non funzionare, la Floatlist incomingValues è sempre vuota,
      // come segnalato dal println sottostante.
      
          incomingValues = global_connection.extractFromBuffer("ecg", numToExtract ); // store the incoming conductance value from Connection to another FloatLIst
          StoreEcg.append(incomingValues);
                 
          println("Number of ECG elements to extract: " + numToExtract );
          println("ECG buffer size: "+ incomingValues.size() );  
          println("Highest ECG peak: "+ max(StoreEcg.array()) );

          
       }
     
     println("StoreEcg size: "+StoreEcg.size() );
      if(StoreEcg.size()> global_sampleRate*60){
        
        float[] Analysis= StoreEcg.array();
        float[] FilteredHp = dsp.HighPass (Analysis, 50.0,global_sampleRate);
        float[] FilteredLpHp = dsp.LowPassFS (FilteredHp, 100.0,global_sampleRate);
        println("BPM:"+ BPM );
        BPM = bpm.ECGBPM3(FilteredLpHp);    
        StoreEcg.clear();
     }else
       BPM = this.getValue();
     
     setValue  ( BPM );
     println("BPM:"+ BPM );

     
     if ( ! ( incomingValues == null ) )
       checkCalibration();    
  }
  
}