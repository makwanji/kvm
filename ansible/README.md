# To Manage GuestVM

## Push ssh key to all vm

```bash
# 0. run below scripts
# 0.1 `scripts/push-ssh-key.sh`
# 0.2 `scripts/password-less-sudo.sh`

# 1. Ping all vm
ansible-playbook ping.yml

# 3. update timezone
ansible-playbook set_timezone.yml
```