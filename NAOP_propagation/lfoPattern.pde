void lfoPattern(){
       
 
    signal[10] = (0*PI + (frameCount / 300.0) * cos (1000 / 500.0)*-1)%1;
    
    signal[11] = (0*PI + (frameCount / 30.0) * cos (1000 / 500.0)*-1)%1;  // ==> 15 = 8 sec
  
    lfoPhase[1] = (0*PI + (frameCount / 50.0) * cos (1000 / 500.0)*-1)%TWO_PI;
    
  //  lfoPhase[2] = (PI + (frameCount / 5.0) * cos (1000 / 500.0)*-1)%TWO_PI;  // ==> 15 = 8 sec
    
  //  lfoPhase[3] = map (( cos  (frameCount / 22.0) %TWO_PI), 0, 1, 0, TWO_PI);  // sinusoid  //  lfoPhase[3] = map (( cos  (frameCount / 22.0) %TWO_PI), 0, 1, -TWO_PI, TWO_PI);
    
    lfoPhase[3] = map ((((cos  (frameCount / 100.0))*-1) %2), -1, 1, -TWO_PI, TWO_PI);  // sinusoida
    
    lfoPhase[2] = map ((((cos  (frameCount / 100.0))*-1) %2), -1, 1, -TWO_PI, TWO_PI);  // sinusoida offset
    
    // DEV
        println (" forme d'onde ", lfoPhase[1], "lfoPhase[2] ", lfoPhase[2], "lfoPhase[3]= signalTosplit ", lfoPhase[3]); 

    signalToSplit= lfoPhase[3];
 }
