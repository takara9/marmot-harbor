#!/bin/bash

echo "Backup Harbor Data to Remote NFS"

unixtime=`date +%s`
dst=`printf "/nfs/harbor/%s" $unixtime`
systemctl stop harbor
cd /harbor
cp -frp data $dst
systemctl start harbor
