# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
VAGRANT_REQUIRED_VERSION = "1.8.0"
VAGRANT_REQUIRED_LINKED_CLONE_VERSION = "1.8.4"

# Require 1.6.5 at least
if ! defined? Vagrant.require_version
  if Gem::Version.new(Vagrant::VERSION) < Gem::Version.new(VAGRANT_REQUIRED_VERSION)
    puts "Vagrant >= " + VAGRANT_REQUIRED_VERSION + " required. Your version is " + Vagrant::VERSION
    exit 1
  end
else
  Vagrant.require_version ">= " + VAGRANT_REQUIRED_VERSION
end

nodes = {}
if File.exists?("Vagrantfile.nodes") then
  eval(IO.read("Vagrantfile.nodes"), binding)
end

# allow to override the configuration
if File.exists?("Vagrantfile.local") then
  eval(IO.read("Vagrantfile.local"), binding)
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes.each_pair do |name, options|
    config.vm.define name do |node_config|
      node_config.vm.box = options[:box_virtualbox]
      node_config.vm.hostname = name + "." + options[:net]
      node_config.vm.box_url = options[:url] if options[:url]
      if options[:forwarded]
        options[:forwarded].each_pair do |guest, local|
          node_config.vm.network "forwarded_port", guest: guest, host: local, auto_correct: true
        end
      end

      if options[:synced_folders]
        options[:synced_folders].each_pair do |source, target|
          node_config.vm.synced_folder source, target
        end
      end

      node_config.vm.network :private_network, ip: options[:hostonly] if options[:hostonly]

      # provider: parallels
      node_config.vm.provider :parallels do |p, override|
        override.vm.box = options[:box_parallels]
        override.vm.boot_timeout = 600

        p.name = "RT4: #{name.to_s}"
        p.update_guest_tools = false
        #p.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new(VAGRANT_REQUIRED_LINKED_CLONE_VERSION)

        # Set power consumption mode to "Better Performance"
        p.customize ["set", :id, "--longer-battery-life", "off"]

        p.memory = options[:memory] if options[:memory]
        p.cpus = options[:cpus] if options[:cpus]
      end

      # provider: virtualbox
      node_config.vm.provider :virtualbox do |vb, override|
        if Vagrant.has_plugin?("vagrant-vbguest")
          node_config.vbguest.auto_update = false
        end
        vb.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new(VAGRANT_REQUIRED_LINKED_CLONE_VERSION)
        vb.name = name
        vb.gui = options[:gui] if options[:gui]
        vb.customize ["modifyvm", :id,
          "--groups", "/NETWAYS Vagrant/" + options[:net],
          "--memory", "512",
          "--cpus", "1",
          "--audio", "none",
          "--usb", "on",
          "--usbehci", "off",
          "--natdnshostresolver1", "on"
        ]
        vb.memory = options[:memory] if options[:memory]
        vb.cpus = options[:cpus] if options[:cpus]
      end

      # provider: libvirt
      node_config.vm.provider :libvirt do |lv, override|
        override.vm.box = options[:box_libvirt]
        lv.memory = options[:memory] if options[:memory]
        lv.cpus = options[:cpus] if options[:cpus]
      end

      # provider: vmware
      node_config.vm.provider :vmware_workstation do |vm, override|
        override.vm.box = options[:box_vmware]
        vm.vmx["memsize"] = options[:memory] if options[:memory]
        vm.vmx["numvcpus"] = options[:cpus] if options[:cpus]
      end

      node_config.vm.provision "shell", path: "provision/vagrant.sh"

      # print a friendly message
      node_config.vm.provision "shell", inline: <<-SHELL
        echo "Finished installing the Vagrant box '#{name}'."
        echo "Navigate to http://#{options[:hostonly]}"
      SHELL
    end
  end
end
