#include <AccelStepper.h>  //by Mike McCauley
#include <Wire.h>
#include <ArduCAM.h>
#include <SPI.h>
#include "memorysaver.h"

#define ntc_pin A0
#define ntc_ref 10000
#define temp_ref 25
#define ntc_no 10
#define ntc_beta 3950
#define ntc_resistor 10000
#define dir1 5
#define step1 2
#define dir2 7
#define step2 4
#define EN 8
#define IN A1
#define motorInterfaceType 1

#if !(defined(OV5642_MINI_5MP_PLUS))
#error Please select the hardware platform and camera module in the memorysaver.h, only OV5642 mini 5mp+ will work.
#endif
#define FRAMES_NUM 0x00


// led, temperature, peltier, motors
int pacemaker = 4000;
int led_pin = 6;
int pelt_pin = 3;
int samples[ntc_no];
int interval = 0;
int intervalPin = 0;
int intV = 0;
int int1 = 0;
int int2 = 0;
int inti = 0;
int motor1_temp = 0;
unsigned long t;
float temperature;

// Steepers
long input = 0;
AccelStepper stepper1 = AccelStepper(motorInterfaceType, step1, dir1);
AccelStepper stepper2 = AccelStepper(motorInterfaceType, step2, dir2);

// Arducam
const int CS1 = 10;  // SPI slave for ArduCam
bool CAM1_EXIST = false;
bool continuous = false;
long int streamStartTime;
ArduCAM myCAM1(OV5642, CS1);


void setup() {
  uint8_t vid, pid;
  uint8_t temp;
  Wire.begin();
  Serial.begin(115200);
  //Serial.begin(230400);
  // Serial.begin(150000);

  SendMessage("UNO is connected");

  pinMode(CS1, OUTPUT);
  SPI.begin();
  stepper1.setMaxSpeed(10000);
  stepper1.setAcceleration(500);
  stepper2.setMaxSpeed(10000);
  stepper2.setAcceleration(500);
  pinMode(EN, OUTPUT);
  digitalWrite(EN, HIGH);
  pinMode(IN, INPUT);
  digitalWrite(IN, LOW);

  //initialise camera - check SPI
  while (1) {
    myCAM1.write_reg(ARDUCHIP_TEST1, 0x55);
    temp = myCAM1.read_reg(ARDUCHIP_TEST1);
    if (temp != 0x55) {
      SendMessage("SPI1 interface Error!");
    } else {
      CAM1_EXIST = true;
      SendMessage("SPI1 interface OK.");
    }

    if (!(CAM1_EXIST)) {
      delay(1000);
      continue;
    } else
      break;
  }

  //initialise camera - check OV5642
  while (1) {
    myCAM1.rdSensorReg16_8(OV5642_CHIPID_HIGH, &vid);
    myCAM1.rdSensorReg16_8(OV5642_CHIPID_LOW, &pid);
    if ((vid != 0x56) || (pid != 0x42)) {
      SendMessage("Can't find OV5642 module");
      delay(1000);
      continue;
    } else {
      SendMessage("OV5642 detected");
      break;
    }
  }

  //initialise camera
  myCAM1.set_format(JPEG);
  myCAM1.InitCAM();
  myCAM1.write_reg(ARDUCHIP_TIM, VSYNC_LEVEL_MASK);
  myCAM1.clear_fifo_flag();
  myCAM1.write_reg(ARDUCHIP_FRAMES, FRAMES_NUM);
  myCAM1.OV5642_set_JPEG_size(OV5642_320x240);
  delay(1000);
  myCAM1.clear_fifo_flag();
  SendMessage("iCAT is ready!");
  t = millis();
}

void loop() {
  char logMessage[64];
  serialEvent();

  if (millis() == t + pacemaker) {
    snprintf(logMessage, sizeof(logMessage), "Time: %lu", millis()/1000);
    SendMessage(logMessage);
    ntc(1023);                 //1023 for 5V, 675 for 3.3V
    t = millis();
    if (temperature > 42) {
      pelt(0);
    SendMessage("peltier safety shutdown!!!!");
      }
  }

  if (millis() > t + pacemaker) {
    SendMessage("pacemaker error");
    t = millis();
  }


  intervalPin = analogRead(IN);
  if (intervalPin > 900 && interval == 1) {
    if (int2 == 0) {
      snprintf(logMessage, sizeof(logMessage), "A2: %d", intervalPin);
      SendMessage(logMessage);
      snprintf(logMessage, sizeof(logMessage), "Position before int1: %d", intV);
      SendMessage(logMessage);
      intV = intV + int1;
      snprintf(logMessage, sizeof(logMessage), "Position after int1: %d", intV);
      SendMessage(logMessage);
      motor1(intV);
      delay(1000);
    } else {
      int int12[2];
      int12[0] = int1;
      int12[1] = int2;
      snprintf(logMessage, sizeof(logMessage), "A2: %d", intervalPin);
      SendMessage(logMessage);
      snprintf(logMessage, sizeof(logMessage), "i: %d", inti);
      SendMessage(logMessage);
      snprintf(logMessage, sizeof(logMessage), "int: %d", int12[inti]);
      SendMessage(logMessage);

      snprintf(logMessage, sizeof(logMessage), "Position before int: %d", intV);
      SendMessage(logMessage);
      intV = intV + int12[inti];
      snprintf(logMessage, sizeof(logMessage), "Position after int: %d", intV);
      SendMessage(logMessage);
      motor1(intV);
      motor1(intV);
      delay(1000);
      inti++;
      if (inti == 2) {
        inti = 0;
      }
    }
  }
 // else if (interval == 1) {
 //     snprintf(logMessage, sizeof(logMessage), "A2low: %d", intervalPin);
 //     SendMessage(logMessage);
 // }


  if (CAM1_EXIST && continuous) {
    streamStartTime = millis();
    myCAMSendToSerial(myCAM1);
    long int elapsed = millis() - streamStartTime;
    snprintf(logMessage, sizeof(logMessage), "Camera continuous processing and sending time: %lu", elapsed); //%d
    SendMessage(logMessage);
  }
}

void writeToSerialHeader(uint8_t messageType, uint16_t dataSize) {
  // Write messageType
  byte messageTypeBytes[2] = {0x00, messageType};
  Serial.write(messageTypeBytes, sizeof(messageTypeBytes));

  // Write data size
  byte dataSizeBytes[2];
  dataSizeBytes[0] = (dataSize & 0xFF00) >> 8;
  dataSizeBytes[1] = (dataSize & 0x00FF);

  Serial.write(dataSizeBytes, sizeof(dataSizeBytes));
}

void writeToSerial(uint8_t messageType, uint16_t dataSize, const char data[]) {
  writeToSerialHeader(messageType, dataSize);

  // Write string itself
  Serial.write(data, dataSize);
}

#define MSG_TYPE_TEMPERATURE 1
#define MSG_TYPE_IMAGE 2
#define MSG_TYPE_MESSAGE 3



void SendMessage(const char c[]) {
  writeToSerial(
    MSG_TYPE_MESSAGE,
    strlen(c),
    c
  );
}

void SendTemperature(float temp) {
  uint16_t tempCentiCelsius = (uint16_t) (temp * 100);
  writeToSerial(
    MSG_TYPE_TEMPERATURE,
    2,
    (const char *) &tempCentiCelsius
  );
}

void ntc(int scale) {
  uint8_t i;
  float average;
  for (i = 0; i < ntc_no; i++) {
    samples[i] = analogRead(ntc_pin);
    //delay(10);
  }
  average = 0;
  for (i = 0; i < ntc_no; i++) {
    average += samples[i];
  }
  average /= ntc_no;
  ////Serial.print("Average analog reading "); //Serial.println(average);
  average = scale / average - 1;     // (1023/ADC - 1) USE THIS FOR 5V supply
  average = ntc_resistor / average;  // 10K / (1023/ADC - 1)
  ////Serial.print("Thermistor resistance "); //Serial.println(average);
  temperature = average / ntc_ref;           // (R/Ro)
  temperature = log(temperature);                   // ln(R/Ro)
  temperature /= ntc_beta;                   // 1/B * ln(R/Ro)
  temperature += 1.0 / (temp_ref + 273.15);  // + (1/To)
  temperature = 1.0 / temperature;                  // Invert
  temperature -= 273.15;                     // convert absolute temp to C

  SendTemperature(temperature);
}


void led(int led_val) {
  char logMessage[64];
  snprintf(logMessage, sizeof(logMessage), "Arduino: led %d", led_val);
  SendMessage(logMessage);
  analogWrite(led_pin, led_val);
}

void pelt(int pelt_val) {
  char logMessage[64];
  snprintf(logMessage, sizeof(logMessage), "Arduino: pelt %d", pelt_val);
  SendMessage(logMessage);
  analogWrite(pelt_pin, pelt_val);
}


void motor1(long motor1_val) {
  char logMessage[64];
  snprintf(logMessage, sizeof(logMessage), "Arduino: motor1 %d", motor1_val);
  SendMessage(logMessage);

  motor1_val = motor1_val * 16 / 1.8;  //value * 16(microsteepeing when all 3 pins connected) *200 (steps/cycle) / 360 (°)
  digitalWrite(EN, LOW);
  stepper1.moveTo(motor1_val);
  stepper1.runToPosition();
  digitalWrite(EN, HIGH);
}


void motor2(long motor2_val) {
  char logMessage[64];
  snprintf(logMessage, sizeof(logMessage), "Arduino: motor2 %d", motor2_val);
  SendMessage(logMessage);

  motor2_val = motor2_val * 8;
  digitalWrite(EN, LOW);
  stepper2.moveTo(motor2_val);
  stepper2.runToPosition();
  //Serial.print("motor2 moved to: ");
  //Serial.println(motor2_val);
  digitalWrite(EN, HIGH);
}


void myCAMSendToSerial(ArduCAM myCAM) {
  char logMessage[64];
  char str[8];
  byte buf[5];

  static int i = 0;
  static int k = 0;
  uint8_t temp = 0, temp_last = 0;
  uint32_t length = 0;
  bool jpeg_finished = false;

  myCAM.flush_fifo();       //Flush the FIFO
  myCAM.clear_fifo_flag();  //Clear the capture done flag
  myCAM.start_capture();    //Start capture

  while (!myCAM.get_bit(ARDUCHIP_TRIG, CAP_DONE_MASK));

  length = myCAM.read_fifo_length();

  snprintf(logMessage, sizeof(logMessage), "Sending image, fifoLength: %lu", length);
  SendMessage(logMessage);

  if (length >= 0xffff)  //8M
  {
    SendMessage("Camera capture - over size");
    return;
  }
  if (length == 0)  //0 kb
  {
    SendMessage("Camera capture - size is 0");
    return;
  }

  // Send header through serial line
  writeToSerialHeader(MSG_TYPE_IMAGE, length);

  myCAM.CS_LOW();
  myCAM.set_fifo_burst();

  while (length > 0)
  {
    temp_last = temp;
    temp = SPI.transfer(0x00);

    Serial.write(&temp, 1);
    length--;

    // Handle scenario where we reached end of JPEG - 0xFF 0xD9
    if ((temp == 0xD9) && (temp_last == 0xFF))  //If find the end ,break while,
    {
      while (length > 0) {
        Serial.write(0);
        length--;
      }
    }

  }

  myCAM.CS_HIGH();
}


void serialEvent() {
  long inputRaw;
  char logMessage[64];
  if (Serial.available()) {
    inputRaw = Serial.read();
    if ((inputRaw >= '0') && (inputRaw <= '9')) {
      input = 10 * input + inputRaw - '0';
      ////Serial.println(input);
    } else if (inputRaw == 'e') {
      //Serial.println(input);
      uint8_t start_capture = 0;
      long val = input / 100;
      int inputID;
      inputID = input % 100;
      input = 0;
      ////Serial.println(val);
      ////Serial.println(inputID);


      if (inputID == 9) {
        led(val);
      }

      //if(inputID == 8) {
      //  ntc(1023); //1023 for 5V, 675 for 3.3V
      //}

      if (inputID == 7) {
        ////Serial.println(motor1_temp);
        ////Serial.println(val);
        int motor1_diff = -val - motor1_temp;
        ////Serial.println(motor1_diff);
        if (motor1_diff > -720) {  // this doesnt allow >720 deg rotation
          motor1(-val);
          intV = -val;
          motor1_temp = -val;
        } else {
          //Serial.println("motor1 error, rotation > 720deg isnt allowed!");
        }
      }
      if (inputID == 6) {
        ////Serial.println(motor1_temp);
        ////Serial.println(val);
        int motor1_diff = val - motor1_temp;
        ////Serial.println(motor1_diff);
        if (motor1_diff < 720) {  // this doesnt allow >720 deg rotation
          motor1(+val);
          intV = val;
          motor1_temp = val;
        } else {
          //Serial.println("motor1 error, rotation > 720deg isnt allowed!");
        }
      }

      if (inputID == 5) {
        motor2(val);
      }
      if (inputID == 4) {
        motor2(-val);
      }

      if (inputID == 3) { // && temperature < 35) {
        pelt(val);
      }

      if (inputID == 25) {
        interval = val;
      }
      if (inputID == 26) {
        int1 = val;
      }
      if (inputID == 27) {
        int1 = -val;
      }
      if (inputID == 28) {
        int2 = val;
      }
      if (inputID == 29) {
        int2 = -val;
      }


      if (inputID == 2) {  //cam continuous
        //Serial.println("cam cont sw pressed"); 
        //Serial.println("continuousValue before: " + String(continuous));
        if (continuous) {
          //Serial.println("continuousValue before sw when true: " + String(continuous));
          continuous = false;
        }
        else {
          //Serial.println("continuousValue before sw when false: " + String(continuous));
          continuous = true;
        }
        //Serial.println("continuousValue after sw: " + String(continuous));
      }
      if (inputID == 1) {  //cam snapshot
        if (CAM1_EXIST) {
          streamStartTime = millis();
          myCAMSendToSerial(myCAM1);
          long int elapsed = millis() - streamStartTime;
          snprintf(logMessage, sizeof(logMessage), "Camera processing and sending time: %lu", elapsed);
          SendMessage(logMessage);
        }
      }

      if (inputID == 11) {
        myCAM1.OV5642_set_JPEG_size(OV5642_320x240);
        //Serial.println(F("OV5642_320x240"));
        delay(1000);
        myCAM1.clear_fifo_flag();
      }
      if (inputID == 12) {
        myCAM1.OV5642_set_JPEG_size(OV5642_640x480);
        //Serial.println(F("OV5642_640x480"));
        delay(1000);
        myCAM1.clear_fifo_flag();
      }
      if (inputID == 13) {
        myCAM1.OV5642_set_JPEG_size(OV5642_1024x768);
        //Serial.println(F("OV5642_1024x768"));
        delay(1000);
        myCAM1.clear_fifo_flag();
      }
      if (inputID == 14) {
        myCAM1.OV5642_set_JPEG_size(OV5642_1280x960);
        //Serial.println(F("OV5642_1280x960"));
        delay(1000);
        myCAM1.clear_fifo_flag();
      }
      if (inputID == 15) {
        myCAM1.OV5642_set_JPEG_size(OV5642_1600x1200);
        //Serial.println(F("OV5642_1600x1200"));
        delay(1000);
        myCAM1.clear_fifo_flag();
      }

      //  myCAM1.OV5642_set_JPEG_size(OV5642_2048x1536);
      //  //Serial.println(F("OV5642_2048x1536")); delay(1000);
      //
      //  myCAM1.OV5642_set_JPEG_size(OV5642_2592x1944);
      //  //Serial.println(F("OV5642_2592x1944")); delay(1000);
    }
  t = millis();
  }
}
