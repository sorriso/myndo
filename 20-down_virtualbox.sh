#!/usr/bin/env zsh

# https://dev.to/malwarebo/how-to-set-python3-as-a-default-python-version-on-mac-4jjf
# https://docs.ansible.com/ansible/latest/reference_appendices/interpreter_discovery.html
start_g=`date +%s`
start_1=`date +%s`

export ANSIBLE_CONFIG=./ansible.cfg

ansible-playbook ./ansible_scripts/deleteVM.yml --extra-vars "vm_env=local_virtualbox" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=aws,amzn2

end=`date +%s`

runtime=$((end-start))
runtimeh=$((runtime/60))
runtimes=$((runtime-runtimeh*60))

echo "Runtime was : $runtimeh minutes $runtimes seconds"
echo ""
