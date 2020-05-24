# frozen_string_literal: true

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'

  # https://github.com/sprotheroe/vagrant-disksize
  # upgrade disksize
  config.disksize.size = '15GB'

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network 'private_network', ip: '192.168.33.10'

  # https://github.com/cogitatio/vagrant-hostsupdater
  # Used thin name in mutagen.yml of alpha
  config.vm.hostname = 'my-app'

  # sync at starting up vagrant
  config.vm.synced_folder './', '/home/vagrant/vagrantrailstest',
                          create: true,
                          type: :rsync,
                          rsync__auto: true,
                          rsync__exclude: ['.git/', 'node_modules/', 'log/', 'tmp/']

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.cpus = 4
    vb.memory = '4096'

    # https://qiita.com/yuki_ycino/items/cb21cf91a39ddd61f484
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
  end

  # https://github.com/dasginganinja/vagrant-mutagen
  config.mutagen.orchestrate = true

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get install -y time
    apt-get install -y postgresql-client
    alias dc='docker-compose'
  SHELL

  config.vm.provision :docker
  config.vm.provision :docker_compose
end
