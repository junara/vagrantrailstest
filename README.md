# README

This is test repository of Rails for docker with vagrant on Mac.

# Screenshot

![image](https://user-images.githubusercontent.com/17272426/82747079-d75a5000-9dd0-11ea-904c-0532e11d84cd.png)
# Setup

## Common set up

```
docker-compose exec web build
docker-compose exec web up -d
docker-compose exec web bin/setup 
```

## With Docker on Mac
1. Common set up
2. Following set up, access to `http://localhost:3000/`

## with Docker on vagrant
1. Install VirtualBox
2. Install Vagrant, plugin and mutagen
3. Create `Vagrantfile` for vagrant (vm).
4. Create `mutagen.yml` for mutagen (file sync)
5. Start vagrant
6. ssh to vagrant
7. Common set up

### How to movie
[![](http://img.youtube.com/vi/1xBksIE2vAk/0.jpg)](http://www.youtube.com/watch?v=1xBksIE2vAk "")

### 1. Install VirtualBox
Accessed https://www.virtualbox.org/wiki/Downloads

Download and install.

### 2. Install Vagrant, plugin and mutagen
Accessed https://www.vagrantup.com/downloads.html

Download and install.

Added plugin.

```shell
vagrant plugin install vagrant-disksize vagrant-hostsupdater vagrant-mutagen vagrant-docker-compose
```

Install mutagen

https://mutagen.io/documentation/introduction/installation

```shell
# Install the stable version of Mutagen.
brew install mutagen-io/mutagen/mutagen
```

### 3. Create  `Vagrantfile` for vagrant
Create following `Vagrantfile` .


```ruby
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

```

* `config.vm.network 'private_network', ip: '192.168.33.10'`
* `config.vm.hostname = 'my-app'`

Set guest OS private IP address.

Referenced by `mutagen.yml` using hostname 'my-app', 'my-app' is able to be changed. 


* `rsync__exclude: ['.git/', 'node_modules/', 'log/', 'tmp/']`

Excluded folders like `vendors/` .

* `config.vm.provision 'shell', inline: <<-SHELL`

Installed at `vagrant up` .

```ruby
config.mutagen.orchestrate = true
config.vm.provision :docker
config.vm.provision :docker_compose
```

Installed each applications

### 4. Create `mutagen.yml` for mutagen


```yaml
sync:
  defaults:
    mode: "two-way-resolved"
    ignore:
      vcs: false
      paths:
        - "/node_modules"
        - "/log"
        - "/tmp"
  app:
    alpha: "./"
    beta: "my-app:/home/vagrant/vagrantrailstest"
```

```yaml
paths:
    - "/node_modules"
    - "/log"
    - "/tmp"
```

Excluded in sync.

Should exclude SQL database data directory.

* `beta: "my-app:/home/vagrant/vagrantrailstest"`

Matching with repository name is better.

`my-app` should consist with `config.vm.hostname` in `Vagrantfile` .


### 5. Start vagrant

```shell
vagrant up
```

### 6. ssh to vagrant

```
vagrant ssh
```
### 7. Common set up

```
cd vagrantrailstest
```

```shell
docker-compose exec web build
docker-compose exec web up -d
docker-compose exec web bin/setup 
```

Following set up, access to `http://192.168.33.10:3000/` (see `config.vm.network` )


# Measurement

* measurement of start up rails.

```SHELL
$ time docker-compose exec web rails runner "puts Rails.env"
development
docker-compose exec web rails runner "puts Rails.env"  0.44s user 0.21s system 3% cpu 16.383 total
```
