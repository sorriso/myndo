#!/usr/bin/env zsh

export ANSIBLE_CONFIG=./ansible.cfg
ansible-playbook ./ansible_scripts/createVM.yml --extra-vars "vm_env=aws_sandbox" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,amzn2,flannel
ansible-playbook ./ansible_scripts/installVM.yml --extra-vars "vm_env=aws_sandbox" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,amzn2,flannel
ansible-playbook ./ansible_scripts/installCluster.yml --extra-vars "vm_env=aws_sandbox" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,amzn2,flannel
