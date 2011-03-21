/* E-paper Display Example Code
  by: Jim Lindblom - jim at sparkfun.com
  SparkFun Electronics
  date: March 14th, 2011
  License: CC-SA 3.0 - Do whatever you want with this, just keep this license.
  Attribution is always appreciated, and let me know if you improve upon the code (there's lots of room for that!).
  
  This code is designed to work with the 2-line, 10 character E-paper displays
  (http://www.sparkfun.com/products/10150), which can be connected to the optional
  breakout board (see the schematic of that, if you're wiring the display with the breakout).
  The display requires a 35V supply on V0, with a very minimal current being pulled.
  A 3.3V/5V VCC supply is also required for the logic.
  
  This example code takes two sets of 10-character inputs from serial at 9600 bps
  and displays them on inputs 1 and 2 of the e-paper.
  Currently the only displayable characters are a-b, A-B, 0-9. Displayable characters
  are defined in ePaperDriver.h.
  
  There's a lot of room for improvement, and some aspects of the display still mistify me.
  I think they should be able to do both white on black, and black on white, and that must have
  something to do with the first bit of the data transmission (BW/Y0). Playing with the BW bit
  can lead to some ugliness though, so I just leave it HIGH and leave the display white on black.
  
  Hardware setup:
  Should work with any version of Arduino, 16MHz or 8MHz, 5V or 3.3V
  Pin connections are as follows:
  E-paper Breakout--------------------Arduino
      EIO-------------------------------D9
      XCK-------------------------------D13
      VCC-------------------------------5V (3.3V will work too)
     LATCH------------------------------D8
      SLPB------------------------------D6
      DI0-------------------------------D11
      GND-------------------------------GND
   
*/
#include "ePaperDriver.h"  // This file includes defines for each displayable character

// Hardware: Using an Arduino Uno, here are the connections for display to Arduino
int EIO1pin = 9;     // Input/output pin for chip selection
int XCKpin = 13;     // Clock input pin for taking display data
int LATCHpin = 8;   // Latch pulse input pin for display data
int SLEEPBpin = 6;  // 
int DI0pin = 11;     // Input pin for display data
// DI2 - pulled high in hardware
// DI1 - tied to DI0pin in hardware
// SHL - pulled high in hardware

char topData[160] = {
//a,b,c, d, e, f, g, h, i, j, k, l, m, n, o, p
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D1
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D2
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D3
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D4
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D5
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D6
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D7
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D8
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D9
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};  // D10

char bottomData[160] = {
//a,b,c, d, e, f, g, h, i, j, k, l, m, n, o, p
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D1
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D2
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D3
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D4
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D5
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D6
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D7
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D8
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D9
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};  // D10

char topInput[10];
char bottomInput[10];

void setup()
{
  Serial.begin(9600);
  
  pinMode(EIO1pin, OUTPUT);
  pinMode(XCKpin, OUTPUT);
  pinMode(LATCHpin, OUTPUT);
  pinMode(SLEEPBpin, OUTPUT);
  pinMode(DI0pin, OUTPUT);
  
  // Initial Pin Configurations -----------------------
  digitalWrite(SLEEPBpin, HIGH);      // Sleep high turns the display on
  digitalWrite(DI0pin, HIGH);         // Initialize data high
  digitalWrite(XCKpin, LOW);
  digitalWrite(EIO1pin, HIGH);
  digitalWrite(LATCHpin, LOW);
  // --------------------------------------------------
  
  delay(100);
  
  createData(topData, "Serial9600");  // Turn a character array into display data
  createData(bottomData, "Input Data");  // Turn a character array into display data
  flipData(topData);  // If data is not flipped, it will look upside down.
  
  ePrint(topData, bottomData, 1, 1);  // First ePrint adds the new segments
  delay(100);  // Play with the delay times, shorter displays sometimes lead to ugliness, they probably don't need to be this long...
  ePrint(topData, bottomData, 1, 1);  // Second ePrint removes the un-used segments - I know, this is weird...
  delay(500);
  ePrint(topData, bottomData, 1, 0);
  delay(100);
  ePrint(topData, bottomData, 1, 0);
}

void loop()
{
  Serial.println("Please enter 10 characters for the top display");
  while(Serial.available()<10)
    ;
  for (int i=0; i<10; i++)
    topInput[i] = Serial.read();
    
  Serial.println("Now enter 10 characters for the bottom display");
  while(Serial.available()<10)
    ;
  for (int i=0; i<10; i++)
    bottomInput[i] = Serial.read();
    
  Serial.println("Printing: ");
  for (int i=0; i<10; i++)
    Serial.print(topInput[i]);
  Serial.println("");
  for (int i=0; i<10; i++)
    Serial.print(bottomInput[i]);
  Serial.println("");
  
  createData(topData, topInput);
  createData(bottomData, bottomInput);
  flipData(topData);
  
  ePrint(topData, bottomData, 1, 1);
  delay(100);
  ePrint(topData, bottomData, 1, 1);
  delay(500);
  ePrint(topData, bottomData, 1, 0);
  delay(100);
  ePrint(topData, bottomData, 1, 0);
}

/* ePrint(char * displayTop, char * displayBottom, int bw, int com)
  This function displays the data in displayTop and displayBottom onto a 10x2
  ePaper display. The first and last bits of data transmission are configurable.
  There is no return value.
  
  char * displayTop - This should be an array of 160 1's or 0's. A 1 will turn
    a segment on, a 0 will turn a segment off. Each character consists of 16 segments.
  char * displayBottom - Same as display top.
  int bw - This should be a 1 or a 0, and will decide whether the BW (the fist bit) bit is set or not.
  int com - This should be a 1 or a 0, and will decide whether the COM (the last bit) bit is set or not.
*/
void ePrint(char * displayTop, char * displayBottom, int bw, int com)
{
  digitalWrite(EIO1pin, LOW);
  if (bw)
    digitalWrite(DI0pin, HIGH);
  else
    digitalWrite(DI0pin, LOW);
  delayMicroseconds(1);
  clock();     // Y0
  digitalWrite(EIO1pin, HIGH);

  for(int i = 0; i<160; i++)
  {
    if (displayBottom[i])
      digitalWrite(DI0pin, LOW);
    else
      digitalWrite(DI0pin, HIGH);
    delayMicroseconds(1);
    clock();
  }
  if (com)
    digitalWrite(DI0pin, HIGH);
  else
    digitalWrite(DI0pin, LOW);
  clock();     // Y161
  
  //--- 2nd display ---
  
  if (bw)
    digitalWrite(DI0pin, HIGH);
  else
    digitalWrite(DI0pin, LOW);
  
  clock();     // Y0

  for(int i = 0; i<160; i++)
  {
    if (displayTop[i])
      digitalWrite(DI0pin, LOW);
    else
      digitalWrite(DI0pin, HIGH);
    delayMicroseconds(1);
    clock();
  }
  if (com)
    digitalWrite(DI0pin, HIGH);
  else
    digitalWrite(DI0pin, LOW);
  delayMicroseconds(1);
  clock();     // Y161  
  
  latch();
}

// clock(): Simple function to advance the XCK line one period
void clock()
{
  digitalWrite(XCKpin, HIGH);
  delayMicroseconds(1);
  digitalWrite(XCKpin, LOW);
  delayMicroseconds(1);
}

// latch(): Simple function to activate and deactivate the latch
void latch()
{
  digitalWrite(LATCHpin, HIGH);
  delayMicroseconds(5);
  digitalWrite(LATCHpin, LOW);
  delayMicroseconds(5);
}

/* void flipData(char * characterData)
  char * characterData is an array of 160 char*'s (10 characters, 16 segments each).
  Each variable in characterData should be either a 1 or a 0.
  
  There is no return value, however the array sent to this function will be modified
  such that the order of the array is reversed (last byte becomes first, etc.).
  
  This function is useful if you want to flip a display. It's necessary if you want both
  displays to face the same direction.
*/
void flipData(char * characterData)
{
  char tempData[160];
  
  for (int i=0; i<160; i++)
    tempData[i] = characterData[i];
    
  for (int i=0; i<160; i++)
    characterData[i] = tempData[159-i];
}

/* void createData(char * characterData, char * toDisplay)
  This function turns ASCII characters into data that is readable by the display.
  
  There are no return values. The data on char * toDisplay is transformed into
  the corresponding 1's and 0's for the display to understand, and char * characterData
  is updated to reflect that data. toDisplay will not be affected by this functione.
  
  If you want to add more displayable characters to this code, you'll need to add another
  case statment to the large switch. You should be able to pattern the statment after the
  other cases.
*/
void createData(char * characterData, char * toDisplay)
{
  for (int i=0; i<10; i++)
  {
    switch (toDisplay[i])
    {
      case ' ':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = 0;
          break;
      case 'A':
      case 'a':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = aChar[j];
        break;
      case 'B':
      case 'b':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = bChar[j];
        break;
      case 'C':
      case 'c':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = cChar[j];
        break;
      case 'D':
      case 'd':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = dChar[j];
        break;
      case 'E':
      case 'e':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = eChar[j];
        break;
      case 'F':
      case 'f':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = fChar[j];
        break;
      case 'G':
      case 'g':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = gChar[j];
        break;
      case 'H':
      case 'h':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = hChar[j];
        break;
      case 'I':
      case 'i':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = iChar[j];
        break;
      case 'J':
      case 'j':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = jChar[j];
        break;
      case 'K':
      case 'k':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = kChar[j];
        break;
      case 'L':
      case 'l':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = lChar[j];
        break;
      case 'M':
      case 'm':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = mChar[j];
        break;
      case 'N':
      case 'n':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = nChar[j];
        break;
      case 'O':
      case 'o':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = oChar[j];
        break;
      case 'P':
      case 'p':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = pChar[j];
        break;
      case 'Q':
      case 'q':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = qChar[j];
        break;
      case 'R':
      case 'r':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = rChar[j];
        break;
      case 'S':
      case 's':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = sChar[j];
        break;
      case 'T':
      case 't':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = tChar[j];
        break;
      case 'U':
      case 'u':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = uChar[j];
        break;
      case 'V':
      case 'v':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = vChar[j];
        break;
      case 'W':
      case 'w':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = wChar[j];
        break;
      case 'X':
      case 'x':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = xChar[j];
        break;
      case 'Y':
      case 'y':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = yChar[j];
        break;
      case 'Z':
      case 'z':
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = zChar[j];
        break;
      case '0':
      case 0:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = zeroChar[j];
        break;
      case '1':
      case 1:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = oneChar[j];
        break;
      case '2':
      case 2:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = twoChar[j];
        break;
      case '3':
      case 3:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = threeChar[j];
        break;
      case '4':
      case 4:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = fourChar[j];
        break;
      case '5':
      case 5:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = fiveChar[j];
        break;
      case '6':
      case 6:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = sixChar[j];
        break;
      case '7':
      case 7:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = sevenChar[j];
        break;
      case '8':
      case 8:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = eightChar[j];
        break;
      case '9':
      case 9:
        for (int j=0; j<16; j++)
          characterData[(9-i)*16 + j] = nineChar[j];
        break;
        
    }
  }
}
