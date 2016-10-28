#include "Adafruit_SI1145_TinyWireM.h"
#include <Adafruit_NeoPixel.h>

Adafruit_SI1145_TinyWireM uv = Adafruit_SI1145_TinyWireM();
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(12, 1);

void setup() {
  pixels.begin();
  pixels.setBrightness(60); // 1/3 brightness
  
  if (! uv.begin()) {
    pixels.setPixelColor(1, 255, 0, 0);
    pixels.show();
    while (1);
  }

}

void loop() {
  float UVindex = uv.readUV();
  UVindex /= 100.0;  

  pixels.setPixelColor(2, 0, 0, UVindex * 25);
  pixels.show();  

  delay(1000);
}
