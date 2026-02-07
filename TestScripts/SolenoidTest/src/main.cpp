#include <Arduino.h>

//TODO: put the correct pins
const int S1 = 1;
const int S2 = 2;

const int ITERATIONS = 10;

void setup() {
    for (int i = 0; i < ITERATIONS; i++) {
        digitalWrite(S1, HIGH);
        delay(250);
        digitalWrite(S2, HIGH);
        delay(250);
        digitalWrite(S1, LOW);
        delay(250);
        digitalWrite(S2, LOW);
        delay(500);
    }
}