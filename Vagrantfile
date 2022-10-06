# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

Vagrant.configure("2") do |config|

  file = File.read('./keys.json')
  data_hash = JSON.parse(file)

  # print file
  # print data_hash

  # print data_hash['docker_ram']
  
    (1..data_hash['docker_node_count']).each do |i|
      config.vm.define "docker-#{i}" do |dockerConfig|
        dockerConfig.vm.box = data_hash['vm_image']
        dockerConfig.vm.hostname = "devops-runner-team-2-#{i}"
        dockerConfig.vm.synced_folder ".", "/vagrant"
        dockerConfig.vm.provider :virtualbox do |vb|
          vb.gui = false
          vb.memory = data_hash['docker_ram']
          vb.cpus = data_hash['docker_cpus']
        end
      
      end
    end

  end

  