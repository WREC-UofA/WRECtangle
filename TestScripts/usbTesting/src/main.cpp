#include <Arduino.h>

int n = 0;
// put function declarations here:
int myFunction(int, int);

void setup() {
  // put your setup code here, to run once:
  int result = myFunction(2, 3);
  Serial.begin(9600);
  Serial.println("Serial Begun!");
  delay(250);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println("");
  n++;
  Serial.print("Heartbeat # ");
  Serial.println(n);
  delay(250);
}

// put function definitions here:
int myFunction(int x, int y) {
  return x + y;
}