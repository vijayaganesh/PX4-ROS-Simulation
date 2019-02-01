FROM ubuntu:xenial

USER root
RUN apt-get update 
RUN apt-get install sudo

RUN apt-get install -y \
    software-properties-common \
    wget \ 
    bash

RUN adduser --disabled-password --gecos '' px4_simulation
RUN adduser px4_simulation sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER px4_simulation
WORKDIR /home/px4_simulation

ADD setup/install_deps.sh /home/px4_simulation/install_deps.sh
ADD setup/install_ros.sh /home/px4_simulation/install_ros.sh
ADD setup/install_mavros.sh /home/px4_simulation/install_mavros.sh

RUN bash /home/px4_simulation/install_ros.sh && \
    rm /home/px4_simulation/install_ros.sh

RUN bash /home/px4_simulation/install_deps.sh && \
    rm /home/px4_simulation/install_deps.sh

RUN bash /home/px4_simulation/install_mavros.sh && \
    rm /home/px4_simulation/install_mavros.sh

USER root
RUN usermod -a -G dialout px4_simulation
RUN apt-get install tmux
