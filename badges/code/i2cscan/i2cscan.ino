#include <TinyWireM.h>
#include <SoftwareSerial.h>

SoftwareSerial mySerial(-1,1);

void setup()
{
  TinyWireM.begin();
  mySerial.begin(9600);
  mySerial.println("\nI2C Scanner");
}

void loop()
{
  byte error, address;
  int nDevices;
  mySerial.println("Scanning...");
  nDevices = 0;
  for(address = 1; address < 127; address++ ) 
  {
    TinyWireM.beginTransmission(address);
    error = TinyWireM.endTransmission();

    if (error == 0)
    {
      mySerial.print("I2C device found at address 0x");
      if (address<16) 
        mySerial.print("0");
      mySerial.print(address,HEX);
      mySerial.println("  !");

      nDevices++;
    }
    else if (error==4) 
    {
      mySerial.print("Unknow error at address 0x");
      if (address<16) 
        mySerial.print("0");
      mySerial.println(address,HEX);
    }  
  }
  if (nDevices == 0)
    mySerial.println("No I2C devices found\n");
  else
    mySerial.println("done\n");

  delay(5000);           // wait 5 seconds for next scan
}
