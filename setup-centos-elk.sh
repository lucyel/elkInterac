#!/bin/bash

timedatectl set-timezone Asia/Ho_Chi_Minh

systemctl stop firewalld
systemctl disable firewalld

printf "\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\n" >> /etc/sysctl.conf

sysctl -p

yum install epel-release -y

yum install -y net-tools telnet htop iftop wget git gcc make nano java-11-openjdk-devel

rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
printf "[elasticsearch-7.x]\nname=Elastisearch repository for 7.x packages\nbaseurl=https://artifacts.elastic.co/packages/7.x/yum\ngpgcheck=1\ngpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch\nenabled=1\nautorefresh=1\ntype=rpm-md\n" > /etc/yum.repos.d/elasticsearch.repo

yum install -y elasticsearch kibana logstash filebeat auditbeat elastic-agent
