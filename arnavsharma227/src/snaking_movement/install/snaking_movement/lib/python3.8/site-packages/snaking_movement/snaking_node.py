#!/usr/bin/python3

#importing libraries
import rclpy
from rclpy.node import Node

from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist

# declare the variable to store the output movement
SnakeMove = Twist()

def main(args=None):
    rclpy.init(args=args)

    snaking_publisher = Snaking()

    rclpy.spin(snaking_publisher)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    snaking_publisher.destroy_node()
    rclpy.shutdown()

class Snaking(Node):


    def publish_twist(self, lin_x, lin_y, lin_z, ang_x, ang_y, ang_z):
        move_cmd.linear.x = lin_x
        move_cmd.linear.y = lin_y
        move_cmd.linear.z = lin_z

        move_cmd.angular.x = ang_x
        move_cmd.angular.y = ang_y
        move_cmd.angular.z = ang_z

        self.publisher_.publish(move_cmd)

    def snaking_control(self, laser_msg):
        # write your control code here
        # functions to call from external scripts
        print("")

    def __init__(self):
        super().__init__('snaking_node')

        # publish Twist to /cmd_vel
        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)

        self.timer = self.create_subscription(LaserScan,'/LaserScan', self.snaking_control, 10)




if __name__ == '__main__':
    main()
