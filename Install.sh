#!/bin/bash

if [[ "${UID}" -ne 0 ]]
then
 echo 'Must execute with sudo or root' >&2
 exit 1
fi

mkdir /Minecraft
cd /tmp

apt update -y
apt upgrade -y
apt dist-upgrade -y
apt autoremove -y
apt install wget -y
apt install screen -y

wget https://download.java.net/java/GA/jdk17.0.1/2a2082e5a09d4267845be086888add4f/12/GPL/openjdk-17.0.1_linux-x64_bin.tar.gz
tar xvf openjdk-17.0.1_linux-x64_bin.tar.gz
mv jdk-17*/ /opt/jdk17

tee /etc/profile.d/jdk.sh <<EOF
export JAVA_HOME=/opt/jdk17
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

source /etc/profile.d/jdk.sh
java -version
rm openjdk*.gz 

cd /Minecraft
wget https://piston-data.mojang.com/v1/objects/5b868151bd02b41319f54c8d4061b8cae84e665c/server.jar

touch start.sh
echo "java -Xms12288M -Xmx12288M -jar /Minecraft/server.jar nogui" > start.sh
chmod +x start.sh
./start.sh

echo "eula=true" > eula.txt

touch screen_start.sh
echo "screen -dmS server bash -c '/Minecraft/start.sh'" > screen_start.sh
chmod +x screen_start.sh
echo "* * * * * /Minecraft/screen_start.sh" | crontab -

screen -dmS server bash -c '/Minecraft/start.sh'