#!/bin/bash

# List of VMs to backup
VMS=("k8s-master1" "k8s-master2" "k8s-master2" "k8s-worker1" "k8s-worker2" "k8s-worker3")

# Function to take backup of a VM
add_docker_key() {
  VM_NAME=$1
  # Add key
  ssh -tt ubuntu@${VM_NAME} "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
}

# Function to take backup of a VM
add_k8s_key() {
  VM_NAME=$1
  # Add key
  ssh -tt ubuntu@${VM_NAME} "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/k8s.gpg"
}

# Backup each VM
for VM in "${VMS[@]}"; do

  # Add docker key
  add_docker_key $VM

  # Add K8s Kyes
  add_k8s_key $VM
done

