#!/usr/bin/env zsh

export ANSIBLE_CONFIG=./ansible.cfg
ansible-playbook ./ansible_scripts/createVM.yml --extra-vars "vm_env=local_virtualbox" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=aws,k8,amzn2,flannel,calico
