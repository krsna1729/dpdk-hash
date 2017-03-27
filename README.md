Environment
===========

Make sure `Vagrant` is setup for the platform of your choice. If you are behind a proxy, install `vagrant-proxyconf` plugin and export the http(s) proxy, no_proxy variables. The `Vagrantfile` will pick it up and provision the Ubuntu box accordingly.

```shell
git clone https://github.com/krsna1729/dpdk-hash.git
# Alternately, download and extract zip https://github.com/krsna1729/dpdk-hash/archive/master.zip
cd dpdk-hash

vagrant up
vagrant ssh
cd dpdk
```

Basic Fwd
==========

Simple RX TX app. TX pcaps will be of the same size as RX. All are transmitted.

```shell
ll *.pcap # should see no PCAP files
make -C examples/skeleton/

sudo ./examples/skeleton/build/basicfwd --no-pci \
--vdev=net_pcap0,rx_pcap=/vagrant/pcaps/64K_dst0.pcap,tx_pcap=b_output0.pcap \
--vdev=net_pcap1,rx_pcap=/vagrant/pcaps/64K_dst1.pcap,tx_pcap=b_output1.pcap

# Press Ctrl+C to quit after 2s
ll *.pcap # should see 2 new PCAP files b_output0 b_output1
```

Whitelist Fwd
=============

Here we whitelist half the IPs (even) in the app. The TX pcaps must be half the size of RX.

```shell
git apply /vagrant/patches/skeleton_whitelist_ips.patch
ll *.pcap
make -C examples/skeleton/

sudo ./examples/skeleton/build/basicfwd --no-pci \
--vdev=net_pcap0,rx_pcap=/vagrant/pcaps/64K_dst0.pcap,tx_pcap=a_output0.pcap \
--vdev=net_pcap1,rx_pcap=/vagrant/pcaps/64K_dst1.pcap,tx_pcap=a_output1.pcap

# Press Ctrl+C to quit after 2s
ll *.pcap   # should see 2 new PCAP files a_output0 a_output1 half the size
```

Benchmark Lib
=============

Try out the different patches `test_<>.patch` and see the effect on table occupancy .

```shell
git checkout lib/librte_hash/rte_cuckoo_hash.c
git apply /vagrant/patches/test_<>.patch
make -j > /dev/null

# Benchmark
sudo ./build/app/test --no-pci -- -i
hash_autotest
```

Appendix
========

Part of the vagrant provisioning script

Install DPDK
------------

```shell
git clone http://dpdk.org/git/dpdk
cd dpdk
git checkout v16.11

#Enable PCAP PMD
sed -ri 's,(PMD_PCAP=).*,\1y,' config/common_base

make config T=x86_64-native-linuxapp-gcc
make -j4
export RTE_SDK=$(pwd)
export RTE_TARGET=build

sudo sysctl -w vm.nr_hugepages=256
```
