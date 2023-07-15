int secondsToRecord = 4;
int networkSize = 12; // number of ball



String debug =""; 

// MANAGE PERSPECTIVE
import peasy.*;
PeasyCam cam;

// MANAGE ARDUINO && TENNSY
import processing.serial.*;
Serial DueSerialNativeUSBport101; // The native serial port of the DUE fibish with 101
Serial teensyport;

// MANAGE SETUP of PEREPECTIVE 3D (point of view of camera)    
// change these for screen size
float fov = 45;  // degrees
float w = 1000;
float h = 800;

// don't change these
float cameraZ, zNear, zFar;
float w2 = w / 2;
float h2 = h / 2;
// END CAMERA SETTING

int nbBalls = 12;  // number of ball in function drawBall
int oscillatorChange, oldOscillatorChange; //  // renvoie le numero de la 'balle' sur laquelle on module une position, une phase. oldOscillatorChange donne le numero de l'ancienne balle sur laquelle on modulait une position
int nbMaxDelais= 1000; //TOTAL du delais de suivi entre chaque ball (en frame). Exemple si il y a un delai de 2 frames par balle et
//que nous avons 12 balles alors le delai total entre la premiere et derniere balle est de (12-1) * 2  = 22

// la phase est la position en radian sur un cercle. Elle est située entre 0 et deux * pi, TWO_PI. 

float netPhase [] =  new float  [networkSize];  // renvoie la phase de chaque balle.

float signalToSplit, oldSignalToSplit ;  // signal oscillant entre 0 et 1 ou entre - TWO_PI et TWO_PI. oldSignalTosplit est la valeur du signal a la frame precedente. 

float timeLfo; // met à l'echelle le "signalToSplit" afin qu'il soit limité entre 0 et 1000

float splitTimeLfo, oldSplitTimeLfo; // renvoie la valeur discontine du timeLFO. Quand timeLFO va de 0 à 1000, splitTimeLfo renvoie la valeur restante du timeLfo

float propagationSpeed; // " vitesse " à laquelle on change d'oscillateur

float phaseFollowLFO [] =  new float  [networkSize]; // phase à suivre

float lfoPhase [] =  new float  [networkSize];   // tableau avec different motif de forme d'onde. Il peut y avoir des ondes en dents de scie et des ondes sinusoidales.

float signal [] =  new float  [networkSize]; 

float LFO [] =  new float  [networkSize]; 



float newPosXaddSignal [] =  new float  [networkSize]; 

float phaseKeptAtChange [] =  new float  [networkSize]; 

boolean doQ, doZ; //

boolean oscillatorChanged; // si on change d'oscillateur renvoie l'état Vrain sinon renvoie faux.  oldOscillatorChange renvoie si il y a eu un changement d'oscillateur à la frame precedente. 

char formerFormerKey, formerKey; // enregistre les lettres tapées sur le clavier

char letter;

int dataMappedForMotor [] =  new int [networkSize];   // renvoie le numero de la 'balle' sur laquelle on module une position, une phase















int [] revLfo = new int [networkSize];
int numberOfStep = 6400; // 6400 step to do a round
int [] oldPositionToMotor  = new int [networkSize];
int [] positionToMotor  = new int [networkSize];

int [] DataToDueCircularVirtualPosition = new int [networkSize];  // position à envoyer à la la carte Teensy pour controler les moteurs


public void settings() {
  size(600, 600, P3D);
}

void setup(){
  //***************************************** SET 3D CAM 
  cam = new PeasyCam(this, 2000);
  cameraZ = (h / 2.0) / tan(radians(fov) / 2.0);
  zNear = cameraZ / 10.0;
  zFar = cameraZ * 10.0;
  println("CamZ: " + cameraZ);
  rectMode(CENTER);
  
  frameRate(30); //30
  
  //  teensyport = new Serial(this,Serial.list()[1],115200); // "/dev/cu.usbmodem142401" GOOD
  int recordingTimeSec= 3; // nombre de secondes d'enregistrement
  contextG = new ContextG(recordingTimeSec);
  samplerG = new SamplerG();
  ballManager = new BallManager(nbBalls, nbMaxDelais);
     

}

void drawOriginal() 
{ 
  background(0);
  
//  addSignalOneAndTwoBis();
  
  PVector position = new PVector(0,0);
  
  translate(width/2, -height/2, 1000);// To set the center of the perspective
  
 
  
  //****** LES FONCTIONS DE SAMPLING DE GUILLAUME****

  displayMouseAndRecordSampleOrDrawSample();
  //******
  

   

  rotate(-HALF_PI ); //TO change the beginning of the 0 (cercle trigo) and the cohesion point to - HALF_PI 
  
  float lastBallPosition =  map (position.x, 0, 300, 0, TWO_PI); //netPhase11
  ballManager.updateAndDraw(lastBallPosition);
}

void draw() 
{ 
  background(0);
  
 
  translate(width/2, -height/2, 1000);// To set the center of the perspective
  
  addSignalOneAndTwoBis();
 

//  rotate(-HALF_PI ); //TO change the beginning of the 0 (cercle trigo) and the cohesion point to - HALF_PI 
  
//  float lastBallPosition =  map (position.x, 0, 300, 0, TWO_PI); //netPhase11
//  ballManager.updateAndDraw(lastBallPosition);
}









/*
   
    // note pour moi!! ATTENTION à rechanger la ligne de dessous 
    // **** for (int i = 2; i <  networkSize-2; i+=1)
  for (int i = 0; i <  networkSize; i+=1)
  { // la premiere celle du fond i=2,  la derniere celle du devant i=11
    oldPositionToMotor[i]=positionToMotor[i];

  if (phases[i][frameCount % nbMaxDelais]>0) 
  {    
    positionToMotor[i]= ((int) map (phases[i][frameCount % nbMaxDelais], 0, TWO_PI, 0, numberOfStep)); //
  }   
  else 
  {
   positionToMotor[i]= ((int) map (phases[i][frameCount % nbMaxDelais], 0, -TWO_PI, numberOfStep,  0)); //
  } 
    
  if (oldPositionToMotor[i]> positionToMotor[i]) //fonction de comptage du nombre de tour. Elle fonctionne seulement de gauche à droite
        {
    revLfo[i]++; // ajoute 1 au compteur quand l'ancienne position > actuelle position   
    }
  } 
  int i = 0;  // imprime les données de la balle samplée uniquement toutes les 10 frames
  if (frameCount%3==0){ //
   print ( " phase "  + phases[i][frameCount % nbMaxDelais] );
  println ( " compteur "  + revLfo[i] +  " position " +  positionToMotor[i] + " temps écoulé " + millis()%1000);  
   }
     assignMotorWithPosition();   //fonction qui calcule et envoye les donnes de position à la carte de controle des moteurs
}
*/
