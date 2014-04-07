# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "wagnaria"
  config.vm.box = "ichigo-wheezy"
  config.vm.network :private_network, ip: "192.168.63.17"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpus", 1]
  end
#  config.ssh.max_tries = 40
#  config.ssh.timeout   = 120
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
        "recipe[apt]",
        "recipe[wagnaria]"
    ]
  end
end
