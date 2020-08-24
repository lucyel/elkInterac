#!/bin/bash

apt update
apt install apt-transport-https

apt install openjdk-11-jdk

printf 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"'

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

apt update

apt install elasticsearch
