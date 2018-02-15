int echoPin = 8; 
int trigPin = 6; 
int lowPin = 14;
int highPin = 15;
void setup() { 
Serial.begin (9600); 
pinMode(trigPin, OUTPUT); 
pinMode(highPin, OUTPUT); 
pinMode(lowPin, OUTPUT); 
pinMode(echoPin, INPUT); 
analogReference(INTERNAL);
} 
void loop() { 
int duration, mm; 
digitalWrite(trigPin, LOW); 
delayMicroseconds(2); 
digitalWrite(trigPin, HIGH); 
delayMicroseconds(10); 
digitalWrite(trigPin, LOW); 
duration = pulseIn(echoPin, HIGH); 
mm = duration / 5.8;
Serial.println(mm);
if (mm > 80) {
  digitalWrite(lowPin, HIGH); 
  digitalWrite(highPin, LOW); 
} else if (mm < 50) {
  digitalWrite(lowPin, LOW); 
  digitalWrite(highPin, HIGH); 
} else {
  digitalWrite(lowPin, LOW); 
  digitalWrite(highPin, LOW); 
}
delay(250);
}
