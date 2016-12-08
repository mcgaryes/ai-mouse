#include <RBL_nRF8001.h>
#include <RBL_services.h>

/**
 * Arudio Powered AI Mouse
 * @author mcgaryes@gmail.com
 */

// ============================================================
// ============================================================
// ============================================================

//#include <RBL_nRF8001.h> 


// ============================================================
// ============================================================
// ============================================================

// left motor

#define PIN_LEFT_POWER        3 // pwm left
#define PIN_LEFT_FORWARD      11
#define PIN_LEFT_BACKWARD     12

// right motor

#define PIN_RIGHT_POWER       5 // pwm right
#define PIN_RIGHT_FORWARD     9
#define PIN_RIGHT_BACKWARD    10

// ============================================================
// ============================================================
// ============================================================

String leftovers = "";

// ============================================================
// ============================================================
// ============================================================

void setup() 
{

  ble_set_name("Remote Control Mouse");
  ble_begin();

  pinMode(PIN_LEFT_POWER, OUTPUT);
  pinMode(PIN_LEFT_FORWARD, OUTPUT);
  pinMode(PIN_LEFT_BACKWARD, OUTPUT);
  pinMode(PIN_RIGHT_FORWARD, OUTPUT);
  pinMode(PIN_RIGHT_FORWARD, OUTPUT);
  pinMode(PIN_RIGHT_BACKWARD, OUTPUT);

}

void loop() 
{

  if(ble_available()) {
      while ( ble_available() ) {
        char msg = (char) ble_read();
        handleMessage((String) msg); 
      }  
  } 

  ble_do_events();
}

// ============================================================
// ============================================================
// ============================================================

void handleMessage(String message)
{

  String temp = leftovers + message;
  
  for (int i = 0; i < temp.length(); i++) {
      if (temp.charAt(i) == '&') {
          handleCommand(temp.substring(0, i));
          temp = temp.substring(i, temp.length() - 1);
          break;
      }
   }

   leftovers = temp;

}

void handleCommand(String cmd)
{
  int index = cmd.indexOf(',');

  // assign speed and direction of left motor
  
  float lms = cmd.substring(0,index).toFloat();
  float abslms = fabs(lms);

  if (lms == 0) {
    digitalWrite(PIN_LEFT_FORWARD,LOW);
    digitalWrite(PIN_LEFT_BACKWARD,LOW);
  } else if (lms < 0) {
    digitalWrite(PIN_LEFT_FORWARD,LOW);
    digitalWrite(PIN_LEFT_BACKWARD,HIGH);
  } else if (lms > 0) {
    digitalWrite(PIN_LEFT_FORWARD,HIGH);
    digitalWrite(PIN_LEFT_BACKWARD,LOW);
  }

  analogWrite(PIN_LEFT_POWER, abslms);

  // assign speed and direction of right motor

  float rms = cmd.substring(index + 1,cmd.length() - 1).toFloat();
  float absrms = fabs(rms);

  if (rms == 0) {
    digitalWrite(PIN_RIGHT_FORWARD,LOW);
    digitalWrite(PIN_RIGHT_BACKWARD,LOW);
  } else if (rms < 0) {
    digitalWrite(PIN_RIGHT_FORWARD,LOW);
    digitalWrite(PIN_RIGHT_BACKWARD,HIGH);
  } else if (rms > 0) {
    digitalWrite(PIN_RIGHT_FORWARD,HIGH);
    digitalWrite(PIN_RIGHT_BACKWARD,LOW);
  }
  
  analogWrite(PIN_RIGHT_POWER, absrms);

  Serial.print(absrms);
  Serial.print(", ");
  Serial.print(abslms);
  Serial.println(" ");
}

