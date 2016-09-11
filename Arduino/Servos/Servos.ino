#include <Servo.h> 

int led = 3;           // the PWM pin the LED is attached to
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by


Servo myservo1;
Servo myservo2;
Servo myservo3;

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(led, OUTPUT);
  Serial.begin(9600);

  myservo1.attach(3);
  

  myservo2.attach(5);
  

  myservo3.attach(9);

  init_position();
}

void init_position(){
  myservo3.write(7);    
  myservo2.write(7);  
  myservo1.write(7);
}

// the loop routine runs over and over again forever:
void loop() {

  while (!Serial.available());

  while (Serial.available()) {

    delay(30);
    int pin = Serial.read()-48;
    Serial.print(pin);


    if (pin == 0) {
      init_position();  
    } else if (pin == 1){
      myservo1.write(90);

      myservo2.write(7);  
      myservo3.write(7);      
      
    } else if (pin == 2){
      myservo2.write(90);

      myservo1.write(7);  
      myservo3.write(7);            
    
    } else if (pin == 3){
      myservo3.write(90);


      myservo2.write(7);  
      myservo1.write(7);      
    }
    
 
  }

  delay(30);
  Serial.flush();
}#include <Servo.h> 

int led = 3;           // the PWM pin the LED is attached to
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by


Servo myservo1;
Servo myservo2;
Servo myservo3;

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(led, OUTPUT);
  Serial.begin(9600);

  myservo1.attach(3);
  

  myservo2.attach(5);
  

  myservo3.attach(9);

  init_position();
}

void init_position(){
  myservo3.write(7);    
  myservo2.write(7);  
  myservo1.write(7);
}

// the loop routine runs over and over again forever:
void loop() {

  while (!Serial.available());

  while (Serial.available()) {

    delay(30);
    int pin = Serial.read()-48;
    Serial.print(pin);


    if (pin == 0) {
      init_position();  
    } else if (pin == 1){
      myservo1.write(90);

      myservo2.write(7);  
      myservo3.write(7);      
      
    } else if (pin == 2){
      myservo2.write(90);

      myservo1.write(7);  
      myservo3.write(7);            
    
    } else if (pin == 3){
      myservo3.write(90);


      myservo2.write(7);  
      myservo1.write(7);      
    }
    
 
  }

  delay(30);
  Serial.flush();
}
