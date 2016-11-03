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
String message_index = "0";
String message_buffer = "";
String directory_cache = "";
String body = "";
int backlight_blink_count = 0;
int backlight_status = HIGH;
unsigned long backlight_timeout = millis();
unsigned long wifi_timeout = 0;
bool wifi_working = false;
bool directory_dirty = true;

int d3_debounce = 0;
int d4_debounce = 0;

int left_button = 0;
int right_button = 0;

int download_state = 0;
int message_count_cache = 0;

int ui = 0;

int current_message = 0;
int last_message = 0;
int depth = 0;
bool ret_message = true;

char left_icons[] = "?x<";
char right_icons[] = "> >";

int message_count() {
  int count = 0;
  Dir dir = SPIFFS.openDir("/messages");
  while (dir.next()) {
    count++;
  }
  return count;
}

void alert_box(char* text) {
  display.fillRoundRect(0, 16, 84, 16, 8, BLACK);
  display.drawRoundRect(0, 16, 84, 16, 8, BLACK);
    display.setTextColor(WHITE);

  display.setCursor(42 - strlen(text) * 3, 20);
  display.print(text);
    display.setTextColor(BLACK);
  
}

void mid_print(char* text, int y) {
  display.setCursor(42 - strlen(text) * 3, y);
  display.print(text);
}


void draw_display() {
  digitalWrite(BL_PIN, backlight_status);

  if (millis()  < last_display_draw || millis() > last_display_draw + 100) {

    display.clearDisplay();

    if (left_icons[ui] != ' ') {
      display.fillRoundRect(0, 39, 9, 9, 1, BLACK);
    }

    if (right_icons[ui] != ' ') {
      display.fillRoundRect(75, 39, 9, 9, 1, BLACK);
    }
    
    display.setTextColor(WHITE);

    display.setCursor(77, 40); 
    display.print(right_icons[ui]);

    display.setCursor(2, 40); // bottom row
    display.print(left_icons[ui]);

    
    display.setCursor(0, 0);

    display.setTextColor(BLACK);

    if (ui == 0) { // message list
      int newlines = 0;
      String line = "";
      
      read_directory();
      for (int i = 0; i < directory_cache.length(); i++) {
        line += directory_cache[i];
        if (directory_cache[i] == '\n') {
          if (line[0] == '*') {
            display.setTextColor(WHITE);
            display.fillRoundRect(0, newlines * 8, 84, 8, 1, BLACK);
            display.setCursor(2, newlines * 8);
            
            display.print(line.substring(1, line.length()-2));
            display.setTextColor(BLACK);
            
          } else {
            display.setCursor(2, newlines * 8);
            display.print(line.substring(1, line.length()-2));            
          }
          line = "";
          newlines++;
        }
      }

      String message_stats = String(message_count_cache);
      message_stats += " msg";
      if (message_count_cache > 1) {
        message_stats += "s";
      }
      char message[15];
      message_stats.toCharArray(message, 14);      
      mid_print(message, 40);

    
      if (left_button == 2) { // "help"
        left_button = 0;
        ui = 1;
      }

      if (right_button == 2) { // "read"
        right_button = 0;
        ui = 2;
        ret_message = true;
        current_message = message_index.toInt();
      }      
    } else if (ui == 1) { // help screen

      int wifi_status = 0;

      display.println("L/R to view");
      display.println("updates from");
      display.println("mothership.");
      display.println("");
      display.setCursor(0, 28);

      display.print("Net ");

      wifi_status = WiFi.status();
      if (wifi_status == 6) {
        wifi_working = false;
        display.println("questing.");
      } else if (wifi_status == 1) {
        display.println("missing.");
        wifi_working = false;
      } else if (wifi_status > 3) {
        display.println("failed.");
        wifi_working = false;
      } else {
        wifi_working = true;
        display.println("bonded.");
      }
            
      if (left_button == 2) { // "exit"
        left_button = 0;
        ui = 0;
      }      

      if (right_button == 2) { // "do nothing"
        right_button = 0;
      }         
    } else if (ui == 2) { // read screen
      if (ret_message) { // message needs to be loaded
        Serial.print("looking for messages after ");
        Serial.println(current_message);
        
        for (int i = current_message + 1; i > 0; i--) {
          Serial.print("trying ");
          Serial.println(i-1);
          String path = String(i-1);
          path = "/messages/" + path;
          if (SPIFFS.exists(path)) {
            File f = SPIFFS.open(path, "r+");
            String unread = f.readStringUntil('\n');
            unread.trim();
            if (unread.equals("Unread")) {
              directory_dirty = true;
              f.seek(0, SeekSet);
              f.print("Read  ");
              unread = f.readStringUntil('\n');
            }
  
            String subject = f.readStringUntil('\n');
            subject.trim();
            String date = f.readStringUntil('\n');
            date.trim();          
  
            display.setTextWrap(true);
  
            body = "Subject: ";
            body += subject + "\nSent: ";
            body += date + "\n";
            
            while(f.available()) {
              body += f.readStringUntil('\n') + "\n";
            }
          
            f.close();
      

            current_message = i-1;     
            ret_message = false; 
            break;
          }
        }
      }

      display.print(body);
      String message_stats = String(current_message);
      message_stats = "Msg " + message_stats;
      char message[15];
      message_stats.toCharArray(message, 14);      
      mid_print(message, 40);      

      if (left_button == 2) { // "back"
        left_button = 0;
        if (depth <= 0) {
          ui = 0;
        } else {
          depth--;
          Serial.print("going back to ");
          Serial.println(last_message);
          current_message = last_message;
          ret_message=true;
        }
      }      

      if (right_button == 2) { // "forward"
        right_button = 0;
        depth++;
        last_message = current_message;
        current_message--;
        ret_message=true;
      }         
        
    }
    display.display();
    last_display_draw = millis();
  }
}

void wait_for_key(int timeout) {
  unsigned long last = millis();

  while (digitalRead(D3) != LOW && digitalRead(D4) != LOW && last + timeout > millis()) {
    delay(5);
  }
}

void read_directory() {
  if (!directory_dirty) {
    return;
  }
  directory_cache = "";
  for (int i = message_index.toInt() + 1; i > 0; i--) {
    String path = String(i-1);
    path = "/messages/" + path;
    if (SPIFFS.exists(path)) {
      File f = SPIFFS.open(path, "r");
      String unread = f.readStringUntil('\n');
      String subject = f.readStringUntil('\n');
      unread.trim();
      subject.trim();
      f.close();
      if (unread.equals("Unread")) {
        directory_cache += "*";
      } else {
        directory_cache += " ";
      }
      if (subject.length() > 14) { // the initial char sets the format, gets stripped off
        subject = subject.substring(0,14);
      }
      directory_cache += subject + "\n";
    }
  }
  directory_dirty = false;
  message_count_cache = message_count();
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
  }
  
  if (d4_debounce > 10) {
    right_button = 1;
    backlight_timeout = millis();
  }

  if (d3 && left_button == 1) {
    left_button = 2;
  }

  if (d4 && right_button == 1) {
    right_button = 2;
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

  if (!client.connected()) {
    download_state = 0;
  }

  if (!client.connected() && millis() > wifi_timeout + wifi_time) {
    Serial.println("Contacting mothership...");
    wifi_timeout = millis();
    if (!client.connect("114.23.242.146", 1666) ) {
      Serial.println("Failed to connect to mothership.");
    } else
    {         
      Serial.println("Connected to mothership.");
      download_state = 0;
      client.print(ESP.getChipId());
      client.print(" ");
      client.println(message_index);
    }

  }

  if (WiFi.status() == 1 && millis() > wifi_timeout + wifi_time) {
    wifi_timeout = millis();
    Serial.println("Forcing a WiFi re-scan...");
    WiFi.reconnect();
  }

  // the horrible TCP state machine  
  while (client.connected() && client.available() > 0) {
    int client_char = client.read();
    client_string += (char)client_char;

    if (client_char == '\n') {
      client_string.trim();
      
      if (download_state == 0) { // command state
        if (client_string.equals("flash")) {
          client.print("Enter flash message: ");
          download_state = 10;
        } else if (client_string.equals("push")) {
          client.print("Enter new message index: ");
          download_state = 1; 
        } else if (client_string.equals("dir")) {
          client.println("Directory listing of flash:");
          Dir dir = SPIFFS.openDir("/");
          while (dir.next()) {
              client.println(dir.fileName());
          }    
        } else if (client_string.equals("cat")) {
          client.print("Filename to cat: ");
          download_state = 20;   
        } else if (client_string.equals("clean")) {
          Dir dir = SPIFFS.openDir("/messages");
          while (dir.next()) {
              SPIFFS.remove(dir.fileName());
          }
          message_index = "0";
          File index_file = SPIFFS.open("/index", "w");
          index_file.println(message_index);
          index_file.close();        
          client.println("Removed all messages.");
          directory_dirty = true;

        } else if (client_string.equals("factory")) {
          client.println("Factory reset. Bye!");
          alert_box("Factory reset");
          SPIFFS.remove("/contrast");
          ESP.reset();
        } else if (client_string.equals("done")) {
          client.println("Cya!");
          client.stop();        
        } else {
          client.println("Unrecognised command.");
        }
      } else if (download_state == 1) { // new index is being pushed
        message_index = client_string;
        File index_file = SPIFFS.open("/index", "w");
        index_file.println(message_index);
        index_file.close();
        download_state = 2;
        client.println("Send message data followed by a . on its own line.");
      } else if (download_state == 2) { // message data
        if (!client_string.equals(".")) {
          message_buffer += client_string + "\n";
        } else {
          String message_filename = "/messages/" + message_index;
          File message_file = SPIFFS.open(message_filename, "w");
          message_file.print(message_buffer);
          message_file.close();
                  
          client.print("OK ");
          client.println(message_index);
          Serial.print("Received message ID ");
          Serial.println(message_index);
          message_buffer = "";
          download_state = 0;
          directory_dirty = true;
        }
      } else if (download_state == 10) { // debug flash message
        digitalWrite(BL_PIN, LOW);
        backlight_status = LOW;
        backlight_timeout = millis();
        char message[15];
        client_string.toCharArray(message, 14);
        alert_box(message);
        display.display();
        wait_for_key(5000);
        download_state = 0;
      } else if (download_state == 20) { // debug cat
        String cat_string = "";    
        File cat_file = SPIFFS.open(client_string, "r");
        while(cat_file.available()) {
          client.println(cat_file.readStringUntil('\n'));
        }
        cat_file.close();
        download_state=0;
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
  if ((digitalRead(D3) == LOW && digitalRead(D4) == LOW) || !contrast_file) {
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
    File message_file = SPIFFS.open("/messages/0", "w");
    message_file.println("Unread");
    message_file.println("Welcome to the Ambassador defence system!");
    message_file.println("1970-01-01");
    message_file.println("");
    message_file.println("Congratulations on your purchase of this state of the art interplanetary alerting and paging network.");

    message_file.close();
    alert_box("Done");    
    display.display();
    Serial.println("Flash reset to defaults.");
    delay(1000);
  } else {
    String contrast = contrast_file.readStringUntil('\n');
    display.setContrast(contrast.toInt());
    Serial.print("Display contrast set to ");
    Serial.println(contrast);

    File index_file = SPIFFS.open("/index", "r");
    message_index = index_file.readStringUntil('\n');
    index_file.close();
    Serial.print("Current message index is ");
    Serial.println(message_index);
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

