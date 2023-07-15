
void addSignalOneAndTwoBis(){

 //   signal2 continue
 //   signal to split sinus
  // lfoPattern(); // if ive is not open  //lfoPattern(); // if Live is not open
    // if you dob't use this, uncomment signal2 in addSignalLfoPattern()
     text ("Change mode q, z, or stop progation with b ", -width-200, -height- 600 );
     text ("signal2 " + signal[2], -width-200, -height- 500 );
     text ("signal3 " + signal[3], -width-200, -height- 400 );
     text (" signalToSplit " +     signalToSplit + " timeLFO " + timeLfo,  -width-200, -height- 300 );
     text (" oscillatorChange " + oscillatorChange, -width-200, -height- 200 );
      text (" propagationSpeed " + propagationSpeed + " key " + key, -width-200, -height- 100 );

    
   if (key=='q' || key=='b' || key=='z' ) { // q == addsignal
     letter = key;   
     }
     
  switch(letter) {
    case 'q': 
    doQ=true;
    doZ=false;
    break;
    case 'b': 
    doQ=false;
    break;
    case 'z': // change way of propagation
    doZ=true;
    doQ=true;
    break;
    }
 

  splitTimeLfoBis(); 
  addSignalLfoPatternBis(); 
 
 formerFormerKey= formerKey;   
 formerKey=key;
 }
 
 void addSignalLfoPatternBis()  {
    if (doQ==true ){ // useless in this mode, instead modulate space between phase kept and new phase
  //   pendularPattern(); // offset with lfo oscillator by osillator
    phaseFollowLFO[oscillatorChange]= map (signal[2], 0, 1, 0, TWO_PI);    
   }

   if (formerFormerKey  != '#' ) { //  != '#'
     print ("  normal " + frameCount + " lfoPhase[1] " + lfoPhase[1] + " lfoPhase[2] " + lfoPhase[2]);    println (   ); 
       
  int i;
  i= oscillatorChange;
    
  int j;  
  j= (oscillatorChange-1);
  if (j<= 1){
  j= 11;
  }
 
 //********POURQUOI DIFFERENT AU DEMARRAGE DE lA FONCTION
  //   signal[2] = (0*PI + (frameCount / 300.0) * cos (1000 / 500.0)*-1)%1;
     
     signal[2] = 0.01;
    
   
      LFO[i] =  map (signal[2], 0, 1, 0, TWO_PI);  
      
      
   //    LFO[i] =  map (0.01, 0, 1, 0, TWO_PI);  // CONSTANT

  
    if ( phaseKeptAtChange[j]<0){   
       LFO[i] =    LFO[i]- phaseKeptAtChange[j];
       dataMappedForMotor[i]= int (map (LFO[i], 0, -TWO_PI, numberOfStep, 0)); 

       newPosXaddSignal[i]= map (dataMappedForMotor[i], numberOfStep, 0, 0, -TWO_PI);
  }
       
   else
       LFO[i] = LFO[i]+ phaseKeptAtChange[j];

       LFO[i] = LFO[i]%TWO_PI;
       dataMappedForMotor[i]= (int) map (LFO[i], 0, TWO_PI, 0, numberOfStep);

       newPosXaddSignal[i]= map (dataMappedForMotor[i], 0, numberOfStep, 0, TWO_PI);
   
    
  }

    println (" newPosXaddSignal[oscillatorChange] ",  oscillatorChange, " ",  newPosXaddSignal[oscillatorChange] );
  
     int j;  
  j= (oscillatorChange-1);
  if (j<= 1){
  j= 11;
  }
       
  if (oscillatorChanged==true )  { 

     phaseKeptAtChange[oscillatorChange]=newPosXaddSignal[oscillatorChange];    //  RECORD on oscillatorChange-1 the postion of oscillatorChange where it has just changed
  
   }

       LFO[j] = phaseKeptAtChange[j]+QUARTER_PI ;  //les redressent de temps en temps
       LFO[j] = LFO[j]%TWO_PI;
       dataMappedForMotor[j]= (int) map (LFO[j], 0, TWO_PI, 0, numberOfStep);
       println (" phaseKeptAtChange[oscillatorChange] ", oscillatorChange, " " ,  phaseKeptAtChange[oscillatorChange]);
 
       newPosXaddSignal[j]= map (dataMappedForMotor[j], 0, numberOfStep, 0, TWO_PI);
       
///////////////////// 
//mapDataToMotor();
 for (int i = 1; i < this.nbBalls; i++) 
    {
     
        drawBallGeneral(i, newPosXaddSignal[i] );
        
    }  
  }



  
void  splitTimeLfoBis() {  // signalToSplit = lfoPhase3
 
  lfoPattern();   // signalTosplit come from lfoPattern(). Signal of rotation come from Lfopattern too. Function is at the top 
 
  if (oldSignalToSplit> signalToSplit ) {
  //  key = 'q' ; // when signal goes down --> propagation FRONT SIDE
  timeLfo= map (signalToSplit, TWO_PI, -TWO_PI, 0, 1000);  // 0 to  
    }
  else if (oldSignalToSplit< signalToSplit ) {
//   key = 'z';  //  when signal goes down --> propagation BEHIND SIDE 
//   key = 'q' ;  // propagation in on the same way
  timeLfo= map (signalToSplit, -TWO_PI, TWO_PI, 0, 1000);  // 0 to
   }
      
   oldSignalToSplit=signalToSplit;

   
  int splitTimeLfo= int  (timeLfo%100);   // 100 is the size of the gate trigging the change of the ball  
   
      println ( " oldSignalToSplit " + oldSignalToSplit + " signalToSplit " + signalToSplit );

      print (" timeLfo "); print ( timeLfo );   print (" splittimeLfo "); println ( splitTimeLfo );


 if (doZ==false){  // case q
  if (oldSplitTimeLfo>splitTimeLfo){
 //     oldMemoryi=memoryi;
 //      memoryi=(memoryi+1);
      oldOscillatorChange=oscillatorChange;
      oscillatorChange=oscillatorChange+1;
      } 
   //   memoryi=memoryi%12;
      oscillatorChange=oscillatorChange%12;
     if (oscillatorChange<=2) {
     //    memoryi=2;
         oscillatorChange=2;
   } 
  }
  
    if (doZ==true){ // case z
//  if (formerDecayTimeLfo>decayTimeLfo){
   if (  oldSplitTimeLfo>splitTimeLfo){
 //   oldMemoryi=memoryi;
 //   memoryi=(memoryi-1);
      oscillatorChange=oscillatorChange-1;
   } 
      if (oscillatorChange<=1) {
//        memoryi=11;
//        oldMemoryi=2;
        oscillatorChange=11;
   }
  }  
  
  if ( oldOscillatorChange!=oscillatorChange )
  {
   oscillatorChanged=true;
  } 
//   formerDecayTimeLfo = decayTimeLfo;
   oldSplitTimeLfo = splitTimeLfo;
             
}
