# KVM Installation Steps on Ubuntu 24.04 LTS



In this tutorial, we will cover how to install KVM (Kernel-based Virtual Machine) on an Ubuntu 24.04 LTS system and demonstrate creating a virtual machine using the virt-manager application.

---

#### 1. Update the Apt Repository Packages Index
Open a terminal and run:
```sh
sudo apt update
```

#### 2. Check if Virtualization is Enabled
To check if your CPU supports hardware virtualization, run:
```sh
egrep -c '(vmx|svm)' /proc/cpuinfo
```
If the output is 0, your CPU does not support hardware virtualization; if it is 1 or more, it does.

Install the cpu-checker package:
```sh
sudo apt install -y cpu-checker
```

Another way to check if KVM virtualization is enabled:
```sh
kvm-ok
```

#### 3. Install KVM on Ubuntu 24.04
Run the following command to install KVM and necessary packages:
```sh
sudo apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
```

#### 4. Enable and Start the Virtualization Daemon
Enable and start the libvirt daemon:
```sh
sudo systemctl enable --now libvirtd
sudo systemctl start libvirtd
```

Check if the virtualization daemon is running:
```sh
sudo systemctl status libvirtd
```

#### 5. Add Your Local User to the KVM and Libvirt Groups
Add your user to the kvm and libvirt groups:
```sh
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
```

#### 6. Create a Network Bridge using Netplan
Create a netplan configuration file with the following content:
```sh
sudo vi /etc/netplan/01-netcfg.yaml
```
Add the following configuration:
```yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp0s31f6:
      dhcp4: false
      dhcp6: false

  bridges:
    br0:
      interfaces: [enp0s31f6]
      dhcp4: false
      addresses: [192.168.2.141/24]

      routes:
        - to: default
          via: 192.168.2.1
          metric: 100
      nameservers:
        addresses: [8.8.8.8]
```
Save and close the file.

Change the file permissions:
```sh
sudo chmod 600 /etc/netplan/*.yaml
```

Apply the network changes:
```sh
sudo netplan apply
```

#### 7. Launch KVM Virt-Manager and Create Virtual Machines
Open Virt-Manager from the application menu or run:
```sh
virt-manager
```




# Manage VM's

## Stop and start vm

```bash
# List vm
virsh list --all

# stop vm
virsh shutdown ubuntu24.04

# start vm
virsh start ubuntu24.04
```

## snapshot

### Backup

```bash
export VM_NAME="ubuntu24.04"
export SNAPSHOT_NAME="ubuntu24.04-after-networkfix-1"
# stop vm
virsh shutdown ${VM_NAME}

# Snapshoot
virsh snapshot-create-as --domain ${VM_NAME} --name ${SNAPSHOT_NAME}

# List snapshoot
virsh snapshot-list --domain ${VM_NAME}

# To see detailed snapshot info for a domain
virsh snapshot-info --domain ${VM_NAME} --snapshotname ${SNAPSHOT_NAME}

# Delete snapshoot
virsh snapshot-delete --domain ${VM_NAME} --snapshotname ${SNAPSHOT_NAME}

## Only Disk snapshoot
virsh snapshot-create-as --domain ${VM_NAME} --name ${SNAPSHOT_NAME} --disk-only

## command help
virsh help snapshot-create-as

```


### To revert a domain to a snapshot

```bash
# setup vars
export VM_NAME="ubuntu24.04"
export SNAPSHOT_NAME="ubuntu24.04-after-install-1"

# Shutdown
virsh shutdown --domain ${VM_NAME}
# Resoore
virsh snapshot-revert --domain ${VM_NAME} --snapshotname ${SNAPSHOT_NAME} --running
```


### Clone vm

```bash
# Get source disk file name
sudo virsh dumpxml ubuntu24.04 | grep '<source file='

# copy disk
sudo cp /var/lib/libvirt/images/ubuntu24.04.qcow2 /var/lib/libvirt/images/k8s-lb1.qcow2

# Save the source VM's XML configuration to a file
sudo virsh dumpxml ubuntu24.04 > /tmp/ubuntu24.04.xml

# Edit file
sudo vim /tmp/ubuntu24.04.xml
## 1. Change the <name> tag: Update it to the new VM’s name
## 2. Change the <uuid>: You can generate a new UUID using the uuidgen command.
## 3. Update the disk file path: Modify the path under the <disk> section to point to the new disk image.
## 4. Update the MAC address: Make sure the MAC address in the <interface> section is unique. You can generate a new MAC address or remove the current one (a new one will be assigned automatically when the VM starts).

# Define the New VM:
sudo virsh define /tmp/ubuntu24.04.xml

# Start the New VM:
sudo virsh start k8s-lb1
sudo virsh list --all

# Update Hostname

sudo virsh clone --original ubuntu24.04 --name k8s-lb1 --file /var/lib/libvirt/images/k8s-master1.qcow2
sudo virsh clone --original <source-vm-name> --name <new-vm-name> --file /var/lib/libvirt/images/<new-vm-name>.qcow2

sudo virsh clone --original ubuntu24.04 --name k8s-lb2 --file /var/lib/libvirt/images/k8s-master1.qcow2
sudo virsh clone --original ubuntu24.04 --name k8s-master1 --file /var/lib/libvirt/images/k8s-master1.qcow2
sudo virsh clone --original ubuntu24.04 --name k8s-master2 --file /var/lib/libvirt/images/k8s-master1.qcow2
sudo virsh clone --original ubuntu24.04 --name k8s-master3 --file /var/lib/libvirt/images/k8s-master1.qcow2
sudo virsh clone --original ubuntu24.04 --name k8s-worker1 --file /var/lib/libvirt/images/k8s-master1.qcow2
sudo virsh clone --original ubuntu24.04 --name k8s-worker2 --file /var/lib/libvirt/images/k8s-master1.qcow2
sudo virsh clone --original ubuntu24.04 --name k8s-worker3 --file /var/lib/libvirt/images/k8s-master1.qcow2
```
