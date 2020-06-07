#!/usr/bin/env zsh

# https://dev.to/malwarebo/how-to-set-python3-as-a-default-python-version-on-mac-4jjf
# https://docs.ansible.com/ansible/latest/reference_appendices/interpreter_discovery.html

export ANSIBLE_CONFIG=../ansible.cfg
ansible-playbook ../ansible_scripts/xxx.yml --extra-vars "vm_env=aws_sandbox" --vault-password-file ../ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,k8,amzn2,flannel,calico
