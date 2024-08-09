#!/bin/bash
## "This script will shutdown all the domain runnig under kvm and take snapshoot backup of it."

# Define the directory where backups will be stored
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGFILE="/home/ubuntu/vm-backup/log/vm_backup_$TIMESTAMP.log"

# List of VMs to backup
VMS=("k8s-lb1" "k8s-lb2" "k8s-master1" "k8s-master2" "k8s-master2" "k8s-worker1" "k8s-worker2" "k8s-worker3")
# VMS=("k8s-lb1")

# Function to take backup of a VM
backup_vm() {
  VM_NAME=$1
  SNAPSHOT_NAME="${VM_NAME}_${TIMESTAMP}"

  echo "Starting backup for $VM_NAME..." | tee -a $LOGFILE

  # Suspend the VM to ensure consistency during snapshot
  virsh suspend $VM_NAME
  if [ $? -ne 0 ]; then
    echo "Failed to suspend $VM_NAME" | tee -a $LOGFILE
    return 1
  fi

  # Take a snapshot of the VM
  virsh snapshot-create-as --domain $VM_NAME --name $SNAPSHOT_NAME --description "Backup snapshot for $VM_NAME on $TIMESTAMP" --disk-only --atomic --no-metadata

  if [ $? -ne 0 ]; then
    echo "Failed to create snapshot for $VM_NAME" | tee -a $LOGFILE
    virsh resume $VM_NAME
    return 1
  fi

  # Resume the VM after snapshot
  virsh resume $VM_NAME
  if [ $? -ne 0 ]; then
    echo "Failed to resume $VM_NAME" | tee -a $LOGFILE
    return 1
  fi

  echo "Backup completed for $VM_NAME. Snapshot $SNAPSHOT_NAME created." | tee -a $LOGFILE
}

# Backup each VM
for VM in "${VMS[@]}"; do
  backup_vm $VM
done

echo "All backups completed. Logs are available at $LOGFILE"
