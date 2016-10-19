#include <Adafruit_NeoPixel.h>
#include <RunningAverage.h>

#define NEOPIXEL_PIN 0
#define FLEX_PIN 1
#define AVERAGE_WINDOW 10
 
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(7, NEOPIXEL_PIN, NEO_GRBW);

uint32_t last_time;

void setup() {
  pixels.begin();
  pixels.setBrightness(60);
  last_time = millis();
}
 
void loop() {
  int flex;
  int readings[AVERAGE_WINDOW]; 
  
  flex = map(analogRead(FLEX_PIN), 180, 300, 0, 255);

  for(int i=0; i<7; i++) {
    pixels.setPixelColor(i, flex, 0, 0, 0);
  }
  
  pixels.show();
  delay(50);
}
