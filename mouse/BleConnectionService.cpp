
#include <SPI.h>
#include "BleConnectionService.h"

#define ADAFRUITBLE_REQ               4
#define ADAFRUITBLE_RDY               5 // This should be an interrupt pin, on Uno thats #2 or #3
#define ADAFRUITBLE_RST               6

Adafruit_BLE_UART BTLEserial = Adafruit_BLE_UART(ADAFRUITBLE_REQ, ADAFRUITBLE_RDY, ADAFRUITBLE_RST);
aci_evt_opcode_t laststatus = ACI_EVT_DISCONNECTED;
char message[10] = "";
int incomingCount = 0;
bool currentlyHasMessage = false;

BleConnectionService::BleConnectionService(){}

void BleConnectionService::begin()
{
  BTLEserial.begin();
}

void BleConnectionService::doEvents()
{
  // Tell the nRF8001 to do whatever it should be working on.
  BTLEserial.pollACI();

  // Ask what is our current status
  aci_evt_opcode_t status = BTLEserial.getState();
  // If the status changed....
  if (status != laststatus) {
    // print it out!
    if (status == ACI_EVT_DEVICE_STARTED) {
      Serial.println("[BleConnectionService] Advertising started...");
    }
    if (status == ACI_EVT_CONNECTED) {
      Serial.println("[BleConnectionService] Connected.");
    }
    if (status == ACI_EVT_DISCONNECTED) {
      Serial.println("[BleConnectionService] Disconnected or advertising timed out...");
    }
    // OK set the last status change to this one
    laststatus = status;
  }

  if (status == ACI_EVT_CONNECTED) {
    if (currentlyHasMessage == false) {
      // OK while we still have something to read, get a character and print it out
      while (BTLEserial.available()) {

        char c = BTLEserial.read();

        message[incomingCount] = c;
        incomingCount++;

        if (incomingCount == 10) {

          currentlyHasMessage = true;
          incomingCount = 0;

        }

      } // end while

    } // end if has message

  } // end if status

}

bool BleConnectionService::hasMessage()
{
  return currentlyHasMessage;
}

char* BleConnectionService::getMessage()
{
   currentlyHasMessage = false;
   return message;
}

