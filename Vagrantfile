# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

yml = YAML.load_file('config.yml');

class Username
  def to_s
    print "Please input user and password @container-registry.oracle.com.\n"
    print 'Username(mail): '
    STDIN.gets.chomp
  end
end

class Password
  def to_s
    begin
      system 'stty -echo'
      print 'Password: '
      pass = URI.escape(STDIN.gets.chomp)
    ensure
      system 'stty echo'
    end
    pass
  end
end

class Token
  def to_s
    print "Please input k8s token.\n"
    print 'Token: '
    STDIN.gets.chomp
  end
end


# Config ####
Vagrant.configure('2') do |config|

  config.vm.box = 'ol74'
  config.vm.box_url = 'http://yum.oracle.com/boxes/oraclelinux/ol74/ol74.box'
  config.vm.synced_folder yml['host']['shared_dir'], '/mnt/hostshared', create: true

  #vagrant plugin install vagrant-proxyconf
  if Vagrant.has_plugin?('vagrant-proxyconf')
    config.proxy.http = "http://#{yml['network']['proxy_host']}:#{yml['network']['proxy_port']}/"
    config.proxy.https = "http://#{yml['network']['proxy_host']}:#{yml['network']['proxy_port']}/"
    config.proxy.no_proxy = yml['network']['no_proxy'] << ',' << yml['master']['ip'] << ',*.' << yml['network']['domain']
  end

  # build os
  config.vm.provision 'shell', path: 'os.sh'

  # Login container-registry.oracle.com
  config.vm.provision 'shell' do |s|
    s.env = {'USERNAME' => Username.new, 'PASSWORD' => Password.new}
    s.inline = 'docker login -u ${USERNAME} -p ${PASSWORD} container-registry.oracle.com'
  end

  if yml['docker']['build_registry'] || yml['docker']['secure_repo'] == false then
    config.vm.provision 'shell' do |s|
      s.inline = <<-EOL
          cat << EOF > /etc/docker/daemon.json
{
  "insecure-registries" : ["#{yml['docker']['kube_repo']}"]
}
EOF
          systemctl daemon-reload
          systemctl restart docker
      EOL
    end
  end

  config.vm.provision 'shell' do |s|
    s.inline = <<-EOL
          export KUBE_REPO_PREFIX=#{yml['docker']['kube_repo']}/kubernates
          echo 'export KUBE_REPO_PREFIX=#{yml['docker']['kube_repo']}/kubernates' >> $HOME/.bashrc
    EOL
  end


  # Master #####
  config.vm.define yml['master']['hostname'] do |master|

    # VM
    master.vm.provider 'virtualbox' do |vb|
      vb.name = yml['master']['hostname']
      vb.cpus = yml['master']['cpu']
      vb.memory = yml['master']['memory']
    end
    master.disksize.size = yml['master']['disksize']

    #
    master.vm.network 'public_network', ip: yml['master']['ip'], netmask: yml['network']['netmask'], bridge: yml['host']['interface']
    master.vm.provision 'shell', run: 'always', inline: "route add default gw #{yml['network']['gateway']}"
    master.vm.provision 'shell', run: 'always', inline: 'route del default gw 10.0.2.2'
    master.vm.hostname = yml['master']['hostname']

    # Provisioning local registry on Master
    if yml['docker']['build_registry'] then
      master.vm.provision 'shell', path: 'build_registry.sh'
    end
    if yml['docker']['prepare_registry'] then
      master.vm.provision 'shell', path: 'prepare_registry.sh', args: [yml['docker']['kube_repo']]
    end

    master.vm.provision 'shell', path: 'master.sh'
  end


  # Worker #####
  worker_num = yml['worker']['members'].size
  (1..worker_num).each do |i|
    config.vm.define yml['worker']['members'][i]['hostname'] do |worker|

      # VM
      worker.vm.provider 'virtualbox' do |vb|
        vb.name = yml['worker']['members'][i]['hostname']
        vb.cpus = yml['worker']['cpu']
        vb.memory = yml['worker']['memory']
      end
      worker.disksize.size = yml['worker']['disksize']

      # Network
      worker.vm.network 'public_network', ip: yml['worker']['members'][i]['ip'], netmask: yml['network']['netmask'], bridge: yml['host']['interface']
      worker.vm.provision 'shell', run: 'always', inline: "route add default gw #{yml['network']['gateway']}"
      worker.vm.provision 'shell', run: 'always', inline: 'route del default gw 10.0.2.2'
      worker.vm.hostname = yml['worker']['members'][i]['hostname']

      # k8s
      worker.vm.provision 'shell' do |s|
        s.env = {'TOKEN' => Token.new}
        s.inline = <<-EOL
          kubeadm-setup.sh join --token ${TOKEN} #{yml['master']['ip']}:6443
          export KUBECONFIG=/etc/kubernetes/kubelet.conf
          echo 'export KUBECONFIG=/etc/kubernetes/kubelet.conf' >> $HOME/.bashrc
        EOL
      end

      # check
      worker.vm.provision 'shell', run: 'always', inline: 'kubectl get nodes'
    end
  end
end
