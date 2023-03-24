#!/bin/bash

echo "Restore Harbor Data from Remote NFS"


systemctl stop harbor

cd /harbor
rm -fr data
mkdir data

cd /nfs/harbor
latest_backup=`ls -a |grep ^[0-9] |sort -r |head -n 1`

cp -frp $latest_backup/* /harbor/data

cd /harbor/harbor
./install.sh

systemctl start harbor
