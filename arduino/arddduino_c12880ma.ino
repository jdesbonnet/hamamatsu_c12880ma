/**
 * C12880MA controller based on arduino_c12880ma_example.ino.
 * Enhances original script to controll LED and integration 
 * time.
 * 
 * Remark: EOS (End of Scan) output is not connected, but is
 * not required.
 * 
 * Remark: The use of delayMicroseconds() in loop to bit-bang the clock
 * signal limits the clocking rate to 500kHz which is very slow. It is not 
 * clear from the datasheet what is the fastest clock rate allowed, but 
 * the worked example uses 5MHz.
 * 
 * How does photon integration work?
 * Datasheet says "integration time is equal to the high period of the start
 * pulse + 48 cycles of clock pulses".
 * 
 * Datasheet: "Supports synchronized integration (electronic shutter function)"
 *
 * 
 * Joe Desbonnet 2024-03-04.
 */

/*
 * Macro Definitions
 */
#define SPEC_TRG         A0
#define SPEC_ST          A1
#define SPEC_CLK         A2
#define SPEC_VIDEO       A3
#define WHITE_LED        A4
#define LASER_404        A5

#define SPEC_CHANNELS    288 // New Spec Channel
uint16_t data[SPEC_CHANNELS];

uint8_t integration_time = 17;

// Rate limiter (delay in ms between scans)
int rate = 500;

void setup(){

  //Set desired pins to OUTPUT
  pinMode(SPEC_CLK, OUTPUT);
  pinMode(SPEC_ST, OUTPUT);
  pinMode(LASER_404, OUTPUT);
  pinMode(WHITE_LED, OUTPUT);

  digitalWrite(SPEC_CLK, HIGH); // Set SPEC_CLK High
  digitalWrite(SPEC_ST, LOW); // Set SPEC_ST Low

  Serial.begin(115200); // Baud Rate set to 115200

  // Test control of white LED - works!
  digitalWrite (WHITE_LED,LOW);

  // Datasheet: "Do not use the video signal read at the first ST immediaately after [powerup]."
  // Read and discard first scan.
  readSpectrometer();
  delay(10); // 10ms
  
}

/*
 * This functions reads spectrometer data from SPEC_VIDEO
 * Look at the Timing Chart in the Datasheet for more info
 * 
 * Integration time is the high period of ST pulse plus
 * 48 clock cycles.
 * 
 * The shift register starts operation at the rising edge of CLK
 * immediately after ST goes low.
 */
void readSpectrometer(){

  // delay increment in microseconds
  int delayTime = 1;

  // Start clock cycle and set start pulse to signal start
  digitalWrite(SPEC_CLK, LOW);
  delayMicroseconds(delayTime);
  digitalWrite(SPEC_CLK, HIGH);
  delayMicroseconds(delayTime);
  digitalWrite(SPEC_CLK, LOW);



  // Data sheet: "The integration time equals the high period of ST plus 48 CLK cycles."


  // 
  // High period of ST. 'thp' in datasheet. Min 6/f (6 cycles).
  //
  digitalWrite(SPEC_ST, HIGH);
  delayMicroseconds(delayTime);
  // Was 15, try 7?
  for(int i = 0; i < integration_time; i++){
      digitalWrite(SPEC_CLK, HIGH);
      delayMicroseconds(delayTime);
      digitalWrite(SPEC_CLK, LOW);
      delayMicroseconds(delayTime); 
  }
  // Low period of ST
  digitalWrite(SPEC_ST, LOW);

  // "The shift register starts operation at the rising edge of CLK
  // immediately after ST goes low."
  // Is this the integration period? Do we have any control over it?
  // Example sketch had "i < 85" in this loop, but I think it should be
  // 86 as datasheet specifies 87. 
  // Evidence for this is that with the original 85 in the loop sample
  // index 0,1 looked much lower than those and indices 2,3,4...
  // So should it be 87 in the loop (??!)
  // Why did they put the final pulse outside the loop?
  for(int i = 0; i < 87; i++){ // was 85
      digitalWrite(SPEC_CLK, HIGH);
      delayMicroseconds(delayTime);
      digitalWrite(SPEC_CLK, LOW);
      delayMicroseconds(delayTime);
  }

  // One more clock pulse before the actual read
  // (for total 86? data sheet specifies 87).
  // Why is this outside the loop above??
  digitalWrite(SPEC_CLK, HIGH);
  delayMicroseconds(delayTime);
  digitalWrite(SPEC_CLK, LOW);
  delayMicroseconds(delayTime);

  //Read from SPEC_VIDEO (288 channels)
  for(int i = 0; i < SPEC_CHANNELS; i++){

      data[i] = analogRead(SPEC_VIDEO);
      
      digitalWrite(SPEC_CLK, HIGH);
      delayMicroseconds(delayTime);
      digitalWrite(SPEC_CLK, LOW);
      delayMicroseconds(delayTime);
        
  }

  //Set SPEC_ST to high
  digitalWrite(SPEC_ST, HIGH);

  //Sample for a small amount of time
  for(int i = 0; i < 7; i++){
    
      digitalWrite(SPEC_CLK, HIGH);
      delayMicroseconds(delayTime);
      digitalWrite(SPEC_CLK, LOW);
      delayMicroseconds(delayTime);
    
  }

  digitalWrite(SPEC_CLK, HIGH);
  delayMicroseconds(delayTime);
  
}

/*
 * The function below prints out data to the terminal or 
 * processing plot
 */
void printData(){
  
  for (int i = 0; i < SPEC_CHANNELS; i++){
    
    Serial.print(data[i]);
    Serial.print(',');
    
  }
  
  Serial.print("\n");
}

void loop(){
   
  readSpectrometer();
  printData();

  // Allow simple control commands by serial port.
  if (Serial.available()) {
    int control = Serial.read();
    switch (control) {
      case 'l' : {
        digitalWrite (WHITE_LED,LOW);
        break;
      }
      case 'L' : {
        digitalWrite (WHITE_LED,HIGH);
        break;
      }
      case 'R' : {
        rate = 10;;
        break;
      }
      case 'r' : {
        rate = 500;
        break;
      }
      case 'x' : {
        integration_time=7;
        break;
      }      
      case 'X' : {
        integration_time=15;
        break;
      }
    }
    
  }
  delay(rate);  
   
}

