#include <Adafruit_NeoPixel.h>
#include <EEPROM.h>

#define NEOPIXEL_PIN 0
#define FLEX_PIN 1
const int numReadings = 20;

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(7, NEOPIXEL_PIN, NEO_GRBW);

uint32_t last_time;
uint32_t flex, last_flex;

int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

uint32_t highest = 0;
uint32_t lowest = 2^32;

bool startsetting = false;

bool settled = false;

int wp = EEPROM.read(0);

uint32_t Wheel(byte WheelPos) {
  if(WheelPos < 85) {
   return pixels.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
  } else if(WheelPos < 170) {
   WheelPos -= 85;
   return pixels.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  } else {
   WheelPos -= 170;
   return pixels.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
}

void clear() {
  for (int i = 0; i < 7; i++) {
    pixels.setPixelColor(i, 0, 0, 0, 0);
  }
}

void onecolor(uint32_t color) {
  for (int i = 0; i < 7; i++) {
    pixels.setPixelColor(i, color);
  }
}

void animup(uint32_t color) {
  for (int i = 0; i < 7; i++) {
    pixels.setPixelColor(i, color);
    pixels.show();
    delay(50);
  }
}

void setup() {
  if (EEPROM.read(1) != 0xAA) {
    EEPROM.write(1, 0xAA);
    EEPROM.write(0, 170);
    wp = 170;
  }
  pixels.begin();
  pixels.setBrightness(128);
  clear();
  pixels.show();
  last_time = millis();

  // little startup animation
  animup(Wheel(wp));
  for (int i = 0; i < 7; i++) {
    pixels.setPixelColor(i,0);
    pixels.show();
    delay(50);
  }

}

void loop() {
  if (settled && millis() - last_time > 30000) {
    settled = false;
    last_time = millis();
  }
  
    int i = random(14);
    pixels.setPixelColor(i, Wheel(wp));
    pixels.show();
    delay(10);
    pixels.setPixelColor(i, 0);
    delay(20);

  flex = analogRead(FLEX_PIN);

  if (!settled && flex > highest) {
    highest = flex;
  }

  if (!settled && flex < lowest) {
    lowest = flex;
  }


  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = flex;
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // calculate the average:
  average = total / numReadings;  

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
    if (settled == false) {
      settled = true;
      last_flex = average;
    }
  }



  if (settled && (average > highest + 1)) {
    if (!startsetting) {
      animup(Wheel(wp));
      startsetting = true;
    }
    onecolor(Wheel(wp));
    pixels.show();
    delay(10);
    wp = (wp + (average-last_flex)/2) % 255;
  }


  if (settled && (average < lowest - 1)) {
    if (!startsetting) {
      animup(Wheel(wp));
      startsetting = true;
      last_time = millis();
    }
    onecolor(Wheel(wp));
    pixels.show();
    delay(10);
    wp = (wp + (average-last_flex)/2);
    if (wp < 0) {
      wp = 255;
    }
  }

  if (settled && (average < last_flex + 2) && (average > last_flex - 2)) {
    startsetting = false;
    EEPROM.write(0, wp);
  }


}
