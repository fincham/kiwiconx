#include <Adafruit_NeoPixel.h>

#define NEOPIXEL_PIN 0
#define FLEX_PIN 1
#define AVERAGE_WINDOW 10

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(7, NEOPIXEL_PIN, NEO_GRBW);

uint32_t last_time;
uint32_t flex, last_flex;

void clear() {
  for (int i = 0; i < 7; i++) {
    pixels.setPixelColor(i, 0, 0, 0, 0);
  }
}

void setup() {
  pixels.begin();
  pixels.setBrightness(60);
  clear();
  pixels.show();
  last_time = millis();
  flex = analogRead(FLEX_PIN);
  last_flex = flex;
}

void loop() {


  flex = analogRead(FLEX_PIN);

  if (flex > last_flex + 2 || flex < last_flex - 2) {
    for (int i = 0; i < 7; i++) {
      pixels.setPixelColor(i, 255, 0, 0, 0);
    }
    pixels.show();
    delay(100);
    clear();
    pixels.show();
    delay(100);
    for (int i = 0; i < 7; i++) {
      pixels.setPixelColor(i, 255, 0, 0, 0);
    }
    pixels.show();
    delay(100);
    pixels.clear();
    pixels.show();
  }



  delay(50);
}
