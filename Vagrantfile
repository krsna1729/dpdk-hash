# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
 if Vagrant.has_plugin?("vagrant-proxyconf")
   config.proxy.http     = ENV['http_proxy']
   config.proxy.https    = ENV['https_proxy']
   config.proxy.no_proxy = ENV['no_proxy']
 end
 config.vm.provider :virtualbox do |v|
  v.customize ["modifyvm", :id, "--memory", 4096]
 end

 config.vm.define :test do |test|
   test.vm.box = "bento/ubuntu-16.04"
   test.vm.provision "shell", path: "setup-apt.sh", privileged: false 
 end
end
