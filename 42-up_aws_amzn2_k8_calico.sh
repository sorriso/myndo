#!/usr/bin/env zsh
start=`date +%s`

export ANSIBLE_CONFIG=./ansible.cfg
ansible-playbook ./ansible_scripts/createVM.yml --extra-vars "vm_env=aws_sandbox_amzn2" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,centos,flannel
ansible-playbook ./ansible_scripts/installVM.yml --extra-vars "vm_env=aws_sandbox_amzn2" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,centos,flannel
ansible-playbook ./ansible_scripts/installCluster.yml --extra-vars "vm_env=aws_sandbox_amzn2" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,centos,flannel

end=`date +%s`

runtime=$((end-start))
runtimeh=$((runtime/60))
runtimes=$((runtime-runtimeh*60))

echo "Runtime was : $runtimeh minutes $runtimes seconds"
echo ""
