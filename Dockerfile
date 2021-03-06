FROM ubuntu:16.04
MAINTAINER Dongsoo Lee <dongsoolee8@gmail.com>
LABEL name="ubuntu-development" \
	  version="0.1" \
	  description="Container for develop environement on ubuntu"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y \
    && apt-get upgrade -y \
	&& apt-get install -y software-properties-common python-software-properties \
	&& apt-add-repository -y ppa:adrozdoff/emacs \
	&& apt update \
    && apt-get install sudo -y \
	&& apt-get install -y \
	   build-essential \
	   wget \
	   curl \
	   vim \
	   emacs25 \
	   git \
	   gdebi \
	   ca-certificates \
	   rsync \
	   sendmail \
	   openssh-server
	   
# NodeJS 9.x
RUN curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - \
    && apt-get install -y \
	nodejs \
	build-essential

# Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	&& gdebi google-chrome-stable_current_amd64.deb \
	&& rm -f google-chrome-stable_current_amd64.deb

CMD ["/bin/bash"]
