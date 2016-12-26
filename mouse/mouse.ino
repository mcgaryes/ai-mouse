/**
 * Arudio Powered AI Mouse
 * @author mcgaryes@gmail.com
 */

#include <SoftwareSerial.h>
//#include <SPI.h>

#define PIN_BLUETOOTH_RX              0 // bluetooth pins
#define PIN_BLUETOOTH_TX              1
#define PIN_BLUETOOTH_SLAVE           1

#define PIN_LED                       16

#define PIN_LEFT_POWER                15 // left motor
#define PIN_LEFT_FORWARD              11
#define PIN_LEFT_BACKWARD             12

#define PIN_RIGHT_POWER               14 // right motor
#define PIN_RIGHT_FORWARD             10
#define PIN_RIGHT_BACKWARD            9

// ============================================================
// === Properties =============================================
// ============================================================

SoftwareSerial bluetooth(PIN_BLUETOOTH_RX, PIN_BLUETOOTH_TX); // RX, TX

// ============================================================
// === Methods ================================================
// ============================================================

void setup() 
{

  pinMode(PIN_LED, OUTPUT);

  pinMode(PIN_BLUETOOTH_RX, INPUT);
  pinMode(PIN_BLUETOOTH_TX, OUTPUT );

  pinMode(PIN_BLUETOOTH_RX, OUTPUT);
  
  pinMode(PIN_LEFT_POWER, OUTPUT);
  pinMode(PIN_LEFT_FORWARD, OUTPUT);
  pinMode(PIN_LEFT_BACKWARD, OUTPUT);

  pinMode(PIN_RIGHT_POWER, OUTPUT);
  pinMode(PIN_RIGHT_FORWARD, OUTPUT);
  pinMode(PIN_RIGHT_BACKWARD, OUTPUT);

  Serial.begin(9600);
  bluetooth.begin(9600);
  
  //SPI.begin();
  
}

void loop() 
{
  pinMode(PIN_LED, HIGH);

  //char val = digitalRead(PIN_BLUETOOTH_TX);
  //Serial.println(val);

  while(bluetooth.available()) {
    handleIncomingChar(bluetooth.read());
  }

}

// ============================================================
// === Message Handling =======================================
// ============================================================

char message[10] = "";
int incomingCount = 0;

/**
 * 
 */
void handleIncomingChar(char incomingChar)
{
  message[incomingCount] = incomingChar;
  incomingCount++;
  if (incomingCount == 10) {
    handleMessage();
    incomingCount = 0;  
  }
}

/**
 * 
 */
void handleMessage() 
{

  int commaPosition = 10;
  String lms = "";
  String rms = "";
  
  for ( int i = 0; i < 10; i++) {
    if (message[i] != ',' && i <= commaPosition) {
      lms += message[i];
    } else {
      if (message[i] == ',') {
        commaPosition = i;
      } else {
        if (message[i] != '&') {
          rms += message[i];
        }
      }
    }
  }

  updateMotors(lms.toInt(),rms.toInt());
  
}

/**
 * 
 */
void updateMotors(int lms,int rms)
{

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

  analogWrite(PIN_LEFT_POWER, abs(lms));

  // assign speed and direction of right motor

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
  
  analogWrite(PIN_RIGHT_POWER, abs(rms));
 
}

