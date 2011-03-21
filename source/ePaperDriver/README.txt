This is a project aimed at driving Winstar's 10x2 16-segment E-paper displays

License: All source code and design files in this repository are licensed under CC-SA-BY 3.0 (http://creativecommons.org/licenses/by-sa/3.0/).

Goal: To create a functional Arduino library to display any character strings, turn display on/off, change black on white/white on black, maybe scroll, maybe more...

Hardware: An Arduino Dumilanove is driving the display.


Epaper Input 1
--------------
1: V0 - 35V
2: V1 - NC (No connnection)
3: v2 - NC
4: VSSE - GND
5: VSS - GND
6: EIO1 - Arduino D9
7: XCK - Arduino D13
8: VDD - 5V
9: LATCH - Arduino D8
11: SHL - 5V
12: SLEEPB - Arduino D6
13: DLY0 - GND
14: DLY1 - 5V
16: DI0 - Arduino D11
17: DI1 - Tied to DI0
18: DI2 - 5V
20: EIO2 - EIO1 on Epaper Input 2
21: VSS - GND
22: VSSE - GND
23: V2 - NC
24: V1 - NC
25: V0 - 35V

Epaper input 2 is connected same as input 1 EXCEPT:
- input 2's EIO2 is not connected.
- input 2's EIO1 is connected to input 1's EIO2