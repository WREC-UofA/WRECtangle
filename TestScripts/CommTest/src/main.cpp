#include <Arduino.h>

void setup() {
  Serial.begin(9600);
  Serial.println("Starting communication test");
}

void loop() {
  String message = Serial.readString();
  Serial.println("Received message: " + message);
}