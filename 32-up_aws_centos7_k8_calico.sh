#!/usr/bin/env zsh
start_g=`date +%s`
start_1=`date +%s`

export ANSIBLE_CONFIG=./ansible.cfg

ansible-playbook ./ansible_scripts/createVM.yml --extra-vars "vm_env=aws_sandbox_centos" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,amzn2,flannel

end_1=`date +%s`
start_2=`date +%s`

ansible-playbook ./ansible_scripts/installVM.yml --extra-vars "vm_env=aws_sandbox_centos" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,amzn2,flannel

end_2=`date +%s`
start_3=`date +%s`

ansible-playbook ./ansible_scripts/installCluster.yml --extra-vars "vm_env=aws_sandbox_centos" --vault-password-file ./ansible_scripts/vars/vault.aws_sandbox.pass --skip-tags=virtualbox,swarm,amzn2,flannel

end_3=`date +%s`
end_g=`date +%s`

runtime_g=$((end_g-start_g))
runtimeh_g=$((runtime_g/60))
runtimes_g=$((runtime_g-runtimeh_g*60))

runtime_1=$((end_1-start_1))
runtimeh_1=$((runtime_1/60))
runtimes_1=$((runtime_1-runtimeh_1*60))

runtime_2=$((end_2-start_2))
runtimeh_2=$((runtime_2/60))
runtimes_2=$((runtime_2-runtimeh_2*60))

runtime_3=$((end_3-start_3))
runtimeh_3=$((runtime_3/60))
runtimes_3=$((runtime_3-runtimeh_3*60))

echo "total runtime was : $runtimeh_g minutes $runtimes_g seconds"
echo "   VM creation         runtime was : $runtimeh_1 minutes $runtimes_1 seconds"
echo "   VM installation     runtime was : $runtimeh_2 minutes $runtimes_2 seconds"
echo "   VM cluster creation runtime was : $runtimeh_3 minutes $runtimes_3 seconds"
echo ""
