Main repository for the Literary Worlds update project.

## Vagrant Test Environment

Install [vagrant](https://www.vagrantup.com/) and [virtual box](https://www.virtualbox.org/).

* Run `vagrant up`

That command will download the latest version of Ubuntu 14 and load a virtual machine with the LitWorlds project for testing.

* Configuration for the Virtual Machine is located in the **Vagrantfile**
* Initial virtual machine setup is located in **setup/bootstrap.sh**

The virtual machine has port 80 forwarded to host machine's port 8000 and port 8080 forwarded to 8080 (All forwarded ports can be changed in the Vagrantfile)

Once the machine is setup navigate to `localhost:8000` in the host's browser.

### Vagrant Commands ###
* `vagrant halt` - shuts down the VM
* `vagrant ssh` - SSH into the VM and give you access to a shell
* `vagrant provision` - reruns the *bootstrap.sh* setup file (useful if deployment fails on vagrant up)

Full list of vagrant commands can be found at [VagrantDocs](https://docs.vagrantup.com/v2/cli/index.html)