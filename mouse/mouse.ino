/**
 * Arudio Powered AI Mouse
 * @author mcgaryes@gmail.com
 */
 
#include <SPI.h>
#include "SparkFun_TB6612.h"
#include "BleConnectionService.h"


// Motor Pins

#define PIN_LEFT_POWER                22 // left motor
#define PIN_LEFT_FORWARD              9
#define PIN_LEFT_BACKWARD             10

#define PIN_RIGHT_POWER               23 // right motor
#define PIN_RIGHT_FORWARD             8
#define PIN_RIGHT_BACKWARD            7

#define PIN_STBY                      16 // standby pin for motors

// BLE Pins (referenced in ble connection service and standard spi pins)

// #define BLE_REQ                    4
// #define BLE_RDY                    5
// #define BLE_RST                    6
// #define BLE_SCK                    13
// #define BLE_MISO                   12
// #define BLE_MOSI                   11


// ============================================================
// === Properties =============================================
// ============================================================

Motor lMotor = Motor(PIN_LEFT_FORWARD, PIN_LEFT_BACKWARD, PIN_LEFT_POWER, 1, PIN_STBY);
Motor rMotor = Motor(PIN_RIGHT_BACKWARD, PIN_RIGHT_FORWARD, PIN_RIGHT_POWER, 1, PIN_STBY);

BleConnectionService service = BleConnectionService();

// ============================================================
// === Methods ================================================
// ============================================================

void setup() 
{
  analogWriteFrequency(PIN_LEFT_POWER, 375000); // Teensy 3.0 pin 3 also changes to 375 kHz
  Serial.begin(9600);

  service.begin();

}

void loop() 
{

  if (service.hasMessage() == true) {
    //Serial.print(service.getMessage());
    handleMessage(service.getMessage());
  }

  service.doEvents();
    
}

// ============================================================
// === Message Handling =======================================
// ============================================================

/**
 * 
 */

void handleMessage(char* msg) 
{

  int commaPosition = 10;
  String lms = "";
  String rms = "";
  
  for ( int i = 0; i < 10; i++) {
    if (msg[i] != ',' && i <= commaPosition) {
      lms += msg[i];
    } else {
      if (msg[i] == ',') {
        commaPosition = i;
      } else {
        if (msg[i] != '&') {
          rms += msg[i];
        }
      }
    }
  }

  // update motors

  int lmsInt = lms.toInt();
  int rmsInt = rms.toInt();

Serial.println(lmsInt);
Serial.println(rmsInt);

  if (rmsInt == 0) {
    rMotor.brake();
  } else {
    rMotor.drive(rmsInt);
  }

  if (lmsInt == 0) {
    lMotor.brake();
  } else {
    lMotor.drive(lmsInt);
  }
  
}
