Environment
===========

Make sure `Vagrant` and `Virtualbox` is setup for the platform of your choice. If you are behind a proxy, install `vagrant-proxyconf` plugin and export the http(s) proxy, no_proxy variables. The `Vagrantfile` will pick it up and provision the Ubuntu box accordingly.

```shell
git clone https://github.com/krsna1729/dpdk-hash.git
# Alternately, download and extract zip https://github.com/krsna1729/dpdk-hash/archive/master.zip
cd dpdk-hash

vagrant up
vagrant ssh
cd dpdk
```

If you want to experiment without having to use Vagrant, you can run setup-apt.sh on 16.04 Ubuntu box to get all the packages installed, hugepages setup and DPDK compiled correctly. Make sure you provide appropriate file paths to patches and pcaps when running the below commands. All below commands will be run from the dpdk directory.

Basic Fwd
==========

Simple RX TX app. TX pcaps will be of the same size as RX. All are transmitted.

```shell
ll -h /vagrant/pcaps/*.pcap # should see 2 PCAP
ll -h *.pcap                # should see no PCAP files
make -C examples/skeleton/

sudo ./examples/skeleton/build/basicfwd --no-pci \
--vdev=net_pcap0,rx_pcap=/vagrant/pcaps/64K_dst0.pcap,tx_pcap=b_output0.pcap \
--vdev=net_pcap1,rx_pcap=/vagrant/pcaps/64K_dst1.pcap,tx_pcap=b_output1.pcap

# Press Ctrl+C to quit after 2s
ll -h *.pcap                # should see 2 new PCAP files b_output0 b_output1
```

Whitelist Fwd
=============

Here we whitelist half the IPs (even) in the app. The TX pcaps must be half the size of RX.

```shell
git apply /vagrant/patches/skeleton_whitelist_ips.patch
make -C examples/skeleton/

sudo ./examples/skeleton/build/basicfwd --no-pci \
--vdev=net_pcap0,rx_pcap=/vagrant/pcaps/64K_dst0.pcap,tx_pcap=a_output0.pcap \
--vdev=net_pcap1,rx_pcap=/vagrant/pcaps/64K_dst1.pcap,tx_pcap=a_output1.pcap

# Press Ctrl+C to quit after 2s
ll -h *.pcap                # 2 new PCAP files a_output0 a_output1 half the size
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

Snapshot of SW versions
-----------------------

```none
vagrant: 1.9.3
vagrant-proxyconf (1.5.2)
VitualBox: 5.1.14
Host: Win8.1
```
