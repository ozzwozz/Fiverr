#!/usr/bin/python3

import rospy
from std_msgs.msg import UInt8


def publisher():
	pub = rospy.Publisher("PI_to_Ard", UInt8, queue_size=10)
	rate = rospy.Rate(1)
	msg_to_publish = UInt8();
	counter = 0

	while not rospy.is_shutdown():
		string_publish = "publishing %d"%counter
		counter +=1
		msg_to_publish.data = counter
		pub.publish(msg_to_publish)
		rospy.loginfo(counter)
		rate.sleep()

if __name__ == "__main__":
	rospy.init_node("test_publisher")
	print("hello publisher")
	publisher()