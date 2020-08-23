#!/bin/bash

timedatectl set-timezone Asia/Ho_Chi_Minh

systemctl stop firewalld
systemctl disable firewalld

printf "\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\n" >> /etc/sysctl.conf

sysctl -p

tar -xzvf jdk-11.0.4_linux-x64_bin.tar.gz -C /opt/
alternatives --install /usr/bin/jar jar /opt/jdk-11.0.4/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/jdk-11.0.4/bin/javac 2
alternatives --set jar /opt/jdk-11.0.4/bin/jar
alternatives --set javac /opt/jdk-11.0.4/bin/javac

printf "\nexport JAVA_HOME=/opt/jdk-11.0.4\nexport JRE_HOME=/opt/jdk-11.0.4/jre\nexport PATH=$PATH:/opt/jdk-11.0.4/bin:opt/jdk-11.0.4/jre/bin\n" >> /root/.bashrc

alternatives --install /usr/bin/java java /opt/jdk-11.0.4/bin/java 2
echo 1 | alternatives --config java

sleep 5

yum install epel-release -y

yum install -y net-tools telnet htop iftop wget git gcc make nano

rpm --httpproxy http://proxy.ho.fpt.vn:8080 --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
printf "[elasticsearch-7.x]\nname=Elastisearch repository for 7.x packages\nbaseurl=https://artifacts.elastic.co/packages/7.x/yum\ngpgcheck=1\ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch\nenabled=1\nautorefresh=1\ntype=rpm-md\n" > /etc/yum.repos.d/elasticsearch.repo

yum install -y elasticsearch

