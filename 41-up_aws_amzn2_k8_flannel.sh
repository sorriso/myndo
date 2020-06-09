#!/usr/bin/env zsh
start_g=`date +%s`
start_1=`date +%s`

export ANSIBLE_CONFIG=./ansible.cfg

ansible-playbook ./ansible_scripts/createVM.yml --extra-vars "vm_env=aws_sandbox_amzn2" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,k8,centos,flannel

end_1=`date +%s`
start_2=`date +%s`

ansible-playbook ./ansible_scripts/installVM.yml --extra-vars "vm_env=aws_sandbox_amzn2" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,centos,calico

end_2=`date +%s`
start_3=`date +%s`

ansible-playbook ./ansible_scripts/installCluster.yml --extra-vars "vm_env=aws_sandbox_amzn2" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,centos,calico

end_3=`date +%s`
end_g=`date +%s`

runtime_g=$((end_g-start_g))
runtimeh_g=$((runtime/60))
runtimes_g=$((runtime-runtimeh*60))

runtime_1=$((end_g-start_g))
runtimeh_1=$((runtime/60))
runtimes_1=$((runtime-runtimeh*60))

runtime_2=$((end_g-start_g))
runtimeh_2=$((runtime/60))
runtimes_2=$((runtime-runtimeh*60))

runtime_3=$((end_g-start_g))
runtimeh_3=$((runtime/60))
runtimes_3=$((runtime-runtimeh*60))

echo "total runtime was : $runtimeh_g minutes $runtimes_g seconds"
echo "   VM creation         runtime was : $runtimeh_1 minutes $runtimes_1 seconds"
echo "   VM installation     runtime was : $runtimeh_2 minutes $runtimes_2 seconds"
echo "   VM cluster creation runtime was : $runtimeh_3 minutes $runtimes_3 seconds"
echo ""
