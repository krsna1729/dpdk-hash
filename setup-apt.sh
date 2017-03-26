#!/bin/sh

sudo apt-get update && sudo apt-get -y install \
	build-essential git libpcap-dev \
        linux-image-extra-$(uname -r) linux-headers-$(uname -r)

echo "export RTE_SDK=$HOME/dpdk" | tee -a $HOME/.profile
echo "export RTE_TARGET=build" | tee -a $HOME/.profile
. $HOME/.profile

echo "vm.nr_hugepages=256" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

git clone http://dpdk.org/git/dpdk -b v16.11 $RTE_SDK
#Enable PCAP PMD
sed -ri 's,(PMD_PCAP=).*,\1y,' $RTE_SDK/config/common_base
make config T=x86_64-native-linuxapp-gcc -C $RTE_SDK
make -j4 -C $RTE_SDK

