#include <Arduino.h>
#include <WiFi.h>
#include <certs.h>
#include <aws.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>

// RGB LCD Display
#include <Wire.h>
#include "rgb_lcd.h"

// DHT
#include <Adafruit_Sensor.h>
#include <DHT.h>

#define DHT_TYPE DHT11
#define DHT_PIN 14

rgb_lcd lcd;

const char *SSID = "abcd";
const char *PWD = "abcd";

long lastMsg = 0;

WiFiClientSecure secureClient = WiFiClientSecure();
PubSubClient mqttClient(secureClient);
DHT dht(DHT_PIN, DHT_TYPE);

void callback(char *topic, byte *payload, unsigned int length)
{
  Serial.println(topic);

  if (strcmp(topic, ATMOSPHERIC_HUMIDITY_OUT_OF_RANGE) == 0)
  {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(":(");
    lcd.setCursor(0, 1);
    lcd.print("Bitte giessen");
    lcd.setRGB(255, 0, 0);
  }

  if (strcmp(topic, ATMOSPHERIC_HUMIDITY_IN_RANGE) == 0)
  {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(":)");
    lcd.setCursor(0, 1);
    lcd.print("Pflanze gluecklich");
    lcd.setRGB(127, 255, 0);
  }
}

void connectToWiFi()
{
  Serial.print("Connecting to ");
  Serial.println(SSID);
  WiFi.scanNetworks();

  WiFi.begin(SSID, PWD);

  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(500);
    Serial.print(WiFi.status());
    // we can even make the ESP32 to sleep
  }

  Serial.print("Connected - ");
  //Serial.println(WiFi.localIP);
}

void connectToAWS()
{
  mqttClient.setServer(AWS_END_POINT, 8883);
  mqttClient.setCallback(callback);
  secureClient.setCACert(AWS_PUBLIC_CERT);
  secureClient.setCertificate(AWS_DEVICE_CERT);
  secureClient.setPrivateKey(AWS_PRIVATE_KEY);

  Serial.println("Connecting to MQTT....");

  mqttClient.connect(DEVICE_NAME);

  while (!mqttClient.connected())
  {
    Serial.println("Connecting to MQTT....Retry");
    mqttClient.connect(DEVICE_NAME);
    delay(5000);
  }

  mqttClient.subscribe(ATMOSPHERIC_HUMIDITY_OUT_OF_RANGE, 0);
  mqttClient.subscribe(ATMOSPHERIC_HUMIDITY_IN_RANGE, 0);
  Serial.println("MQTT Connected");
}

void setup()
{
  Serial.begin(9600);
  dht.begin();
  connectToWiFi();
  connectToAWS();

  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2)
}

void loop()
{

  mqttClient.loop();

  long now = millis();

  if (now - lastMsg > 5000)
  {
    lastMsg = now;

    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();
    float heatIndex = dht.computeHeatIndex(temperature, humidity, false);

    Serial.print("Temperature:");
    Serial.println(temperature);
    Serial.print("Humidity:");
    Serial.println(humidity);
    Serial.print("Heat Index:");
    Serial.println(heatIndex);

    StaticJsonDocument<128> jsonDoc;
    JsonObject eventDoc = jsonDoc.createNestedObject("event");
    eventDoc["temp"] = temperature;
    eventDoc["hum"] = humidity;
    eventDoc["hi"] = heatIndex;

    char jsonBuffer[128];

    serializeJson(eventDoc, jsonBuffer);
    mqttClient.publish(PUBLISH_DATA_TOPIC, jsonBuffer);
  }
}
