#!/bin/bash


cd ~/src/Firmware
no_sim=1 make posix_sitl_default gazebo &

sleep 1m

echo "PX4 Running in the back ground in the with PID $!"

source ~/catkin_ws/devel/setup.bash    
source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/posix_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)/Tools/sitl_gazebo

roslaunch gazebo_ros empty_world.launch world_name:=$(pwd)/Tools/sitl_gazebo/worlds/iris.world

# roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14560"