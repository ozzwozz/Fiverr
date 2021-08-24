#!/usr/bin/python3

#importing libraries
import rospy
from braccio_controller.msg import coords
from geometry_msgs.msg import Twist
import time
from std_msgs.msg import UInt8

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
		pos1 = False
		pos2 = False
		#check if coordinates are possible movements
		vari = coords()
		vari.x = 1
		vari.y  = int(coords1.linear.y)
		vari.z  = int(coords1.linear.z)
		vari.angle = int(coords1.angular.x + angular_offset)
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

			pos1 = True
		#checks if data 2 is a possible movement
		vari.x = 1
		vari.y  = int(coords2.linear.y)
		vari.z  = int(coords2.linear.z)
		vari.angle = int(coords2.angular.x + angular_offset)
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
			pos2 =True
		#section to move to postion 1
		print(check_sucess)	
		if (pos1 == True):
			print("moving to position 1")
			rospy.loginfo("moving to position 1")
			#movesto position one with claw open
			vari.x = 1
			vari.y  = int(coords1.linear.y)
			vari.z  = int(coords1.linear.z)
			vari.angle = int(coords1.angular.x + angular_offset)
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
			vari.x = 1
			vari.y  = 1
			vari.z  = int(coords1.linear.z)
			vari.angle = 180 + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
			#drops object
			vari.gripper = 10
			pub.publish(vari)
			time.sleep(2)
		if (pos2 == True):
			#moves to position 2
			print("moving to position 2")
			rospy.loginfo("moving to position 2")
			vari.x = 1
			vari.y  = int(coords2.linear.y)
			vari.z  = int(coords2.linear.z)
			vari.angle = int(coords2.angular.x + angular_offset)
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
			vari.x = 1
			vari.y  = 1
			vari.z  = int(coords2.linear.z)
			vari.angle = 180 + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
			#drops object
			vari.gripper = 10
			pub.publish(vari)
			time.sleep(2)
		if(pos1 == True or pos2 == True):
			print("picking up blocks")
			rospy.loginfo("picking up blocks")
			#moves top center to pick up both objects
			vari.x = 1
			vari.y  = 1
			vari.z  = int(coords2.linear.z + 30)
			vari.angle = int(180+ angular_offset)
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
			#picks up objects
			vari.gripper = 73
			pub.publish(vari)
			time.sleep(2)
			#raises objects
			vari.x = 1
			vari.y  = 1
			vari.z  = int(coords2.linear.z -10)
			vari.angle = 180 + angular_offset
			vari.real = 1
			vari.wrist = wrist_offset_angle
			pub.publish(vari)
			time.sleep(3)
	else:
		print("only one data received")
		rospy.loginfo("only one data received")
		
	print("done")
		
#calback function for receiving twist data and saving position
def callback_twist1(message):
	rospy.loginfo("coords 1")
	global coords1
	global data_aquired
	coords1.angular.x = message.angular.x
	coords1.linear.y = message.linear.y
	coords1.linear.z = message.linear.z
	if (data_aquired< 2):
		data_aquired = data_aquired+1
		movement(data_aquired)
	rospy.loginfo("coordinates of item 1 received")

#callback function for receiving twist data and saving position 2
def callback_twist2(message):
	rospy.loginfo("coords 2")
	global coords2
	global data_aquired
	coords2.angular.x = message.angular.x
	coords2.linear.y = message.linear.y
	coords2.linear.z = message.linear.z
	if (data_aquired< 2):
		data_aquired = data_aquired+1
		movement(data_aquired)
	rospy.loginfo("coordinates of item 2 received")


#declares subscriber objects
sub_success = rospy.Subscriber("Sucess_count", UInt8, callback_success) 

sub_twist1 = rospy.Subscriber("object1", Twist, callback_twist1)
sub_twist2 = rospy.Subscriber("object2", Twist, callback_twist2)


#----------------------------------test function-------------------------------------
def tester():
	coords2.angular.x = 180
	coords2.linear.y = -50
	coords2.linear.z =150
	coords1.angular.x = 180
	coords1.linear.y = 50
	coords1.linear.z = 150
	movement(2)

#-------------------------------------------------------------------------------



#main loop
if __name__ == "__main__":
	rospy.init_node("main_controller")
	rospy.loginfo("hello from main_controller")
	print("hello from main_controller")
	time.sleep(20)
	rate = rospy.Rate(5)
	while not rospy.is_shutdown():
		rospy.spin()
		rate.sleep()


