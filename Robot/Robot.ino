#include <Servo.h>
#include <AccelStepper.h>

#define ACCELERATION 3000
#define MAXSPEED 3000

#define MAXQ1 2500
#define MINQ1 -2470

/*#define MAXQ2 1900
#define MINQ2 -1900*/


#define MAXQ2 2500
#define MINQ2 -2500

AccelStepper stepper1(AccelStepper::DRIVER, 4, 5);
AccelStepper stepper2(AccelStepper::DRIVER, 6, 7);

Servo tool;

char inChar = 0;
char sz[] = "                                                                                          ";
String inputString = "";
boolean stringComplete = false;

long positions[2]; // Array of desired stepper positions

void setup() {
  Serial.begin(115200);
  inputString.reserve(200);
  attachInterrupt(0, endStop , RISING);
  Serial.attachInterrupt(SerialInterrupt);
  
  stepper1.setMaxSpeed(1000);
  stepper1.setAcceleration(5000);

  tool.attach(10);
  tool.write(60);

  stepper1.moveTo(5000);
  while (stepper1.isRunning()) {
    stepper1.run();
  }
}

void loop() {
  stepper1.moveTo(positions[0]);
  stepper2.moveTo(positions[1]);
  //while (stepper1.run() || stepper2.run());
  while (stepper1.isRunning() || stepper2.isRunning()) {
    stepper1.run();
    stepper2.run();
  }
  delay(500);
  Serial.print("A=\t");
  Serial.print(positions[0]);
  Serial.print(",\tB=\t");
  Serial.print(positions[1]);
  Serial.print("\n");
}
void SerialInterrupt(char inChar){//-----------------EVENTO DE INTERRUPCION POR SERIAL-------------------
    inputString+=inChar;
    if (inChar == '*'){//-------------CONCATENA MIENTRAS NO HAYA LLEGADO EL FIN DEL MENSAJE-------------------
      stringComplete=true;
      //Serial.println(inputString);
    }
    if (stringComplete) {
      //Serial.println(inputString);
      inputString.toCharArray(sz, inputString.length()) ;
      char *p = sz;
      char *str;
      while ((str = strtok_r(p, ";", &p)) != NULL){
        inputString =str;
        if(inputString.startsWith("$")){
          inputString.replace("$","");
        }
        if(inputString.startsWith("A=")){
          inputString.replace("A=","");
          inputString.trim();
          positions[0] = inputString.toInt();
          positions[0] = constrain(positions[0],MINQ1,MAXQ1);
        }
        if(inputString.startsWith("B=")){
          inputString.replace("B=","");
          inputString.trim();
          positions[1] = inputString.toInt();
          positions[1] = constrain(positions[1],MINQ2,MAXQ2);
        }
        if(inputString.startsWith("T=")){
          inputString.replace("T=","");
          inputString.trim();
          tool.write(inputString.toInt());
        }
      }
      Serial.flush();
      inputString = "";
      stringComplete = false;
    }
}

void endStop() {
  stepper1.setCurrentPosition(MAXQ1);

  stepper1.setMaxSpeed(MAXSPEED);
  stepper1.setAcceleration(ACCELERATION);
  stepper2.setMaxSpeed(MAXSPEED);
  stepper2.setAcceleration(ACCELERATION);

  detachInterrupt(0);
}
