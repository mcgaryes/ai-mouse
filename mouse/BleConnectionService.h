/**
 * BleConnectionService
 * @author mcgaryes@gmail.com
 */
 
#include <Arduino.h>
#include "Adafruit_BLE_UART.h"

class BleConnectionService
{
 
  public:

  /**
   * 
   */
  BleConnectionService();

  /**
   * 
   */
  bool hasMessage();

  /**
   * 
   */
  char* getMessage();

  /**
   * 
   */
  void begin();

  /**
   * 
   */
  void doEvents();

};
