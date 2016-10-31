#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(7, 0, NEO_GRBW);

int pixel = 0;

void setup() {
  pixels.begin();
  pixels.setBrightness(60); // 1/3 brightness
  for (int i = 0; i<7; i++){
    pixels.setPixelColor(i, 255, 0, 0);
    pixels.show();
    delay(200);
  }  
}

void loop() {

}
