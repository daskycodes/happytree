#include <Wire.h>
#include <Arduino.h>
#include "rgb_lcd.h"
 
rgb_lcd lcd;
 
const int colorR = 255;
const int colorG = 0;
const int colorB = 0;

const int Pushbutton = 14;
 
void setup() 
{

    pinMode(Pushbutton, INPUT);
    // set up the LCD's number of columns and rows:
    lcd.begin(16, 2);

 
    lcd.setRGB(0, 0, 255);
 
    //delay(1000);
}
 
void loop() 
{



if(digitalRead(Pushbutton)){
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(":)");
  lcd.setCursor(0,1);
  lcd.print("Pflanze gluecklich");
  lcd.setRGB(127, 255, 0);  
  delay(1000);

}else{
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(":(");
  lcd.setCursor(0,1);
  lcd.print("Bitte giessen");
  lcd.setRGB(255, 0, 0);
  delay(1000);
}



}