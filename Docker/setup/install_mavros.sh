#!/bin/bash

## Setup environment variables
. /opt/ros/kinetic/setup.sh
# if grep -Fxq "$rossource" ~/.bashrc; then echo ROS setup.bash already in .bashrc;
# else echo "$rossource" >> ~/.bashrc; fi
# eval $rossource
## Get rosinstall
sudo apt-get install python-rosinstall -y

# MAVROS: https://dev.px4.io/en/ros/mavros_installation.html
## Create catkin workspace
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws

## Install dependencies
sudo apt-get install python-wstool python-rosinstall-generator python-catkin-tools -y

## Initialise wstool
wstool init ~/catkin_ws/src

## Build MAVROS
### Get source (upstream - released)
rosinstall_generator --upstream mavros | tee /tmp/mavros.rosinstall
### Get latest released mavlink package
rosinstall_generator mavlink | tee -a /tmp/mavros.rosinstall
### Setup workspace & install deps
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src
if ! rosdep install --from-paths src --ignore-src --rosdistro kinetic -y; then
    # (Use echo to trim leading/trailing whitespaces from the unsupported OS name
    unsupported_os=$(echo $(rosdep db 2>&1| grep Unsupported | awk -F: '{print $2}'))
    rosdep install --from-paths src --ignore-src --rosdistro kinetic -y --os ubuntu:xenial
fi
## Build!
catkin build
## Re-source environment to reflect new packages/build environment
. ~/catkin_ws/devel/setup.sh
# if grep -Fxq "$catkin_ws_source" ~/.bashrc; then echo ROS catkin_ws setup.bash already in .bashrc; 
# else echo "$catkin_ws_source" >> ~/.bashrc; fi
# eval $catkin_ws_source

echo "Downloading dependent script 'install_geographiclib_datasets.sh'"
# Source the install_geographiclib_datasets.sh script directly from github
install_geo=$(wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh -O -)
wget_return_code=$?
# If there was an error downloading the dependent script, we must warn the user and exit at this point.
if [[ $wget_return_code -ne 0 ]]; then echo "Error downloading 'install_geographiclib_datasets.sh'. Sorry but I cannot proceed further :("; exit 1; fi
# Otherwise source the downloaded script.
sudo sh -c "$install_geo"

clone_dir=~/src

# Go to the firmware directory
cd $clone_dir/Firmware

if [[ ! -z $unsupported_os ]]; then
    >&2 echo -e "\033[31mYour OS ($unsupported_os) is unsupported. Assumed an Ubuntu 16.04 installation,"
    >&2 echo -e "and continued with the installation, but if things are not working as"
    >&2 echo -e "expected you have been warned."
fi