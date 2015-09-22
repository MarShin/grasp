const int relay1=11;
const int relay2=12;
const int gripButtonPin = 2;
int switchStat=0; //var for determining the state 0-stop 1-upward 2-downward 3-forbidden

boolean firstRun=true;

void setup() {
  pinMode(relay1, OUTPUT);
  pinMode(relay2, OUTPUT);

  Serial.begin(9600);
  pinMode(gripButtonPin, INPUT);
  stopGrip();
}

void loop() {
  // put your main code here, to run repeatedly:
  switchStat=digitalRead(gripButtonPin);
  Serial.println(switchStat);
  delay(10);
  
  if (switchStat==1) {
      if(firstRun){
      startGrip();
      delay (550); //grip duration
      firstRun=false;
      }
  }
  stopGrip();
  // delay (3000); //depends on duration of video
  if (switchStat==0 && !firstRun){
     releaseGrip();
     delay (500); //release duration
     firstRun=!firstRun;
  }  
}

void stopGrip(){
  digitalWrite(relay1,LOW);
  digitalWrite(relay2,LOW);
  Serial.println("both are low ");
}

void releaseGrip(){
  digitalWrite(relay1,LOW);
  digitalWrite(relay2,HIGH);
  Serial.println("relay1 is low relay2 is high ");
}

void startGrip(){
  digitalWrite(relay1,HIGH);
  digitalWrite(relay2,LOW);
  Serial.println("relay1 is high relay2 is low ");
}

