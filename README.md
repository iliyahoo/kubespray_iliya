![Kubernetes Logo](https://raw.githubusercontent.com/kubernetes-incubator/kubespray/master/docs/img/kubernetes-logo.png)

Deploy a Production Ready Kubernetes Cluster
============================================

If you have questions, join us on the [kubernetes slack](https://kubernetes.slack.com), channel **\#kubespray**.

-   Can be deployed on **AWS, GCE, Azure, OpenStack, vSphere or Baremetal**
-   **Highly available** cluster
-   **Composable** (Choice of the network plugin for instance)
-   Supports most popular **Linux distributions**
-   **Continuous integration tests**

Quick Start
-----------

To deploy the cluster you can use :

### Ansible

    # Install dependencies from ``requirements.txt``
    sudo pip install -r requirements.txt

    # Copy ``inventory/sample`` as ``inventory/mycluster``
    cp -rfp inventory/sample inventory/mycluster

    # Update Ansible inventory file with inventory builder
    declare -a IPS=($(vagrant ssh-config | awk '/HostName / {print $2}'))
    CONFIG_FILE=inventory/mycluster/hosts.ini python3 contrib/inventory_builder/inventory.py ${IPS[@]}

    # Review and change parameters under ``inventory/mycluster/group_vars``
    cat inventory/mycluster/group_vars/all.yml
    cat inventory/mycluster/group_vars/k8s-cluster.yml

    # Deploy Kubespray with Ansible Playbook
    ansible-playbook -i inventory/mycluster/hosts.ini cluster.yml

### Vagrant

For Vagrant we need to install python dependencies for provisioning tasks.
Check if Python and pip are installed:

    python -V && pip -V

If this returns the version of the software, you're good to go. If not, download and install Python from here <https://www.python.org/downloads/source/>
Install the necessary requirements

    sudo pip install -r requirements.txt
    vagrant up

Documents
---------

-   [Requirements](#requirements)
-   [Kubespray vs ...](docs/comparisons.md)
-   [Getting started](docs/getting-started.md)
-   [Ansible inventory and tags](docs/ansible.md)
-   [Integration with existing ansible repo](docs/integration.md)
-   [Deployment data variables](docs/vars.md)
-   [DNS stack](docs/dns-stack.md)
-   [HA mode](docs/ha-mode.md)
-   [Network plugins](#network-plugins)
-   [Vagrant install](docs/vagrant.md)
-   [CoreOS bootstrap](docs/coreos.md)
-   [Debian Jessie setup](docs/debian.md)
-   [openSUSE setup](docs/opensuse.md)
-   [Downloaded artifacts](docs/downloads.md)
-   [Cloud providers](docs/cloud.md)
-   [OpenStack](docs/openstack.md)
-   [AWS](docs/aws.md)
-   [Azure](docs/azure.md)
-   [vSphere](docs/vsphere.md)
-   [Large deployments](docs/large-deployments.md)
-   [Upgrades basics](docs/upgrades.md)
-   [Roadmap](docs/roadmap.md)

Supported Linux Distributions
-----------------------------

-   **Container Linux by CoreOS**
-   **Debian** Jessie, Stretch, Wheezy
-   **Ubuntu** 16.04
-   **CentOS/RHEL** 7
-   **Fedora/CentOS** Atomic
-   **openSUSE** Leap 42.3/Tumbleweed

Note: Upstart/SysV init based OS types are not supported.

Supported Components
--------------------

-   Core
    -   [kubernetes](https://github.com/kubernetes/kubernetes) v1.11.2
    -   [etcd](https://github.com/coreos/etcd) v3.2.18
    -   [docker](https://www.docker.com/) v17.03 (see note)
    -   [rkt](https://github.com/rkt/rkt) v1.21.0 (see Note 2)
-   Network Plugin
    -   [calico](https://github.com/projectcalico/calico) v2.6.8
    -   [canal](https://github.com/projectcalico/canal) (given calico/flannel versions)
    -   [cilium](https://github.com/cilium/cilium) v1.1.2
    -   [contiv](https://github.com/contiv/install) v1.1.7
    -   [flanneld](https://github.com/coreos/flannel) v0.10.0
    -   [weave](https://github.com/weaveworks/weave) v2.4.0
-   Application
    -   [cephfs-provisioner](https://github.com/kubernetes-incubator/external-storage) v2.0.0-k8s1.11
    -   [cert-manager](https://github.com/jetstack/cert-manager) v0.4.1
    -   [ingress-nginx](https://github.com/kubernetes/ingress-nginx) v0.18.0

Note: kubernetes doesn't support newer docker versions. Among other things kubelet currently breaks on docker's non-standard version numbering (it no longer uses semantic versioning). To ensure auto-updates don't break your cluster look into e.g. yum versionlock plugin or apt pin).

Note 2: rkt support as docker alternative is limited to control plane (etcd and
kubelet). Docker is still used for Kubernetes cluster workloads and network
plugins' related OS services. Also note, only one of the supported network
plugins can be deployed for a given single cluster.

Requirements
------------

-   **Ansible v2.4 (or newer) and python-netaddr is installed on the machine
    that will run Ansible commands**
-   **Jinja 2.9 (or newer) is required to run the Ansible Playbooks**
-   The target servers must have **access to the Internet** in order to pull docker images.
-   The target servers are configured to allow **IPv4 forwarding**.
-   **Your ssh key must be copied** to all the servers part of your inventory.
-   The **firewalls are not managed**, you'll need to implement your own rules the way you used to.
    in order to avoid any issue during deployment you should disable your firewall.
-   If kubespray is ran from non-root user account, correct privilege escalation method
    should be configured in the target servers. Then the `ansible_become` flag
    or command parameters `--become or -b` should be specified.

Network Plugins
---------------

You can choose between 6 network plugins. (default: `calico`, except Vagrant uses `flannel`)

-   [flannel](docs/flannel.md): gre/vxlan (layer 2) networking.

-   [calico](docs/calico.md): bgp (layer 3) networking.

-   [canal](https://github.com/projectcalico/canal): a composition of calico and flannel plugins.

-   [cilium](http://docs.cilium.io/en/latest/): layer 3/4 networking (as well as layer 7 to protect and secure application protocols), supports dynamic insertion of BPF bytecode into the Linux kernel to implement security services, networking and visibility logic.

-   [contiv](docs/contiv.md): supports vlan, vxlan, bgp and Cisco SDN networking. This plugin is able to
    apply firewall policies, segregate containers in multiple network and bridging pods onto physical networks.

-   [weave](docs/weave.md): Weave is a lightweight container overlay network that doesn't require an external K/V database cluster.
    (Please refer to `weave` [troubleshooting documentation](http://docs.weave.works/weave/latest_release/troubleshooting.html)).

The choice is defined with the variable `kube_network_plugin`. There is also an
option to leverage built-in cloud provider networking instead.
See also [Network checker](docs/netcheck.md).

Community docs and resources
----------------------------

-   [kubernetes.io/docs/getting-started-guides/kubespray/](https://kubernetes.io/docs/getting-started-guides/kubespray/)
-   [kubespray, monitoring and logging](https://github.com/gregbkr/kubernetes-kargo-logging-monitoring) by @gregbkr
-   [Deploy Kubernetes w/ Ansible & Terraform](https://rsmitty.github.io/Terraform-Ansible-Kubernetes/) by @rsmitty
-   [Deploy a Kubernetes Cluster with Kubespray (video)](https://www.youtube.com/watch?v=N9q51JgbWu8)

Tools and projects on top of Kubespray
--------------------------------------

-   [Digital Rebar Provision](https://github.com/digitalrebar/provision/blob/master/doc/integrations/ansible.rst)
-   [Fuel-ccp-installer](https://github.com/openstack/fuel-ccp-installer)
-   [Terraform Contrib](https://github.com/kubernetes-incubator/kubespray/tree/master/contrib/terraform)

CI Tests
--------

[![Build graphs](https://gitlab.com/kubespray-ci/kubernetes-incubator__kubespray/badges/master/build.svg)](https://gitlab.com/kubespray-ci/kubernetes-incubator__kubespray/pipelines)

CI/end-to-end tests sponsored by Google (GCE)
See the [test matrix](docs/test_cases.md) for details.


# My custom installation instructions

[How to Install Kubernetes Cluster with Ansible based tool Kubespray](https://linoxide.com/containers/install-kubernetesk8s-cluster-ansible-based-tool-kubespray/)

[Vagrant with libvirt support installation](https://developer.fedoraproject.org/tools/vagrant/vagrant-libvirt.html)
```
sudo dnf install vagrant-libvirt
sudo dnf install @vagrant
# ??? gem install vagrant-libvirt
sudo dnf install libvirt-devel
CONFIGURE_ARGS='with-ldflags=-L/opt/vagrant/embedded/lib with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib' \
  GEM_HOME=~/.vagrant.d/gems GEM_PATH=$GEM_HOME:/opt/vagrant/embedded/gems PATH=/opt/vagrant/embedded/bin:$PATH \
  vagrant plugin install vagrant-libvirt
```

```
git clone https://github.com/kubespray/kubespray.git kubespray && cd kubespray
```

```
cat <<'EOF'> Vagrantfile
$box = "fedora/28-atomic-host"
$num_instances = 6
$vm_memory = 2048
$subnet = "172.17.17"
$shared_folders = {}
$kube_node_instances_with_disks = true
$kube_node_instances_with_disks_size = "20G"
$kube_node_instances_with_disks_number = 3

# Uniq disk UUID for libvirt
DISK_UUID = Time.now.utc.to_i

Vagrant.configure("2") do |config|
  # HostManager
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  # always use Vagrants insecure key
  config.ssh.insert_key = false
  config.vm.box = $box
  config.ssh.username = "vagrant"
  (1..$num_instances).each do |i|
    config.vm.define "node#{i}" do |config|
      config.vm.hostname = "node#{i}"

      $shared_folders.each do |src, dst|
        break if dst == "/vagrant"
        config.vm.synced_folder src, dst, type: "rsync", rsync__args: ['--verbose', '--archive', '--delete', '-z']
      end

     config.vm.provider :libvirt do |lv|
       lv.memory = $vm_memory
     end

      ip = "#{$subnet}.#{i+100}"
      config.vm.network "private_network", ip: ip

      # Disable swap for each vm
      config.vm.provision "shell",
        inline: "swapoff -a ; cat ~vagrant/sync/id_rsa.pub >> ~vagrant/.ssh/authorized_keys"

      if $kube_node_instances_with_disks
        # Libvirt
        driverletters = ('a'..'z').to_a
        config.vm.provider :libvirt do |lv|
          # always make /dev/sd{a/b/c} so that CI can ensure that
          # virtualbox and libvirt will have the same devices to use for OSDs
          (1..$kube_node_instances_with_disks_number).each do |d|
            lv.storage :file, :device => "hd#{driverletters[d]}", :path => "disk-#{i}-#{d}-#{DISK_UUID}.disk", :size => $kube_node_instances_with_disks_size, :bus => "ide"
          end
        end
      end
    end
  end
end
EOF
```

## Raise up KVM virtual machines
```
vagrant up --provision --provider libvirt
```

## use your SSH private key instead of Vagrant's
```
ln -s ~/.ssh/id_rsa.pub
```

## install Vagrant HostManager plugin to update hosts file
```
https://github.com/devopsgroup-io/vagrant-hostmanager
```

## Copy ``inventory/sample`` as ``inventory/mycluster``
```
cp -rfp inventory/sample inventory/mycluster
```
## Review and change parameters under ``inventory/mycluster/group_vars``
```
subl inventory/mycluster/group_vars/all.yml
subl inventory/mycluster/group_vars/k8s-cluster.yml
```
## Update Ansible inventory file with inventory builder
```
declare -a IPS=($(vagrant ssh-config | awk '/HostName / {print $2}'))
CONFIG_FILE=inventory/mycluster/hosts.ini python3 contrib/inventory_builder/inventory.py ${IPS[@]}
cp inventory/mycluster/hosts.ini inventory/inventory.cfg
```

### ajust hosts records like this:
```
subl inventory/inventory.cfg
node1    ansible_user=vagrant
```

```
cat <<EOF> ~/.kubespray.yml
kubespray_git_repo: "https://github.com/kubespray/kubespray.git"
kubespray_path: "/home/iliya/repos/kubespray"
loglevel: "info"
EOF
```

## Install dependencies from ``requirements.txt``
```
mkvirtualenv kubespray_virtenv
workon kubespray_virtenv
pip install kubespray
pip install -r requirements.txt
```

```
# kubespray deploy
vagrant up --provider=libvirt
ansible-playbook -i inventory/mycluster/vagrant_ansible_inventory cluster.yml --become # -l k8s-777
```
