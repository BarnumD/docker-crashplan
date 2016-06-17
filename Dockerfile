FROM phusion/baseimage

#Crashplan
#Prerequisites
RUN apt-get update; \
        apt-get upgrade -y; \
        apt-get -qy install expect wget openjdk-7-jre; \
        mkdir -p /scripts
COPY scripts/service_start_crashplan.sh /scripts/service_start_crashplan.sh
COPY scripts/crashplan-install.exp /scripts/crashplan-install.exp
RUN chmod +x /scripts/*.sh && chmod +x /scripts/*.exp;

#### Install crashplan
ENV pkgver=4.7.0
RUN mkdir -p /install/crashplan; cd /install/crashplan; \
        wget "http://download1.code42.com/installs/linux/install/CrashPlan/CrashPlan_""$pkgver""_Linux.tgz" -O crashplan.tar.gz; \
        tar zxf crashplan.tar.gz; \
        rm crashplan.tar.gz;

#Install with expect
RUN cd /install/crashplan/crashplan-install; \
        /scripts/crashplan-install.exp;

#Setup crashplan service
RUN mkdir -p /etc/service/crashplan; \
        ln -s /scripts/service_start_crashplan.sh /etc/service/crashplan/run

EXPOSE 4242 4243


#Needed for xterm / Crashplan Desktop GUI
RUN apt-get update; apt-get -y upgrade; \
    apt-get -y install xvfb ssh; \
    apt-get -y install x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps; \
    apt-get -y install xterm
EXPOSE 4222
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

#ADD personal/ssh_authorized_keys /root/.ssh/authorized_keys
RUN mkdir /mnt/data; touch /mnt/data/authorized_keys; ln -s /mnt/data/authorized_keys /root/.ssh/authorized_keys; rm -rf /mnt/data
