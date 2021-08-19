#!/usr/bin/python3

#print(python3)

import arm_size as arm_size
import math

def sin(f):
    return (math.sin(f)*(180/math.pi))

def cos(f):
    return (math.cos(f)*(180/math.pi))

def tan(f):
    return (math.tan(f)*(180/math.pi))

def atan(f):
    return (math.atan(f)*(180/math.pi))

def acos(f):
    return (math.acos(f)*(180/math.pi))

def asin(f):
    return (math.asin(f)*(180/math.pi))

#arm length
d1 =105
a2 =105
a3 =100
d5 =150


#inputs 
theta = 0
Px= 100
Py= 100
Pz= 0



#variables
_theta1 = atan(Py/Px)

theta_234=(90)+theta
R=d5*cos(theta)
Pxw = Xw = Px - (R*cos(_theta1))
Pyw = Yw = Py - (R*sin(_theta1))
Pzw = Zw = Pz + (d5*sin(theta))
Rw = math.sqrt((Pxw**2)+(Pyw**2))
N = math.sqrt((Pzw-d1)**2+(Rw**2))


muu = acos((((N**2)+(a2**2)-(a3**2))/(2*a2*N)))
lamda = atan((Pzw-d1)/(Rw))


theta2r =lamda+muu
#theta2r=lamda-muu
theta3r = +acos(((N**2)-(a2**2)-(a3**2))/(2*a2*a3))
theta3r = -acos(((N**2)-(a2**2)-(a3**2))/(2*a2*a3))

#outputs
theta1 = _theta1 *(180/pi)
theta2 = theta2r *(180/pi)
theta3 = theta3r *(180/pi)
theta4 = theta_234 - theta2 - theta3

if __name__ == "__main__":
	print("hello from IK")
	print("theta 1: "+str(theta1))
	print("theta 2: "+str(theta2))
	print("theta 3: "+str(theta3))
	print("theta 4: "+str(theta4))
