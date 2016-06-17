#!/bin/bash
## Crashplan startup script. Alters the serviceHost value in my.service.xml to the current Docker IP Address
interface=eth0
cmd=/usr/local/crashplan/bin/CrashPlanEngine
myservicexml=/usr/local/crashplan/conf/my.service.xml


if [ ! -f /mnt/data/id ]; then
  mkdir -p /mnt/data/id;
  cp -r /var/lib/crashplan/. /mnt/data/id/
fi
rm -rf /var/lib/crashplan
ln -s /mnt/data/id /var/lib/crashplan

if [ ! -f /mnt/data/conf ]; then
  mkdir -p /mnt/data/conf;
  cp -r /usr/local/crashplan/conf/. /mnt/data/conf/
fi
rm -rf /usr/local/crashplan/conf
ln -s /mnt/data/conf /usr/local/crashplan/conf

if [ ! -f /mnt/data/log ]; then
  mkdir -p /mnt/data/log;
  cp -r /usr/local/crashplan/log/. /mnt/data/log/
fi
rm -rf /usr/local/crashplan/log
ln -s /mnt/data/log /usr/local/crashplan/log

if [ ! -f $myservicexml ]; then
  $cmd start
  sleep 10
  addr=$(ip -f inet -o addr show $interface|cut -d\  -f 7 | cut -d/ -f 1)
  sed -i "s:<serviceHost>.*</serviceHost>:<serviceHost>$addr</serviceHost>:" $myservicexml
  sed -i "s:<manifestPath>.*</manifestPath>:<manifestPath>$backupLoc/</manifestPath>:" $myservicexml
  $cmd restart
else
  addr=$(ip -f inet -o addr show $interface|cut -d\  -f 7 | cut -d/ -f 1)
  sed -i "s:<serviceHost>.*</serviceHost>:<serviceHost>$addr</serviceHost>:" $myservicexml
  sed -i "s:<manifestPath>.*</manifestPath>:<manifestPath>$backupLoc/</manifestPath>:" $myservicexml
  $cmd start
fi

sleep 1

#Start Crashplan Desktop app
#/usr/local/crashplan/bin/CrashPlanDesktop

tail -f /usr/local/crashplan/log/engine_error.log
echo "Tail ended"


