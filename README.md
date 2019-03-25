# PneumaticSensorCode

C++ code controlling temperature, pressure, and flow sensors within Pneumatic Testing Station

## Table of contents
* [Overview](#overview)
* [Libraries and Variables](#libraries-and-variables)
* [Setup](#setup)
* [Sensor Reading Loop](#sensor-reading-loop)
* [Reference Files](#reference-files)

## Overview

The provided code includes necessary libraries and source code to produce serial data strings listing 1 flow sensor (SFM3000), 2 temperature sensors (NTC 3950), and 2 pressure sensors (MPXV7025G). The data is printed to the serial monitor and can then be read into LabVIEW through VISA Read functions (LabVIEW VIs found in separate repository). There is also commands to write to an external TFT LCD display (ST7789) controlled through SPI methods.

## Libraries and Variables

The necessary libraries are shown below with brief descriptions:

```
// General arduino library
Arduino.h

// I2C wire library for communicating with ADS1015 and Flow Sensor
Wire.h 

// Flow sensor specific library
SFM3000wedo.h 

// ADS1015 (digital to analog converter) library for reading pressure sensors
Adafruit_ADS1015.h 

// Example external display header file for testing
Free_Fonts.h 

// Standard SPI library for external display control
SPI.h 

// Display specific file to include necessary "write" commands

TFT_eSPI.h 
```

Note that the platformio.ini file containts configuration components that will automatically load necessary libraries into the platformio project

A brief outline of the variables used is shown below:

First define the ADS1015 within the workspace

```
// Define ADS1015
Adafruit_ADS1015 ads1015;
```

Pin Values for each of the analog readings are shown below. These values can be adjusted depending on the wiring of the PCB / breadboard
```
// Set pin values
int Therm1 = A9; // Set Thermistor Pin 1
int Therm2 = A10; // Set Thermistor Pin 2
int Pressure1 = 0; // Set Pressure Pin 1
int Pressure2 = 1; // Set Pressure Pin 2
```

Flow constants shown below generally do not need to be altered since they are specific for the SFM library

```
// Constants for SFM3000 Flow Sensor
SFM3000wedo measflow(64);
int incomingByte;   // for incoming Serial data
unsigned int result;
float Flow; // Flow reading
int offset = 32000; // Offset for the sensor
float scale = 140.0; // Scale factor for Air and N2 is 140.0, O2 is 142.8
```

Pressure constants are shown below including supply voltage, reading values, and measured voltage variables

```
// Constants for Pressure Sensors
int Vs = 5; // Supply voltage
char bufferSerial[200];
int marker = 0;
float P_1; // Pressure 1 Reading
float P_2; // Pressure 2 Reading
float Vout_1; // Voltage out Reading from sensor
float Vout_2; // Voltage out Reading from sensor
```

Temperature constants are shown below including supply voltage, voltage divider resistance values, constants for thermistor transfer functions (discussed in future sections), and thermistory reading variables

```
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
```

Finally, external display constants are shown below for each sensor reading

```
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
```

## Setup

The following pieces are initialized within the setup section

* Flow Sensor Readings
* Serial Monitor
* Pin Modes
* External Display

The Serial Monitor baud rate and pin mode values can be adjusted for the given setup, but generally these values can remain the same.

## Sensor Reading Loop

Each of the sensor readings are calculated through either transfer functions or library functionalitiies

### Flow

Flow values are gathered within the result variable and transfered through SFM transfer function

### Pressure

Pressure values are read through analogRead function built into ADS1015. The final pressure values are then found through the transfer function for the MPX sensors (data sheet in appendix).

### Temperature

Temperature values are found by translating the voltage readings of the NTC sensors into Fahrenheit values. Note that NTC sensors increase in resistance as temperature descreases and vise versa. The Steinhart equation is used to convert the output voltage values to temperature outputs with the use of the B constant for the thermistors and the voltage divider resistors.

### Data Output

All of these sensor values are then both printed to the serial monitor for data gathering and the TFT display for the user.

## Reference Files

* [NTC Thermistors](https://drive.google.com/file/d/1_lHE7f3WpF-EfXMwU8j3nHWwyJp8GtlP/view?usp=sharing)
* [ESP32](https://drive.google.com/file/d/1CIoa6Am3PvPp-QFPdmDZbroRR86utgej/view?usp=sharing)
* [Pressure Sensors](https://drive.google.com/file/d/1t7lr9Ug06I8soxHhNLLeWb63RK0vVjjf/view?usp=sharing)
* [Flow Sensor](https://drive.google.com/file/d/1RW7EKiJrZ52DmqxEUcTtVEUl_KeTw4Xp/view?usp=sharing)
