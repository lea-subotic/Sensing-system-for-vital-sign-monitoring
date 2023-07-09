#include <WiFiNINA.h>
#include <ThingSpeak.h>

#define WIFI_SSID "Personal"  // moja wi-fi mreža
#define WIFI_PASS "x"         // promijeniti lozinku za odgovarajuću wi-fi mrežu

#define INTERVAL_SLANJA 15000   // 15 000 milisekundi = 15 sekundi 
#define INTERVAL_ISPISA 1000    // kontrolni ispis svake sekunde
#define SUM_MAX 40
#define NORMLANO_DISANJE 40
#define DEFAULT_VALUE 816

unsigned long previousMillis1 = 0;    // varijeble za praćenje proteklog vremena
unsigned long previousMillis2 = 0;
int previousValue = -1;               // varijebale za praćenmje poslijednjih 
int sensorValue = 0;                  // vrijednosti ocitanih sa senzora

WiFiClient client;                      // stavranje objekta za pvezivanje na wi-fi
unsigned long channelID = 2092782;      // ID kanala na ThingSpeak platformi gdje se šalju podatci 
const char * writeAPIKey = "N4AOAPENQQ43SF00";    // API ključ kanala u koji se šalju podatci na ThingSpeaku

const uint8_t xorKey = 0xAB;          // ključ za šifriranje podataka u heksadekatskom obliku


void setup() {
  Serial.begin(9600);                 // brzina komunikacije 
  while (!Serial);

  WiFi.begin(WIFI_SSID, WIFI_PASS);   // spajanje na wi-fi
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
  ThingSpeak.begin(client);

}

// Funkcija zaštite podataka
String encryptData(int data) {
  String result = "";
  uint8_t *bytes = (uint8_t*)&data;
  for (int i = 0; i < sizeof(data); i++) {
    bytes[i] ^= xorKey;
    if (bytes[i] < 0x10) result += "0";
    result += String(bytes[i], HEX);
  }
  return result;
}


// Fukcija dekripcije- za provijeru 
int decryptData(String encryptedData) {
  int result = 0;
  uint8_t *bytes = (uint8_t*)&result;
  for (int i = 0; i < encryptedData.length(); i += 2) {
    String byteString = encryptedData.substring(i, i + 2);
    bytes[i / 2] = (uint8_t) strtol(byteString.c_str(), NULL, 16) ^ xorKey;
  }
  result = (result<<24) | ((result<<8) & 0x00ff0000) | ((result>>8) & 0x0000ff00) | (result>>24); 
  return result;
}

//izvođenje beskonačne petlje
void loop() {
  unsigned long currentMillis = millis();
  int sensorValue = analogRead(A0);
  // vrijednosti izvan normalnog intervala - puno veća promijena- momentalno slanje na ThingSpeak
  if((abs(sensorValue - previousValue) > NORMLANO_DISANJE))
  {
    String encryptedValue = encryptData(sensorValue);
    ThingSpeak.writeField(channelID, 1, encryptedValue, writeAPIKey);
    Serial.print("Podatak se promijenio i šaljem ga : ");
    Serial.println(sensorValue);
    Serial.println(encryptedValue);
    previousValue = sensorValue;
  }
  // slanje trenutnog podatka svakih 15 sec
  if (currentMillis - previousMillis1 >= INTERVAL_SLANJA)
  {
    String encryptedValue = encryptData(sensorValue);
    Serial.print("Prošlo je 15s, šaljem podatak : ");
    Serial.println(sensorValue);
    Serial.println(encryptedValue);
    ThingSpeak.writeField(channelID, 1, encryptData(sensorValue), writeAPIKey);
    previousMillis1 = currentMillis;
  }
  // ispis podatka svake sekunde
  if (currentMillis - previousMillis2 >= INTERVAL_ISPISA)
  {
    String encryptedValue = encryptData(sensorValue);
    Serial.print("Prošlo je 2s, ispisujem podatak : ");
    Serial.println(sensorValue);
    Serial.println(encryptedValue);
    previousMillis2 = currentMillis;
  }
}
