#!/usr/bin/python3

import rospy
from std_msgs.msg import UInt8
from braccio_controller.msg import Adc
from braccio_controller.msg import coords
from geometry_msgs.msg import Twist
import time


def publisher():
	pub = rospy.Publisher("object2",Twist, queue_size=10)
	pub2 = rospy.Publisher("object1",Twist, queue_size=10)
	rate = rospy.Rate(1)
	msg_to_publish = Twist()
	msg_to_publish2 = Twist()
	counter = 50
	msg_to_publish.angular.x = 90
	msg_to_publish2.angular.x = 90
	
	msg_to_publish.linear.y = 100
	msg_to_publish2.linear.y = -100
	msg_to_publish.linear.z = 200
	msg_to_publish2.linear.z = 200
	pub.publish(msg_to_publish)
	pub2.publish(msg_to_publish2)
	
	time.sleep(5)
	
	
	while not rospy.is_shutdown():
#	    string_publish = "publishing %d"%counter
#	    counter -=1
#
#	    msg_to_publish.x = 100 + counter
#	    msg_to_publish.y= 100 + counter
#	    msg_to_publish.z=0
#	    msg_to_publish.angle = 90
#	    msg_to_publish.real= counter%2
#	    pub.publish(msg_to_publish)
#	    rospy.loginfo(counter)
	    rate.sleep()

if __name__ == "__main__":
	rospy.init_node("test_publisher")
	print("hello publisher")
	publisher()
