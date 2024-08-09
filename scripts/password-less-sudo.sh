#!/bin/bash

# Enable password less sudo
ssh -tt ubuntu@192.168.2.21 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
ssh -tt ubuntu@192.168.2.22 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
ssh -tt ubuntu@192.168.2.31 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
ssh -tt ubuntu@192.168.2.32 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
ssh -tt ubuntu@192.168.2.33 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
ssh -tt ubuntu@192.168.2.41 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
ssh -tt ubuntu@192.168.2.42 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"
ssh -tt ubuntu@192.168.2.43 "sudo sed -i '/^ubuntu\s\+ALL=(ALL)\s\+NOPASSWD:ALL/d' /etc/sudoers && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers"

