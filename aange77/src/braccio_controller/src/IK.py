#!/usr/bin/python3



#import arm_size as arm_size
from math import *
from arm_size import *
import rospy
from braccio_controller.msg import Adc
from braccio_controller.msg import coords.msg


pub = rospy.Publisher("Sucess_count", UInt8, queue_size=10)
pub_ard = rospy.Publisher("Pi_to_Ard", Adc, queue_size=300) 

fail_count =0


def inverse_kinematics(Tx,Ty,Tz,Ttheta):
    d1 =link0
    a2 =link1
    a3 =link2
    d5 =link4+link3
    
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
        _fail_count = 0
        _out1 = 0
        _out2 = 0
        _out3 = 0
        _out4 = 0
        if(q1_max>=theta1+offset0>=q1_min):
            _out1 = theta1+offset0
        else:
            acos(1000)
        if(q2_max>=theta2+offset1>=q2_min):
            _out2 = theta2+offset1
        else:
            acos(1000)
        if(q3_max>=theta3+offset2>=q3_min):
            _out3 = theta3+offset2
        else:
            acos(1000)
        if(q4_max>=theta4+offset3>=q4_min):
            _out4 = theta4+offset3
        else:
            acos(1000)

    except:
        fail_count = fail_count+1
        _success = 0
        _out1 = 0
        _out2 = 0
        _out3 = 0
        _out4 = 0
    
    return _success, _out1, _out2, _out3, _out4 

if __name__ == "__main__":
    rospy.init_node("inverse_kinematics")
    success, out1, out2, out3, out4 = inverse_kinematics(100,100,100,90)
    print("hello from IK")
    print("success: "+str(success))
    print("theta 1: "+str(out1))
    print("theta 2: "+str(out2))
    print("theta 3: "+str(out3))
    print("theta 4: "+str(out4))
