#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(12, 1);

int pixel = 0;

void setup() {
  pixels.begin();
  pixels.setBrightness(255); // 1/3 brightness
  for (int i = 0; i++; i < 13) {
    pixels.setPixelColor(i, 255, 0, 0);
    pixels.show();
    delay(200);
  }  
}

void loop() {

}
