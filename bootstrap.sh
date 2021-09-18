#!/usr/bin/env bash

CPUS=$(nproc --all || echo 4)
RCLONE_VERSION='1.55.1'

mkdir bin
echo '-- installing rclone'
wget https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip
unzip rclone-v${RCLONE_VERSION}-linux-amd64.zip
mv rclone-v${RCLONE_VERSION}-linux-amd64/rclone bin/
rm -rf rclone-v${RCLONE_VERSION}-linux-amd64.zip rclone-v${RCLONE_VERSION}-linux-amd64
echo '-- installing xxHash'
wget https://github.com/Cyan4973/xxHash/archive/v0.8.0.tar.gz
tar -xf v0.8.0.tar.gz
cd xxHash-0.8.0
make -j ${CPUS}
mv xxh*sum ../bin/
cd ..
rm -rf xxHash-0.8.0 v0.8.0.tar.gz
echo '-- installing Speedtest CLI'
wget https://bintray.com/ookla/download/download_file\?file_path\=ookla-speedtest-1.0.0-x86_64-linux.tgz -O ookla-speedtest-1.0.0-x86_64-linux.tgz
cd bin
tar -xf ../ookla-speedtest-1.0.0-x86_64-linux.tgz
./speedtest --accept-license --accept-gdpr &> /dev/null
rm -f speedtest.5 speedtest.md ../ookla-speedtest-1.0.0-x86_64-linux.tgz
cd ..
echo '-- installing Storj uplink'
curl -L https://github.com/storj/storj/releases/latest/download/uplink_linux_amd64.zip -o uplink_linux_amd64.zip
unzip -o uplink_linux_amd64.zip
chmod 755 uplink
mv uplink bin/
rm -f uplink_linux_amd64.zip
