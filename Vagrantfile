# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.box_check_update = true
  config.vm.hostname = "rt4-dev"

  config.vm.provider :parallels do |prl, override|
    prl.name = "RT4 Machine"
    prl.update_guest_tools = true
    prl.customize ["set", :id, "--longer-battery-life", "off"]
    prl.memory = 1024
    prl.cpus = 2
  end

  config.vm.provider :virtualbox do |vb, override|
    vb.name = "RT4  Machine"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provider :vmware_workstation do |vm, override|
    vm.vmx["memsize"] = "1024"
    vm.vmx["numvcpus"] = "1"
  end

  config.vm.provision "shell", path: ".provision/vagrant.sh"
end
