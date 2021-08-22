#!/usr/bin/python3

import rospy
from braccio_controller.msg import coords
from geometry_msgs.msg import Twist
import time

success= 0
coords1 = Twist()
coords2 = Twist()
data_aquired = 0

angular_offset = 0


def callback_success(message):
	rospy.loginfo("success received")
	global success
	success = message.data

def movement(data):
	if (data> 1):
		global coords1
		global coords2
		global success
		global angular_offset
		vari = coords()
		var.x = 0
		var.y  = coords1.y.linear
		var.z  = coords1.z.linear
		var.angle = coords.x.angular + angular_offset
		var.real = 0
		pub.publish(var)
		time.sleep(1)
		if (success != 0):
			print("position 1 unreachable")
			rospy.loginfo("position 1 unreachable")
		else:
			print("position 1 sucess")
			rospy.loginfo("position 1 sucess")
		var.x = 0
		var.y  = coords2.y.linear
		var.z  = coords2.z.linear
		var.angle = coords2.x.angular + angular_offset
		var.real = 0
		pub.publish(var)
		time.sleep(1)
		if (success != 0):
			print("position 2 unreachable")
			rospy.loginfo("position 2 unreachable")
		else:
			print("position 2 sucess")
			rospy.loginfo("position 2 sucess")


def callback_twist1(message):
	global coords1
	global data_aquired
	coords1.x.angular = message.x.angular
	coords1.y.linear = message.y.linear
	coords1.z.linear = message.z.linear
	if (data_aquired< 2):
		data_aquired = data_aquired+1
		movement(data_aquired)
	rospy.loginfo("coordinates of item 1 received")

def callback_twist2(message):
	global coords2
	global data_aquired
	coords2.x.angular = message.x.angular
	coords2.y.linear = message.y.linear
	coords2.z.linear = message.z.linear
	if (data_aquired< 10):
		data_aquired = data_aquired+1
		movement(data_aquired)
	rospy.loginfo("coordinates of item 2 received")

pub = rospy.Publisher("Coords", coords, queue_size=10)
sub_success = rospy.Subscriber("Coords", coords, callback_success) 

sub_twist1 = rospy.Subscriber("Twist1", Twist, callback_twist1)
sub_twist2 = rospy.Subscriber("Twist2", Twist, callback_twist2)



if __name__ == "__main__":
	rospy.init_node("main_controller")
	rospy.loginfo("hello from main_controller")
	print("hello from main_controller")
	rate = rospy.Rate(5)
	while not rospy.is_shutdown():
		rospy.spin()
		rate.sleep()


