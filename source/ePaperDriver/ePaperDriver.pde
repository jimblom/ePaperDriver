// E-paper Display Test
#include "ePaperDriver.h"

int EIO1pin = 9;     // Input/output pin for chip selection
int XCKpin = 13;     // Clock input pin for taking display data
int LATCHpin = 8;   // Latch pulse input pin for display data
int SLEEPBpin = 6;  // 
int DI0pin = 11;     // Input pin for display data
// DI2pin pulled high in hardware
// DI1pin tied to DI0pin in hardware
// SHLpin pulled high in hardware

char topData[161] = {
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

void setup()
{
  Serial.begin(9600);
  
  pinMode(EIO1pin, OUTPUT);
  pinMode(XCKpin, OUTPUT);
  pinMode(LATCHpin, OUTPUT);
  pinMode(SLEEPBpin, OUTPUT);
  pinMode(DI0pin, OUTPUT);
  
  // Initial Pin Configurations -----------------------
  digitalWrite(SLEEPBpin, HIGH);      // Sleep high turns the display off
  digitalWrite(DI0pin, HIGH);         // Initialize data high
  digitalWrite(XCKpin, LOW);
  digitalWrite(EIO1pin, HIGH);
  digitalWrite(LATCHpin, LOW);
  // --------------------------------------------------
  
  delay(100);
}

void loop()
{
  createData(topData, "  hello   ");
  createData(bottomData, "  world   ");
  //createData(topData, " sparkfun ");
  //createData(bottomData, "electronic");
  flipData(topData);
  
  ePrint(topData, bottomData, 1, 1);
  latch();
  delay(500);
  
  ePrint(topData, bottomData, 1, 0);
  latch();
  delay(500);
  
  ePrint(topData, bottomData, 1, 1);
  latch();
  delay(500);
  
  ePrint(topData, bottomData, 1, 0);
  latch();
  delay(500);
  
  while(1)
    ;
}

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
}

void clock()
{
  digitalWrite(XCKpin, HIGH);
  delayMicroseconds(1);
  digitalWrite(XCKpin, LOW);
  delayMicroseconds(1);
}

void latch()
{
  digitalWrite(LATCHpin, HIGH);
  delayMicroseconds(5);
  digitalWrite(LATCHpin, LOW);
  delayMicroseconds(5);
}

void flipData(char * characterData)
{
  char tempData[160];
  
  for (int i=0; i<160; i++)
    tempData[i] = characterData[i];
    
  for (int i=0; i<160; i++)
    characterData[i] = tempData[159-i];
}

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
    }
  }
        
}
