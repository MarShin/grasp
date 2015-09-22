/*
  DigitalReadSerial
 Reads a digital input on pin 2, prints the result to the serial monitor 
 
 This example code is in the public domain.
 */

// digital pin 2 has a pushbutton attached to it. Give it a name:
const int recordButtonpin = 2;
int buttonState=0;
// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  // make the pushbutton's pin an input:
  pinMode(recordButtonpin, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  //while (Serial.available()==0);
  // read the input pin:
  buttonState = digitalRead(recordButtonpin);
  // print out the state of the button:
  Serial.print(buttonState);
  delay(50);        // delay in between reads for stability
}
