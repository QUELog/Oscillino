import processing.serial.*;

final int MARGIN = 30;
final int AXES_COLOR = 200;

//Serial arduino = new Serial(this, "/dev/ttyACM0", 115200);
int windowWidth;
int windowHeight;
int xPosition;
int xPositionDel;
int previousAnalogValue;
int analogValue;
int previousAverageValue;
int averageValue;

void setup() {
  windowWidth = displayWidth - 20;
  windowHeight = displayHeight - 90;
  /* Impostazione della finestra */
  size(windowWidth, windowHeight);
  background(255);
  /* Testo la connessione ad Arduino */
  //while(arduino.available() < 0);
  //char inByte = arduino.readChar();
  //if(inByte == 'z')
  //{
    //arduino.write('w');
    /* Arduino si è autenticato, disegno gli assi del grafico */
    for(int a = MARGIN; a < windowWidth - MARGIN; a++)
    {
      grid(a);
    }
    fill(AXES_COLOR);
    textSize(10);
    textAlign(RIGHT);
    /* Scrivo i valori corrispondenti per le linee orizzontali */
    for(int a = 0; a <= 1024; a += 32)
    {
      text(str(a), MARGIN - 2, map(a, 0, 1024, windowHeight - MARGIN, MARGIN) + 4);
    }
  //}
  xPosition = MARGIN;
}

void draw() {
  /* DA RIFARE */
  xPosition++;
  if(xPosition > windowWidth - 2*MARGIN) {
    xPosition = MARGIN;
  }
  xPositionDel = xPosition + 1;
  stroke(255);
  line(xPositionDel , 0, xPositionDel, windowHeight);
  line(xPositionDel + 1, 0, xPositionDel + 1, windowHeight);
  grid(xPositionDel);
  grid(xPositionDel + 1);
  stroke(0);
  //arduino.write('s');
  analogValue = 560;//int(map(serialReadInt(), 0, 1024, MARGIN, windowHeight - MARGIN));
  line(xPosition, windowHeight - previousAnalogValue, xPosition + 1, windowHeight - analogValue);
  stroke(0, 204, 51);
  previousAnalogValue = analogValue;
}

/* Disegna la parte degli assi orizzontali per una certa riga di pixel X */
void grid(int x)
{
  stroke(AXES_COLOR);
  for(int i = 0; i <= 1024; i += 32)
  {
    point(x, map(i, 0, 1024, MARGIN, windowHeight - MARGIN));
  }
}


//int serialReadInt()
//{
//  while(arduino.available() < 2);
//  byte bytes [] = new byte [2];
//  bytes = arduino.readBytes();
//  int ints [] = new int [2];
//  for(int a = 0; a < 2; a++)
//  {
//    if(bytes[a] < 0)
//    {
//      ints[a] = 256 + bytes[a];
//    }
//    else
//    {
//      ints[a] = bytes[a];
//    }
//  }
//  return ints[0] * 256 + ints[1];
//}
