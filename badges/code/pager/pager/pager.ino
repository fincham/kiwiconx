#include <string.h>

#include <Arduino.h>

#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include <ESP8266WiFi.h>
#include "FS.h"

const char* ssid = "hotplate";
const char* password = "frillymatrixbathroomshuffle";

const int backlight_time = 30000; // in millis
const int wifi_time = 10000; // in millis

const int default_contrast = 50; // usable range 30 - 60

const int8_t RST_PIN = D2;
const int8_t CE_PIN = D1;
const int8_t DC_PIN = D6;
const int8_t BL_PIN = D0;

WiFiClient client;
Adafruit_PCD8544 display = Adafruit_PCD8544(DC_PIN, CE_PIN, RST_PIN);
unsigned long last_time;
unsigned long last_display_draw = 0;
unsigned long redraw_time;

String input_string = "";
String client_string = "";
String index = "0";

int backlight_blink_count = 0;
int backlight_status = HIGH;
int backlight_timeout = millis();
int wifi_timeout = 0;
bool wifi_working = false;

int d3_debounce = 0;
int d4_debounce = 0;

int left_button = 0;
int right_button = 0;

int download_state = 0;

void alert_box(char* text) {
  display.fillRoundRect(0, 16, 84, 16, 8, WHITE);
  display.drawRoundRect(0, 16, 84, 16, 8, BLACK);

  display.setCursor((7 - strlen(text) / 2) * 6, 20);
  display.print(text);
}

void draw_display() {
  digitalWrite(BL_PIN, backlight_status);

  if (millis()  < last_display_draw || millis() > last_display_draw + 100) {
    int wifi_status = 0;
    display.clearDisplay();
    display.setCursor(0, 0);
    wifi_status = WiFi.status();
    if (wifi_status == 6) {
      wifi_working = false;
      display.print("Questing");
    } else if (wifi_status == 1) {
      display.print("Nothing");
      wifi_working = false;
    } else if (wifi_status > 3) {
      display.print("Failure");
      wifi_working = false;
    } else {
      wifi_working = true;
      display.print("Bonded");
    }
    display.display();
    last_display_draw = millis();
  }
}

void read_input() {
  int d3 = digitalRead(D3);
  int d4 = digitalRead(D4);

  if (d3 == 0 && left_button == 0) {
    d3_debounce++;
  }

  if (d4 == 0 && right_button == 0) {
    d4_debounce++;
  }

  if (d3 != 0) {
    d3_debounce = 0;
  }

  if (d4 != 0) {
    d4_debounce = 0;
  }

  if (d3_debounce > 10) {
    left_button = 1;
    backlight_timeout = millis();
  } else {
    left_button = 0;
  }

  if (d4_debounce > 10) {
    right_button = 1;
    backlight_timeout = millis();
  } else {
    right_button = 0;
  }

  while (Serial.available() > 0) {
    int input_char = Serial.read();
    if (isDigit(input_char)) {
      Serial.print((char)input_char);
      input_string += (char)input_char;
    }

    if (input_char == '\n') {
      Serial.println("");
      Serial.print("Changing contrast to ");
      Serial.print(input_string);
      Serial.println("...");
      display.setContrast(input_string.toInt());
      File contrast_file = SPIFFS.open("/contrast", "w");
      contrast_file.println(input_string);
      contrast_file.close();
      input_string = "";
    }
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

  if (millis() < backlight_timeout + backlight_time) {
    backlight_status = LOW;
  } else {
    backlight_status = HIGH;
  }

  if (!client.connected() && wifi_working && millis() > wifi_timeout + wifi_time) {
    Serial.println("Contacting mothership...");
    wifi_timeout = millis();
    if (!client.connect("114.23.242.146", 1666) ) {
      Serial.println("Failed to connect to mothership.");
    } else
    {
      File index_file = SPIFFS.open("/index", "r");
      index = index_file.readStringUntil('\n');
      index_file.close();            
      Serial.println("Connected to mothership.");
      client.print(ESP.getChipId());
      client.print(" ");
      client.println(index);
    }

  }

  if (WiFi.status() == 1 && !wifi_working && millis() > wifi_timeout + wifi_time) {
    wifi_timeout = millis();
    Serial.println("Forcing a WiFi re-scan...");
    WiFi.reconnect();
  }

  // the horrible TCP state machine  
  while (client.available() > 0) {
    int client_char = client.read();
    client_string += (char)client_char;

    if (client_char == '\n') {
      client_string.trim();
      
      if (download_state == 0) { // command state
        if (client_string.equals("flash")) {
          download_state = 10;
        } else if (client_string.equals("push")) {
          download_state = 1; 
        } else {
          client.stop();
        }
      } else if (download_state == 1) { // new index is being pushed
        index = client_string;
      } else if (download_state == 10) { // flash message
        alert_box(client_string.c_str());
        display.display();
        delay(2000);
        download_state = 0;
        client.stop();
      }

      client_string = "";
    }

  }  
}

void setup() {
  last_time = millis();

  Serial.begin(9600);
  Serial.println("KIWICON X");

  pinMode(BL_PIN, OUTPUT);
  digitalWrite(BL_PIN, LOW);

  pinMode(D3, INPUT_PULLUP);
  pinMode(D4, INPUT_PULLUP);

  display.begin();
  display.setContrast(default_contrast);
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextWrap(false);
  display.setTextColor(BLACK);
  display.setCursor(0, 0);
  display.display();

  alert_box("KIWICON X");
  display.display();
  Serial.println("Opening flash...");
  SPIFFS.begin();
  File contrast_file = SPIFFS.open("/contrast", "r");
  if (!contrast_file) {
    Serial.println("Settings file open failed, formatting flash...");
    alert_box("Erasing...");
    display.display();
    SPIFFS.format();
    File contrast_file = SPIFFS.open("/contrast", "w");
    contrast_file.println(default_contrast);
    contrast_file.close();
    File index_file = SPIFFS.open("/index", "w");
    index_file.println("0");
    index_file.close();
    alert_box("Done");
    display.display();
    Serial.println("Flash reset to defaults.");
    delay(1000);
  } else {
    String contrast = contrast_file.readStringUntil('\n');
    display.setContrast(contrast.toInt());
    Serial.print("Display contrast set to ");
    Serial.println(contrast);
  }
  Serial.println("Booted!");
  Serial.println("To change the contrast enter a number between 30 and 60 followed by a newline.");
  delay(1000);

  WiFi.begin(ssid, password);
}

void loop() {
  timers();
  draw_display();
  read_input();
  delay(10);
}

