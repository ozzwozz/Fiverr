cmake_minimum_required(VERSION 3.0.2)
project(detection)

## Compile as C++11, supported in ROS Kinetic and newer
# add_compile_options(-std=c++11)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS
  cv_bridge
  image_transport
  image_view
  roscpp
  rospy
  std_msgs
)

find_package(OpenCV REQUIRED)

include_directories(${OpenCV_INCLUDE_DIRS})
##target_link_libraries(my_awesome_library ${OpenCV_LIBRARIES})

###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## INCLUDE_DIRS: uncomment this if your package contains header files
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need
catkin_package(
#  INCLUDE_DIRS include
#  LIBRARIES detection
  CATKIN_DEPENDS cv_bridge image_transport roscpp rospy
#  DEPENDS system_lib
)

###########
## Build ##
###########

## Specify additional locations of header files
## Your package locations should be listed before other locations
include_directories(
 include
  ${catkin_INCLUDE_DIRS}
)

## Declare a C++ executable
## With catkin_make all packages are built within a single CMake context
## The recommended prefix ensures that target names across packages don't collide
 add_executable(detection_node src/detector.cpp)

## Add cmake target dependencies of the executable
## same as for the library above
 add_dependencies(detection_node ${detection_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

## Specify libraries to link a library or executable target against
  target_link_libraries(detection_node
  ${catkin_LIBRARIES} ${OpenCV_LIBRARIES}
  )
