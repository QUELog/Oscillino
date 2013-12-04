import processing.serial.*;

int margin = 30, windowWidth, windowHeight;

Serial arduino;
boolean isConnected = false;
String ports [];

int a = 0;
int xPosition;
int xPositionDel;
int previousAnalogValue;
int analogValue;
int previousAverageValue;
int averageValue;

void setup() {
  windowWidth = displayWidth - 20;
  windowHeight = displayHeight - 90;
  size(windowWidth, windowHeight);
  previousAnalogValue = previousAverageValue = windowHeight / 2;
  background(255);
  ports = Serial.list();
  textSize(18);
  for(a = 0; a < ports.length; a++)
  {
    fill(160);
    rect(margin + 20, margin + a * 30 + 10, 140, 25, 7);
    fill(0);
    text(ports[a], margin + 23, margin + a * 30 + 30);
  }
}

void draw() {
  if(isConnected == false)
  {
    if(mousePressed)
    {
      int serialPortNumber = 0;
      int n = mouseY - 40;
      if(n > 30)
      {
        n -= 30;
        serialPortNumber ++;
      }
      if(n < 26 && serialPortNumber < ports.length && (mouseX > 50 && mouseY < 190))
      {
        arduino = new Serial(this, ports[serialPortNumber], 115200);
        delay(2000);
        arduino.write('b');
        delay(10);
        if(arduino.available() > 0)
        {
          char inByte = arduino.readChar();
          if(inByte == 'c')
          {
            isConnected = true;
            background(255);
            for(a = margin; a < windowWidth - margin; a++)
            {
              grid(a);
            }
            textSize(10);
            textAlign(RIGHT);
            for(a = 0; a <= 1024; a += 32)
            {
              text(str(a), margin - 2, map(a, 0, 1024, windowHeight - margin, margin) + 4);
            }
            a = 0;
          }
        }
      }
    }
    delay(50);
  }
  if(isConnected == true)
  {
    xPosition = margin + a % (windowWidth - margin * 2);
    xPositionDel = margin + (a + 1) % (windowWidth - margin * 2);
    stroke(255);
    line(xPositionDel , 0, xPositionDel, windowHeight);
    line(xPositionDel + 1, 0, xPositionDel + 1, windowHeight);
    grid(xPositionDel);
    grid(xPositionDel + 1);
    stroke(0);
    arduino.write('s');
    analogValue = int(map(serialReadInt(), 0, 1024, margin, windowHeight - margin));
    line(xPosition, windowHeight - previousAnalogValue, xPosition + 1, windowHeight - analogValue);
    stroke(0, 204, 51);
    arduino.write('v');
    averageValue = int(map(serialReadInt(), 0, 1024, margin, windowHeight - margin));
    line(xPosition, windowHeight - previousAverageValue, xPosition + 1, windowHeight - averageValue);
    previousAnalogValue = analogValue;
    previousAverageValue = averageValue;
    a++;
  }
}

void grid(int x)
{
  stroke(200);
  for(int i = 0; i <= 1024; i += 32)
  {
    point(x, map(i, 0, 1024, margin, windowHeight - margin));
  }
}


int serialReadInt()
{
  while(arduino.available() < 2);
  byte bytes [] = new byte [2];
  bytes = arduino.readBytes();
  int ints [] = new int [2];
  for(int a = 0; a < 2; a++)
  {
    if(bytes[a] < 0)
    {
      ints[a] = 256 + bytes[a];
    }
    else
    {
      ints[a] = bytes[a];
    }
  }
  return ints[0] * 256 + ints[1];
}
