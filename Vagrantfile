Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/lunar64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  config.vm.define "main" do |main|
    main.vm.hostname = "main"
    main.vm.network "private_network", virtualbox__intnet: "radvtest1", auto_config: false
    main.vm.provision "shell", path: "main/provision.sh"
  end

  config.vm.define "router_h" do |router_h|
    router_h.vm.hostname = "router-h"
    router_h.vm.network "private_network", virtualbox__intnet: "radvtest1", auto_config: false
    router_h.vm.provision "shell", path: "router_h/provision.sh"
  end

  config.vm.define "router_m" do |router_m|
    router_m.vm.hostname = "router-m"
    router_m.vm.network "private_network", virtualbox__intnet: "radvtest1", auto_config: false
    router_m.vm.provision "shell", path: "router_m/provision.sh"
  end

  config.vm.define "router_l" do |router_l|
    router_l.vm.hostname = "router-l"
    router_l.vm.network "private_network", virtualbox__intnet: "radvtest1", auto_config: false
    router_l.vm.provision "shell", path: "router_l/provision.sh"
  end

end
