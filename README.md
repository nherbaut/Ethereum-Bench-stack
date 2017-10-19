# prerequisites 

```
$ sudo apt-get install vagrant nfs*
```

# provision VM with vagrant

```
$ vagrant up
```

this will create between 1 and n VMs (see the ./vagrant/config.yaml to specify how many VM you need).

In the configuration file, you can choose which hypervisor you target (virtualbox or KVM for the moment). You will need to install the hypervisor on the host machine such as

```
$ apt-get install virtualbox
```

or 
```
$ apt-get install linux-kvm
```

# log in any vm

```
$ vagrant ssh vm1
```

# run salt 

```
$ salt "*" test.ping
```

