#!/usr/bin/python3

import rospy
from std_msgs.msg import UInt8
from braccio_controller.msg import Adc


def publisher():
	pub = rospy.Publisher("Pi_to_Ard", Adc, queue_size=300)
	rate = rospy.Rate(1)
	msg_to_publish = Adc()
	counter = 0

	while not rospy.is_shutdown():
		string_publish = "publishing %d"%counter
		counter +=1
		msg_to_publish.adc0= counter
		msg_to_publish.adc1= counter+1
		msg_to_publish.adc2= counter
		msg_to_publish.adc3= counter+1
		msg_to_publish.adc4= counter
		msg_to_publish.adc5= counter+1
		pub.publish(msg_to_publish)
		rospy.loginfo(counter)
		rate.sleep()

if __name__ == "__main__":
	rospy.init_node("test_publisher")
	print("hello publisher")
	publisher()
