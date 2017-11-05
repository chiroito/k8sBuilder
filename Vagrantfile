# -*- mode: ruby -*-
# vi: set ft=ruby :

# vagrant plugin install vagrant-proxyconf
# vagrant plugin install vagrant-disksize

require 'yaml'
require 'date'

yml = YAML.load_file('config.yml');

class Input
  def initialize(output, hidden=false)
    @output = output
    @hidden = hidden
  end

  def to_s
    if @input.nil? then
      print @output
      begin
        system 'stty -echo' if @hidden
        @input = STDIN.gets.chomp
      ensure
        system 'stty echo' if @hidden
      end
    end
    @input
  end
end


def vmConfig(node, hostname, cpu_count, memory_size, disk_size)
  # VM
  node.vm.provider 'virtualbox' do |vb|
    vb.name = hostname
    vb.cpus = cpu_count
    vb.memory = memory_size
  end
  node.disksize.size = disk_size
end

def osConfig(node, hostname, ip, netmask, iface, gateway)
  node.vm.network 'public_network', ip: ip, netmask: netmask, bridge: iface
  node.vm.provision 'shell', run: 'always', path: 'config_gateway.sh', args: gateway
  node.vm.hostname = hostname
end

username = Input.new("Please input user and password @container-registry.oracle.com.\nUsername(mail): ")
password = Input.new('Password: ', true)
token = Input.new("Please input k8s token.\nToken: ")

# Config ####
Vagrant.configure('2') do |config|

  config.vm.box = 'ol74'
  config.vm.box_url = 'http://yum.oracle.com/boxes/oraclelinux/ol74/ol74.box'
  config.vm.synced_folder yml['host']['shared_dir'], '/mnt/hostshared', create: true

  #vagrant plugin install vagrant-proxyconf
  if Vagrant.has_plugin?('vagrant-proxyconf')
    if !yml['network']['proxy_host'].empty? then
      config.proxy.http = "http://#{yml['network']['proxy_host']}:#{yml['network']['proxy_port']}/"
      config.proxy.https = "http://#{yml['network']['proxy_host']}:#{yml['network']['proxy_port']}/"
      config.proxy.no_proxy = yml['network']['no_proxy'] << ',' << yml['master']['ip'] << ',*.' << yml['network']['domain']
    end
  end

  # build os
  config.vm.provision 'shell', path: 'os.sh'

  # Configuration for docker & k8s
  if yml['docker']['kube_repo'].empty? then
    config.vm.provision 'shell', path: 'login_oracle_registry.sh', env: {'USERNAME' => username, 'PASSWORD' => password}
  else
    config.vm.provision 'shell', path: 'use_local_kube_registry.sh', args: [yml['docker']['kube_repo']]
  end

  if yml['docker']['build_registry'] || yml['docker']['secure_repo'] == false then
    config.vm.provision 'shell', path: 'use_insecure_registry.sh', args: [yml['docker']['kube_repo']]
  end


  # Master #####
  config.vm.define yml['master']['hostname'] do |master|

    vmConfig(master, yml['master']['hostname'], yml['master']['cpu'], yml['master']['memory'], yml['master']['disksize'])
    osConfig(master, yml['master']['hostname'], yml['master']['ip'], yml['network']['netmask'], yml['host']['interface'], yml['network']['gateway'])

    # Provisioning local registry on Master
    if yml['docker']['build_registry'] then
      master.vm.provision 'shell', path: 'build_registry.sh'
    end
    if yml['docker']['prepare_registry'] then
      master.vm.provision 'shell', path: 'prepare_registry.sh', args: [yml['docker']['kube_repo']]
    end

    master.vm.provision 'shell', path: 'master.sh'

    # show the cluster information
    master.vm.provision 'shell', run: 'always', path: 'show_cluster_info.sh'
  end


  # Worker #####
  worker_num = yml['worker']['members'].size
  (1..worker_num).each do |i|
    config.vm.define yml['worker']['members'][i]['hostname'] do |worker|

      vmConfig(worker, yml['worker']['members'][i]['hostname'], yml['worker']['cpu'], yml['worker']['memory'], yml['worker']['disksize'])
      osConfig(worker, yml['worker']['members'][i]['hostname'], yml['worker']['members'][i]['ip'], yml['network']['netmask'], yml['host']['interface'], yml['network']['gateway'])

      worker.vm.provision 'shell', path: 'worker.sh', env: {'TOKEN' => token}, args: [yml['master']['ip']]

      # show the cluster information
      worker.vm.provision 'shell', run: 'always', path: 'show_cluster_info.sh'
    end
  end
end
