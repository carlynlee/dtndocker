#
# NOTICE
# This software / technical data was produced for the U.S. 
# Government under NASA Contract Number NNH16PB26P, and is
# subject to the FAR 52.227-14 (6/87) Rights in Data General.
#
#
#
FROM ubuntu:latest as builder

LABEL description="ION instance"
LABEL maintainer="kscott@mitre.org"
#

#
# docker build -f ./Dockerfile -t kls2-vm.mitre.org:5000/keithlscott/ion:latest .

RUN apt -y update && apt -y install \
	wget \
	gcc \
	g++ \
	make \
	perl \
    libsqlite3-dev

RUN ln -s /usr/bin/make /usr/bin/gmake

#
# If run with docker build ... --build-arg useTarball=xxx then this will
# use the local tarball xxx.tar.gz instead of pulling from sourceforge.
#
	#ARG DISTRO="ion-4.0.0"
	#RUN wget --no-check-certificate https://downloads.sourceforge.net/project/ion-dtn/$DISTRO\.tar.gz
	#RUN tar -zxf $DISTRO\.tar.gz
	#RUN cd $DISTRO
	#WORKDIR /$DISTRO
	#RUN ./configure --prefix=/var/ionbuild && make && make install

################
	ADD ./ion-open-source-4.0.0_mods.tar.gz /tmp/
	ADD ./ion-open-source-4.0.0.tar.gz /tmp/
	WORKDIR /tmp/ion-open-source-4.0.0_mods
    RUN ./configure && make && make install
    #
    # That whole 2-stage build -- the contrib directory's not so cool with it
    # DISABLED for now
    # RUN mkdir -p /var/ionbuild && ./configure --prefix=/var/ionbuild && make && make install
    #
	WORKDIR /tmp/ion-open-source-4.0.0_mods/contrib/dtnsuite/al_bp
    RUN make ION_DIR=../../.. && make install
	WORKDIR /tmp/ion-open-source-4.0.0_mods/contrib/dtnsuite/dtnbox
    RUN make ION_DIR=../../..  AL_BP_DIR=../al_bp && make install
	WORKDIR /tmp/ion-open-source-4.0.0_mods/contrib/dtnsuite/dtnfog
    RUN make ION_DIR=../../..  AL_BP_DIR=../al_bp && make install
	WORKDIR /tmp/ion-open-source-4.0.0_mods/contrib/dtnsuite/dtnperf
    RUN make ION_DIR=../../..  AL_BP_DIR=../al_bp && make install
	WORKDIR /tmp/ion-open-source-4.0.0_mods/contrib/dtnsuite/dtnproxy
    RUN make ION_DIR=../../..  AL_BP_DIR=../al_bp && make install
	WORKDIR /tmp/ion-open-source-4.0.0_mods/contrib/dtnsuite/dtntunnel

#
# These are generally useful.
#
RUN apt -y update && apt -y install \
	psmisc \
	curl \
	python3-pip \
	iproute2 \
	net-tools \
	iputils-ping \
	python \
	python-pexpect

#
# Do this separately to get the newer version that works w/ Elasticsearch 6.1.1
#
RUN pip3 install elasticsearch

#
# Uncomment the following if you'd like to have some extra tools
# in the container.
#
# tshark asks in the middle of the install if normal users
# should be allowed to do packet captures.
# DEBIAN_FRONTEND=noninteractive takes care of that.
RUN apt -y update && DEBIAN_FRONTEND=noninteractive apt -y install \
	tcpdump tshark \
	ebtables \
	telnet \
	tree \
	less \
	binutils \
	openssh-client \
	openssh-server \
	iptables \
	netcat \
	iperf \
	vim


# ldconfig will complain that libxxx.so.0 is not a symbolic link to
# libxxx.so.0.0.0 -- this is a result of the COPY commands; not sure what to do
# about that unless removing the * from the source directory paths would cause the
# COPY to preserve the linked-ness of the .so.0 files
RUN ldconfig

RUN mkdir /docker
#VOLUME /docker 

WORKDIR /tmp/ion-open-source-4.0.0/tests/

#ENTRYPOINT ["tail -f /dev/null"]
#ENTRYPOINT ["/bin/sleep" "10d"]
ENTRYPOINT ["tail", "-f", "/dev/null"]

