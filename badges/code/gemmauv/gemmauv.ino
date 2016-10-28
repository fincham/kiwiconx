#include "Adafruit_SI1145_TinyWireM.h"
#include <Adafruit_NeoPixel.h>

Adafruit_SI1145_TinyWireM uv = Adafruit_SI1145_TinyWireM();
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(12, 1);

float last = 0;
float current = 0;
int loops = 0;

uint32_t uvcolour(int index) {
  if (index >= 0 && index < 3.0) {
    return pixels.Color(0, 255, 0);
  } else if (index >= 3.0 && index < 6.0) {
    return pixels.Color(255, 255, 0);    
  } else if (index >= 6.0 && index < 8.0) {
    return pixels.Color(255, 165, 0); 
  } else if (index >= 8.0 && index < 11) {
    return pixels.Color(255, 0, 0);  
  } else if (index >= 11.0) {
    return pixels.Color(132, 112, 255);              
  }
}

void clear() {
  for (int i = 0; i < 13; i++) {
    pixels.setPixelColor(i,0);
  }
}

void draw() {
  for (int i = last; i < current; i++) {
    pixels.setPixelColor(i, uvcolour(current));
  }  
}

void setup() {
  pixels.begin();
  pixels.setBrightness(60); // 1/3 brightness
 
  if (! uv.begin()) {
    pixels.setPixelColor(1, 255, 0, 0);
    pixels.show();
    while (1);
  }

  // little startup animation
  for (int i = 0; i < 13; i++) {
    pixels.setPixelColor(i, uvcolour(i));
    pixels.show();
    delay(50);
  }
  for (int i = 0; i < 13; i++) {
    pixels.setPixelColor(i,0);
    pixels.show();
    delay(50);
  }
  
}

void loop() {
  loops++;  
  
  if (loops == 1 || (current >= 6 && (loops % 2 == 0))) {
    draw();
    pixels.show();  
  }
  
  if (loops == 5 || (current >= 6 && (loops % 2 == 1))) {
    clear();
    pixels.show();  
  }

  if (loops == 10) {
    current = uv.readUV();
    current /= 100.0;  
  }
  
  if (loops == 20) {
    loops = 0; 
  }

  delay(100);
}
