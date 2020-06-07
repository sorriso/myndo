#!/usr/bin/env zsh

# https://dev.to/malwarebo/how-to-set-python3-as-a-default-python-version-on-mac-4jjf
# https://docs.ansible.com/ansible/latest/reference_appendices/interpreter_discovery.html

export ANSIBLE_CONFIG=./ansible.cfg
ansible-playbook ./ansible_scripts/deleteVM.yml --extra-vars "vm_env=local_virtualbox" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=aws,amzn2
