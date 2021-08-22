#!/usr/bin/python3

#importing libraries
import rospy
from braccio_controller.msg import coords
from geometry_msgs.msg import Twist
import time

#creating global variables to be used
success= 0
coords1 = Twist()
coords2 = Twist()
data_aquired = 0

#offsets to be changed due to positionning of the arm
angular_offset = 0 #offset for the angle of the arm to the ground
wrist_offset_angle = 0 #offset for the wrist to pick up block

#declaring publisher
pub = rospy.Publisher("Coords", coords, queue_size=10)

#callback to read and save if possible movement is successful
def callback_success(message):
	rospy.loginfo("success received")
	global success
	success = message.data

#function that does the movement of the arm
def movement(data):
	#checks if both data has been aquired
	if (data> 1):
		global coords1
		global coords2
		global success
		global angular_offset
		global wrist_offset_angle
		check_sucess = 1
		#check if coordinates are possible movements
		vari = coords()
		vari.x = 0
		vari.y  = coords1.y.linear
		vari.z  = coords1.z.linear
		vari.angle = coords1.x.angular + angular_offset
		vari.real = 0
		pub.publish(vari)
		time.sleep(1)
		#tells user if the coordinates are possible
		if (success != 0):
			print("position 1 unreachable")
			rospy.loginfo("position 1 unreachable")
		else:
			print("position 1 sucess")
			rospy.loginfo("position 1 sucess")
			check_success = check_sucess*3
		#checks if data 2 is a possible movement
		vari.x = 0
		vari.y  = coords2.y.linear
		vari.z  = coords2.z.linear
		vari.angle = coords2.x.angular + angular_offset
		vari.real = 0
		pub.publish(vari)
		time.sleep(1)
		#tells user if position is valid
		if (success != 0):
			print("position 2 unreachable")
			rospy.loginfo("position 2 unreachable")
		else:
			print("position 2 sucess")
			rospy.loginfo("position 2 sucess")
			check_success = check_sucess*10
		#section to move to postion 1	
		if (9>check_sucess>2):
			print("moving to position 1")
			rospy.loginfo("moving to position 1")
			#movesto position one with claw open
			vari.x = 0
			vari.y  = coords1.y.linear
			vari.z  = coords1.z.linear
			vari.angle = coords1.x.angular + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			vari.gripper = 10
			pub.publish(vari)
			time.sleep(3)
			#close claw to grab
			vari.gripper = 73
			pub.publish(vari)
			time.sleep(2)
			#moves object to center
			print("moving to center")
			rospy.loginfo("moving to center")
			vari.x = 0
			vari.y  = 0
			vari.z  = coords1.z.linear
			vari.angle = 90 + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
			#drops object
			vari.gripper = 10
			pub.publish(vari)
			time.sleep(2)
		if (check_sucess > 9):
			#moves to position 2
			print("moving to position 2")
			rospy.loginfo("moving to position 2")
			vari.x = 0
			vari.y  = coords2.y.linear
			vari.z  = coords2.z.linear
			vari.angle = coords2.x.angular + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			vari.gripper = 10
			pub.publish(vari)
			time.sleep(3)
			#grabs object
			vari.gripper = 73
			pub.publish(vari)
			time.sleep(2)
			print("moving to center")
			rospy.loginfo("moving to center")
			#moves to center
			vari.x = 0
			vari.y  = 0
			vari.z  = coords2.z.linear
			vari.angle = 90 + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
			#drops object
			vari.gripper = 10
			pub.publish(vari)
			time.sleep(2)
		if(check_sucess > 2):
			print("picking up blocks")
			rospy.loginfo("picking up blocks")
			#moves top center to pick up both objects
			vari.x = 0
			vari.y  = 0
			vari.z  = coords2.z.linear + 30
			vari.angle = coords2.x.angular + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
			#picks up objects
			vari.gripper = 73
			pub.publish(vari)
			time.sleep(2)
			#raises objects
			vari.x = 0
			vari.y  = 0
			vari.z  = coords2.z.linear -30
			vari.angle = 90 + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
	else:
		print("only one data received")
		rospy.loginfo("only one data received")
		
#calback function for receiving twist data and saving position
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

#callback function for receiving twist data and saving position 2
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


#declares subscriber objects
sub_success = rospy.Subscriber("Coords", coords, callback_success) 

sub_twist1 = rospy.Subscriber("Twist1", Twist, callback_twist1)
sub_twist2 = rospy.Subscriber("Twist2", Twist, callback_twist2)


#main loop
if __name__ == "__main__":
	rospy.init_node("main_controller")
	rospy.loginfo("hello from main_controller")
	print("hello from main_controller")
	rate = rospy.Rate(5)
	while not rospy.is_shutdown():
		rospy.spin()
		rate.sleep()


