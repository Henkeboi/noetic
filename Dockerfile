FROM ubuntu:20.04

# Basic tools
RUN apt-get update && apt-get -y upgrade && apt-get install -yq build-essential software-properties-common python3-pip apt-utils
 
# Install noetic
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -y ros-noetic-desktop-full

RUN bin/bash -c "source /opt/ros/noetic/setup.bash && cd && mkdir catkin_rdv && cd catkin_rdv && mkdir src && catkin_make"

RUN apt-get -y install git

COPY . /root
RUN mkdir /root/.ssh && mv /root/id_rsa /root/.ssh && mv /root/id_rsa.pub /root/.ssh
RUN apt-get install -y python-rosdep
RUN rosdep init
RUN rosdep update
RUN apt-get install -y ros-noetic-can-msgs ros-noetic-jsk-rviz-plugins libboost-all-dev ros-noetic-rosserial ros-noetic-rosserial-arduino libpcap0.8-dev liblapack-dev libarmadillo-dev ros-noetic-velodyne ros-noetic-geometry2 ros-noetic-rqt-multiplot ros-noetic-tf2-sensor-msgs ros-noetic-robot-localization libqwt-dev
# Remove find_package(Boost REQUIRED COMPONENTS) in rdv_slam/CMakeList.txt.
