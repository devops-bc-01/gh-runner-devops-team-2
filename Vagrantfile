# -*- mode: ruby -*-
# vi: set ft=ruby :


N = 2

nodes = [
  {
    :node => "devops-runner-team-02-00",
    :cpu => 4,
    :mem => 4056
  },
  {
    :node => "devops-runner-team-02-01",
    :cpu => 4,
    :mem => 4056
  }
]

port_forwards = [
  {
    :node => "devops-runner-team-02-00",
    :guest => 3000,
    :host => 8080
  },
  {
    :node => "devops-runner-team-02-00",
    :guest => 3001,
    :host => 8081
  },
  {
    :node => "devops-runner-team-02-00",
    :guest => 3002,
    :host => 8082
  },
  {
    :node => "devops-runner-team-02-00",
    :guest => 3003,
    :host => 8083
  },
  {
    :node => "devops-runner-team-02-00",
    :guest => 3004,
    :host => 8084
  }
]

Vagrant.configure(2) do |config|

  (1..N).each do |node_id|
    nid = (node_id - 1)

    config.env.enable
    config.ssh.insert_key = false
    config.vm.define "devops-runner-team-02-0#{nid}" do |node|
      nodes.each do |cust_box|
        if cust_box[:node] == "devops-runner-team-02-0#{nid}"
          node.vm.provision "shell" do |s|
            s.path = "./scripts/runner_provision.sh"
            s.args = [
              ENV['RUNNER_URL'],
              ENV['GITHUB_URL'],
              ENV['GITHUB_TOKEN'],
              "devops-runner-team-02-0#{nid}",
              ENV['RUNNER_DIR'],
              ENV['RUNNER_VERSION'],
              ENV['GITHUB_HASH'],
            ]
            s.privileged = false
          end
        end
      end
      node.vm.box = ENV['BOX']
      node.vm.provider "virtualbox" do |vb|
        nodes.each do |custom_node|
          if custom_node[:node] == "devops-runner-team-02-0#{nid}"
            vb.customize ["modifyvm", :id, "--cpus", custom_node[:cpu]]
            vb.customize ["modifyvm", :id, "--memory", custom_node[:mem]]
          end
        end
      end
      node.vm.hostname = "devops-runner-team-02-0#{nid}"
      port_forwards.each do |pf|
        if pf[:node] == "devops-runner-team-02-0#{nid}"
          node.vm.network "forwarded_port", guest: pf[:guest], host: pf[:host]
        end
      end
      if nid == 0
        node.vm.network "forwarded_port", guest: 3000, host: 8080
        node.vm.provision "file", source: "./containers", destination: "$HOME/"
        node.vm.provision "file", source: "./docker-compose.yaml", destination: "$HOME/docker-compose.yaml"
        node.vm.provision :docker
        node.vm.provision :docker_compose

      end
      
      if nid == 1
        node.vm.provision "shell", inline: <<-SHELL
          sudo apt-get -y update
          sudo apt-get -y install podman
        SHELL

      end
    end

  end
end