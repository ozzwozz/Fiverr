from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='snaking_movement',
            executable='snaking_node',
            name='snaking_node',
            output='screen',
            emulate_tty=True,
        )
    ])
