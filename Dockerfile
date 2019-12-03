FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Update package list and install dependencies
RUN apt-get -qq update && \
    apt-get -y install sudo && \
    apt-get -qq install -y --no-install-recommends build-essential \
    ca-certificates libgtk2.0-0 sqlite3 wget git libhdf5-dev g++ graphviz unzip x11-apps sudo vim && \
    apt-get -qq clean

RUN apt-get update -y && \
    apt-get install -y python3 python3-pip octave

ADD requirements.txt /app/
WORKDIR /app
RUN pip3 install -r requirements.txt

ADD . /app

RUN apt-get update && apt-get install sudo

# Clean up APT when done.
RUN sudo apt-get clean
RUN sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
USER docker
ENV HOME /home/docker

WORKDIR /home/docker/

RUN git clone https://github.com/gpspelle/personal
RUN mv personal/.vimrc ~/

