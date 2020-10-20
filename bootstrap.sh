#!/usr/bin/env bash

CPUS=$(nproc || echo 4)

mkdir bin
echo '-- installing rclone'
wget https://downloads.rclone.org/v1.53.1/rclone-v1.53.1-linux-amd64.zip
unzip rclone-v1.53.1-linux-amd64.zip
mv rclone-v1.53.1-linux-amd64/rclone bin/
rm -rf rclone-v1.53.1-linux-amd64.zip rclone-v1.53.1-linux-amd64
echo '-- installing xxHash'
wget https://github.com/Cyan4973/xxHash/archive/v0.8.0.tar.gz
tar -xf v0.8.0.tar.gz
cd xxHash-0.8.0
make -j ${CPUS}
mv xxh*sum ../bin/
cd ..
rm -rf xxHash-0.8.0 v0.8.0.tar.gz

