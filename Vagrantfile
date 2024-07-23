# -*- mode: ruby -*-
# vi: set ft=ruby :

# name: wnaseeve
# pswd: wnaseeve

LOCAL_USER = ENV['USER']
print "Local user: #{LOCAL_USER}\n"
VAGRANT_HOME = "/media/wnaseeve/Extreme\ SSD/cloud-1-VM "

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"
    config.vm.disk :disk, size: "500GB", primary: true
    config.vm.provider "virtualbox" do |vb|
      vb.name = "#{LOCAL_USER}"
      vb.gui = true
      vb.memory = "12000"
      vb.cpus = "12"
      vb.customize ["modifyvm", :id, "--name", "#{LOCAL_USER}"]
      vb.customize ["setproperty", "machinefolder", VAGRANT_HOME]
    end

    # Script to install components
    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        # Basic installation
        apt-get update -y
        apt-get upgrade -y
        apt install -y sudo
        apt-get install -y git vim make wget curl openssh-server ufw
        apt-get install -y build-essential
        DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop
        # Install Docker
        curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
        # Install Ansible, Python3, boto, and boto3
        apt-get install -y ansible python3 python3-pip
        pip3 install boto boto3
        apt-get install -y python3-boto
    SHELL

    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        useradd -m -s /bin/bash wnaseeve
        usermod -aG sudo wnaseeve
        usermod -aG docker wnaseeve
        echo "wnaseeve ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

        # Hostname setup
        hostnamectl set-hostname wnaseeve
        
        # Firewall setup
        ufw allow OpenSSH
        ufw allow 443
        ufw --force enable
    SHELL

    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        # Install Oh-My-Zsh
        sudo apt-get install -y zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        apt-get update
        apt-get install -y brave-browser

        # Install VSCode
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
        apt-get update
        apt-get install -y code

        # Remove installation files and reboot
        shutdown -r now
    SHELL
end
