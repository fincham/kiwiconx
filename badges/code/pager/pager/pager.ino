#include <Arduino.h>

#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include <ESP8266WiFi.h>
 
const char* ssid = "Ambassadors";
const char* password = "ilikeotters";
 
const int8_t RST_PIN = D2;
const int8_t CE_PIN = D1;
const int8_t DC_PIN = D6;
const int8_t BL_PIN = D0;

Adafruit_PCD8544 display = Adafruit_PCD8544(DC_PIN, CE_PIN, RST_PIN);
unsigned long last_time;

int backlight_blink_count = 0;
int backlight_status = HIGH;
int backlight_timeout = 300;

void setup() {
  last_time = millis();
  
  Serial.begin(9600);
  Serial.println("KIWICON X - Space pager firmware by fincham");

  pinMode(BL_PIN, OUTPUT);
  digitalWrite(BL_PIN, LOW);
  
  pinMode(D3, INPUT_PULLUP);
  pinMode(D4, INPUT_PULLUP);

  display.begin();
  display.setContrast(60);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(BLACK);
  display.setCursor(0,0);
  display.display();
  WiFi.begin(ssid, password);  
}

void draw_display() {
  digitalWrite(BL_PIN, backlight_status);
  
  int wifi_status = 0;
  display.clearDisplay();
  display.setCursor(0,0);
  wifi_status = WiFi.status();
  if (wifi_status == 6) {
    display.print("Search...");
  } else if (wifi_status == 1) {
    display.print("Nothing.");    
  } else if (wifi_status > 3) {
    display.print("Failure.");
  } else {
    display.print("Bonded.");
  }
  display.display();
  
}

void read_input() {
  if (digitalRead(D3) == 0) {
    backlight_timeout = 300;
  }
}

void timers() {
  static int backlight_blink_delay = 0;

  if (backlight_blink_count < 20) {
    if (backlight_blink_delay > 2) {
      if (backlight_status == HIGH) {
        backlight_status = LOW;
      } else {
        backlight_status = HIGH;
      }
      backlight_blink_count++;
      backlight_blink_delay = 0;
    } else {
      backlight_blink_delay++;
    }
  }

  if (backlight_timeout > 0) {
    backlight_status = LOW;
    backlight_timeout--;      
  } else {
    backlight_status = HIGH;    
  }
}

void loop() {
  timers();  
  draw_display();
  read_input();
  delay(100);
}

