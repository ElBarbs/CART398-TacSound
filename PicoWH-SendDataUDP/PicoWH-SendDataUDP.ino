#include <WiFi.h>
#include <WiFiUdp.h>
#include <OSCMessage.h>

// ADC inputs.
#define mouthPin 28

// Digital only inputs.
const int nbMazeEndpoints = 3;
const int mazePins[nbMazeEndpoints] = {0, 1, 2};
const int nbSpikes = 7;
const int spikePins[nbSpikes] = {3, 5, 6, 7, 8, 9, 10};

// Network credentials.
const char SSID[] = "";
const char PASS[] = "";

// UDP settings.
const IPAddress IP(192, 168, 130, 233);
const unsigned int IN_PORT = 1111;
const unsigned int OUT_PORT = 6448;
WiFiUDP udp;

// OSC message.
OSCMessage osc("/wek/inputs");

void startUDPClient()
{
  // Connect to WiFi network.
  Serial.print("Connecting to ");
  Serial.println(SSID);
  WiFi.begin(SSID, PASS);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  // Initialize UDP connection.
  Serial.println("Starting UDP");
  udp.begin(IN_PORT);
  Serial.print("Local port: ");
  Serial.println(udp.localPort());
}

void setup()
{
  Serial.begin(115200);

  startUDPClient();

  // Configure the pins as inputs.
  for (int i = 0; i < nbMazeEndpoints; i++)
  {
    pinMode(mazePins[i], INPUT);
  }
  for (int i = 0; i < nbSpikes; i++)
  {
    pinMode(spikePins[i], INPUT);
  }
  pinMode(mouthPin, INPUT);
}

void loop()
{
  // Read each input pin and send OSC messages.

  // Maze.
  for (int i = 0; i < nbMazeEndpoints; i++)
  {
    osc.add(float(digitalRead(mazePins[i])));
  }

  // Spikes.
  for (int i = 0; i < nbSpikes; i++)
  {
    osc.add(float(digitalRead(spikePins[i])));
  }

  // Mouth.
  osc.add(float(analogRead(mouthPin)));

  // Send the message.
  udp.beginPacket(IP, OUT_PORT);
  osc.send(udp);
  udp.endPacket();

  // Empty the message.
  osc.empty();

  // Wait 250 milliseconds.
  delay(250);
}
