#!/usr/bin/python3

import rospy
from std_msgs.msg import UInt8
from braccio_controller.msg import Adc
from braccio_controller.msg import coords


def publisher():
	pub = rospy.Publisher("Coords", coords, queue_size=1)
	rate = rospy.Rate(1)
	msg_to_publish = coords()
	counter = 50

	while not rospy.is_shutdown():
	    string_publish = "publishing %d"%counter
	    counter -=1

	    msg_to_publish.x = 100 + counter
	    msg_to_publish.y= 100 + counter
	    msg_to_publish.z=0
	    msg_to_publish.angle = 90
	    msg_to_publish.real= counter%2
	    pub.publish(msg_to_publish)
	    rospy.loginfo(counter)
	    rate.sleep()

if __name__ == "__main__":
	rospy.init_node("test_publisher")
	print("hello publisher")
	publisher()
