// Final testing station sensor code

// Include all libraries
#include <Arduino.h>
#include <Wire.h>
#include <SFM3000wedo.h>
#include <Adafruit_ADS1015.h>

// Define ADS1015
Adafruit_ADS1015 ads1015;

// Set pin values
int Therm1 = A9; // Set Thermistor Pin 1
int Therm2 = A10; // Set Thermistor Pin 2
int Pressure1 = 0; // Set Pressure Pin 1
int Pressure2 = 1; // Set Pressure Pin 2

// Constants for SFM3000 Flow Sensor
SFM3000wedo measflow(64);
int incomingByte;   // for incoming Serial data
unsigned int result;
float Flow; // Flow reading
int offset = 32000; // Offset for the sensor
float scale = 140.0; // Scale factor for Air and N2 is 140.0, O2 is 142.8

// Constants for Pressure Sensors
int Vs = 5; // Supply voltage
char bufferSerial[200];
int marker = 0;
float P_1; // Pressure 1 Reading
float P_2; // Pressure 2 Reading
float Vout_1; // Voltage out Reading from sensor
float Vout_2; // Voltage out Reading from sensor

// Constants for Thermistors
float Vi = 5; // Supply Voltage
float R2 = 10000; // Define Series Resistor value in Ohms
float To = 297; // Room temp in Kelvin
float Ro = 100000; // Room temp resistance of thermistor
float B = 3950; // B constant for 100k thermistor
float Vo_1; // V out Therm 1
float Vo_2; // V out Therm 2
float R1_1; // Resistance of Therm1
float R1_2; // Resistance of Therm2
float T_1; // Therm 1 Reading
float T_2; // Therm 2 Reading

// Initialize Screen Libraries and Disp Constants
#include "Free_Fonts.h" // Include the header file attached to this sketch
#include "SPI.h"
#include "TFT_eSPI.h"
TFT_eSPI tft = TFT_eSPI();
unsigned long drawTime = 0;
String Flow_Disp;
String T_Disp;
String P1_Disp;
String P2_Disp;
String T1_Disp;
String T2_Disp;

void setup() {

  // Setup Serial Monitor
  Wire.begin();
  Serial.begin(9600);
  delay(500); // let serial console settle

  // Set pin modes
  pinMode(Pressure1,INPUT); // Set Pressure1 to input
  pinMode(Pressure2,INPUT); // Set Pressure2 to input
  pinMode(Therm1,INPUT); // Set Therm1 to input
  pinMode(Therm2,INPUT); // Set Therm2 to input

  // Initialize the Flow Sensor
  measflow.init();

  // Set up screen display
  tft.begin();
  tft.setRotation(1);
  tft.setTextDatum(CR_DATUM);
  tft.setTextColor(TFT_BLACK, TFT_WHITE);
  // tft.fillScreen(TFT_WHITE);            // Clear screen
  // tft.setFreeFont(FF6);                 // Select the font
  // tft.drawString("TEST TEST TEST", 120, 120, GFXFF);

}

void loop() {

  // FLOW SENSOR
  // Gather results from Flow Sensor
  result = measflow.getvalue();
  // Translate results to Flow reading
  Flow = ((float)result - offset) / scale;

  // PRESSURE SENSORS
  // Gather Pressure Sensor readings
  P_1 = ads1015.readADC_SingleEnded(Pressure1); // Read Pressure Sensor value
  Vout_1 = (P_1 / 1728) * Vs; // Convert to voltage out
  P_1 = (1 / 0.018) * ((Vout_1 / Vs) - 0.5); // Convert to Pressure (kPA)

  P_2 = ads1015.readADC_SingleEnded(Pressure2);
  Vout_2 = (P_2 / 1728) * Vs;
  P_2 = (1 / 0.018) * ((Vout_2 / Vs) - 0.5);

  // TEMP SENSORS
  // Read Voltage out for both thermistors
  Vo_1 = analogRead(Therm1); // Read Therm 1 to get voltage out (1)
  Vo_2 = analogRead(Therm2); // Read Therm 2 to get voltage out (2)
  Vo_1 = (Vo_1/4095) * Vi; // Vo convert reading to Voltage out value
  Vo_2 = (Vo_2/4095) * Vi;
  // Convert to resistance
  R1_1 = ((Vi - Vo_1) * R2) / Vo_1;
  R1_2 = ((Vi - Vo_2) * R2) / Vo_2;
  // Convert resistance to temperature through Steinhart equation
  T_1 = (1/To) + (1/B) * log(R1_1 / Ro);
  T_1 = 1/T_1;
  T_1 = (1.8 * (T_1 - 273)) + 32; // Convert from Kelvin to F
  T_2 = (1/To) + (1/B) * log(R1_2 / Ro);
  T_2 = 1/T_2;
  T_2 = (1.8 * (T_2 - 273)) + 32; // Convert from Kelvin to F

  // DATA OUTPUT
  // sprintf(bufferSerial, "D %f,%f,%f,%f,%f,%f,%i",millis()/1000.00,Flow,P1,P2,Temp1,Temp2,marker);
  Serial.print("D "); // Print Data case value
  Serial.print(millis()/1000.00); Serial.print(","); // Print Time
  // // Serial.print("F  "); Serial.println(Flow);
  Serial.print(Flow); Serial.print(","); // Print Flow
  // Serial.print("P  "); Serial.print(P_1); Serial.print(","); Serial.println(P_2);
  Serial.print(P_1); Serial.print(","); Serial.print(P_2); Serial.print(","); // Print Pressure
  // Serial.print("T  "); Serial.print(T_1); Serial.print(","); Serial.println(T_2);
  Serial.print(T_1); Serial.print(","); Serial.print(T_2); Serial.print(","); // Print Temp
  Serial.println(marker); // Print Marker with line terminator
  // Serial.println("  ");

  // SCREEN OUTPUT
  // Time display
  T_Disp = String(millis()/1000.00);
  T_Disp = "Time(sec): " + T_Disp;
  tft.fillScreen(TFT_WHITE); // Clear screen
  tft.setFreeFont(FF6); // Select the font
  tft.drawString(T_Disp, 120, 60, GFXFF);

  // Flow display
  Flow_Disp = String(Flow);
  Flow_Disp = "Flow: " + Flow_Disp;
  tft.setFreeFont(FF6);
  tft.drawString(Flow_Disp, 100, 120, GFXFF);

  // Pressure display
  P1_Disp = String(P_1);
  P1_Disp = "P1:   " + P1_Disp;
  tft.setFreeFont(FF6);
  tft.drawString(P1_Disp, 120, 140, GFXFF);
  P2_Disp = String(P_2);
  P2_Disp = "P2:   " + P2_Disp;
  tft.setFreeFont(FF6);
  tft.drawString(P2_Disp, 120, 160, GFXFF);

  // Time display
  T1_Disp = String(T_1);
  T1_Disp = "T1:   " + T1_Disp;
  tft.setFreeFont(FF6);
  tft.drawString(T1_Disp, 120, 180, GFXFF);
  T2_Disp = String(T_2);
  T2_Disp = "T2:   " + T2_Disp;
  tft.setFreeFont(FF6);
  tft.drawString(T2_Disp, 120, 200, GFXFF);

  delay(10); // Slight delay for Serial Monitor Reading

}
