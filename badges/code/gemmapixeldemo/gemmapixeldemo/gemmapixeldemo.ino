#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(12, 1);

int pixel = 0;

void setup() {
  pixels.begin();
  pixels.setBrightness(60); // 1/3 brightness
}

void loop() {
  pixels.setPixelColor(pixel, 0, 255, 0);
  pixels.show();
  pixel++;
  if (pixel > 12) {
    pixel = 0;
    for (int i = 0; i < 12; i++) {
      pixels.setPixelColor(i, 0, 0, 0);
    }
  }

  delay(200);
}
