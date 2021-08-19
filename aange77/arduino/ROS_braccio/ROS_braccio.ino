#include <Braccio.h>
#include <Servo.h>

#include <ros.h>
#include <rosserial_arduino/Adc.h>


ros::NodeHandle nh;

rosserial_arduino::Adc joints;

void messageCb( const rosserial_arduino::Adc& msg){
  Braccio.ServoMovement(10, msg.adc0, msg.adc1, msg.adc2, msg.adc3, msg.adc4, msg.adc5);
  Serial.print("Moving to: ");
  Serial.print( msg.adc0);
  Serial.print(", ");
  Serial.print( msg.adc1);
  Serial.print(", ");
  Serial.print( msg.adc2);
  Serial.print(", ");
  Serial.print( msg.adc3);
  Serial.print(", ");
  Serial.print( msg.adc4);
  Serial.print(", ");
  Serial.print( msg.adc5);
  Serial.print("\n");
  nh.loginfo("Moving");


}

ros::Subscriber<rosserial_arduino::Adc> sub("Pi_to_Ard",&messageCb);

Servo base;
Servo shoulder;
Servo elbow;
Servo wrist_rot;
Servo wrist_ver;
Servo gripper;


void setup() {
  Serial.begin(57600);
  nh.getHardware()->setBaud(57600);
  nh.initNode();
  nh.loginfo("hello from arduino");
  Serial.print("hello from arduino\n\r");
  nh.subscribe(sub);
  Braccio.begin();
  delay(8000);
  // put your setup code here, to run once:

}

void loop() {
  delay(100);
  nh.spinOnce();
  // put your main code here, to run repeatedly:

}
