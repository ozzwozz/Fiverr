#!/usr/bin/python3

from math import *
import arm_size
import rospy
from braccio_controller.msg import Adc
from braccio_controller.msg import coords
from std_msgs.msg import UInt8


pub = rospy.Publisher("Sucess_count", UInt8, queue_size=10)
pub_ard = rospy.Publisher("Pi_to_Ard", Adc, queue_size=300)

fail_count = UInt8()
failure_count = 0

def callback_function(message):
    rospy.loginfo("Received")
    msg_to_publish = Adc()
    
    success, out1, out2, out3, out4 = inverse_kinematics(message.x,message.y,message.z,message.angle)
    global failure_count
    if (success==1 and message.real== 1):
        rospy.loginfo("sent to arduino")
        msg_to_publish.adc0= int(out1)
        msg_to_publish.adc1= int(out2)
        msg_to_publish.adc2= int(out3)
        msg_to_publish.adc3= int(out4)
        msg_to_publish.adc4= message.wrist
        msg_to_publish.adc5= message.gripper
        failure_count = 0
        fail_count.data = 0
        pub_ard.publish(msg_to_publish)
    elif(success == 0):
        failure_count = failure_count+1
        print("failed: "+ str(failure_count))
        fail_count.data = failure_count
        rospy.loginfo("unsuccesful")
    elif(message.real == 0):
        failure_count = 0
        rospy.loginfo("not sent to arduino")
        fail_count.data = 0	
    pub.publish(fail_count)


sub = rospy.Subscriber("Coords", coords, callback_function) 




def inverse_kinematics(Tx,Ty,Tz,Ttheta):
    d1 =arm_size.link0
    a2 =arm_size.link1
    a3 =arm_size.link2
    d5 =arm_size.link4+arm_size.link3
    
    q1_max =180
    q1_min =0
    q2_max =165
    q2_min =15
    q3_max = 180
    q3_min = 0
    q4_max = 180
    q4_min = 0
    
    #inputs 
    theta = Ttheta
    Px= Tx
    Py= Ty
    Pz= Tz
    #variables
    try:
        _theta1 = atan(Py/Px)

        theta_234=(90)-(theta)
        R=d5*cos(radians(theta))
        Pxw = Xw = Px - (R*cos(_theta1))
        Pyw = Yw = Py - (R*sin(_theta1))
        Pzw = Zw = Pz + (d5*sin(radians(theta)))
        Rw = sqrt((Pxw**2)+(Pyw**2))
        N = sqrt((Pzw-d1)**2+(Rw**2))


        muu = acos((((N**2)+(a2**2)-(a3**2))/(2*a2*N)))
        lamda = atan((Pzw-d1)/(Rw))


        theta2r =lamda+muu
        theta2r_alt=lamda-muu
        theta3r = +acos(((N**2)-(a2**2)-(a3**2))/(2*a2*a3))

        theta3r_alt = -acos(((N**2)-(a2**2)-(a3**2))/(2*a2*a3))

        #outputs
        theta1 = _theta1 *(180/pi)
        theta2 = theta2r *(180/pi)
        theta2_alt = degrees(theta2r_alt)
        theta3 = (theta3r *(180/pi))
        theta3_alt = degrees(theta3r_alt)
        theta4 = theta_234 - theta2 + theta3
        _success = 1
        fail_count.data = 0
        failure_count= 0

        if(q1_max>=theta1+arm_size.offset0>=q1_min):
            _out1 = theta1+arm_size.offset0
        else:
            acos(1000)
        if(q2_max>=theta2+arm_size.offset1>=q2_min):
            _out2 = theta2+arm_size.offset1
        else:
            acos(1000)
        if(q3_max>=theta3+arm_size.offset2>=q3_min):
            _out3 = theta3+arm_size.offset2
        else:
            acos(1000)
        if(q4_max>=theta4+arm_size.offset3>=q4_min):
            _out4 = theta4+arm_size.offset3
        else:
            acos(1000)

    except:
        _success = 0
        _out1 = 0
        _out2 = 0
        _out3 = 0
        _out4 = 0

    print("theta 1: "+str(_out1))
    print("theta 2: "+str(_out2))
    print("theta 3: "+str(_out3))
    print("theta 4: "+str(_out4))
    
    
    return _success, _out1, _out2, _out3, _out4 

if __name__ == "__main__":
    rospy.init_node("inverse_kinematics")
    rospy.loginfo("hello from IK")
    print("hello from IK")
    success, out1, out2, out3, out4 = inverse_kinematics(150,150,0,90)
    rate = rospy.Rate(5)
    while not rospy.is_shutdown():
        rospy.spin()
        rate.sleep()
	
