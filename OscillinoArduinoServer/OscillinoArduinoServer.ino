#define analogInPin 0
#define connectedLedPin 13
#define analogInAverageBufferLength 200
#define analogInAverageBufferWriteDelay 100

char inChar = 'a';
int analogInAverageBuffer[analogInAverageBufferLength];
int analogInAverageBufferWriteIndex = 0;
long analogInAverage = 0;
long lastAnalogInAverageBufferWrite = 0;

void setup() {
  Serial.begin(115200);
  pinMode(connectedLedPin, OUTPUT);
  digitalWrite(connectedLedPin, LOW);
  while (inChar != 'b') {
    if (Serial.available()) {
      inChar = Serial.read();
    }
  }
  Serial.write('c');
  digitalWrite(connectedLedPin, HIGH);
}

void loop() {
  if (millis() - lastAnalogInAverageBufferWrite >= analogInAverageBufferWriteDelay) {
    analogInAverageBuffer[analogInAverageBufferWriteIndex] = analogRead(analogInPin);
    lastAnalogInAverageBufferWrite = millis();
  }
  if(analogInAverageBufferWriteIndex + 1 < analogInAverageBufferLength) {
    analogInAverageBufferWriteIndex++;
  } else {
    analogInAverageBufferWriteIndex = 0;
  }
  if (Serial.available()) {
    inChar = Serial.read();
    if (inChar == 's') {
      serialWriteInt(analogRead(analogInPin));
    } else if (inChar == 'v') {
      analogInAverage = 0;
      for (int a = 0; a < analogInAverageBufferLength; a++) {
        if(analogInAverageBuffer[a] > 512){
          analogInAverageBuffer[a] -= 512;
        } else {
          analogInAverageBuffer[a] = 0;
        }
        analogInAverage += analogInAverageBuffer[a];
      }
      analogInAverage /= analogInAverageBufferLength;
      Serial.println(analogInAverage);
      //serialWriteInt(analogInAverage);
    }
    inChar = 'a';
  }
}

void serialWriteInt(int number) {
  byte convertedNumber [2];
  convertedNumber[1] = (number << 8) >> 8;
  convertedNumber[0] = number >> 8;
  Serial.write(convertedNumber, 2);
}
