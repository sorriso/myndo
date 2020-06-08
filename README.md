# this is an proof of concept tool, backup your all data before using it, I will be responsible of any issue due to its use.

# Purpose
A tool (for unix environment) aiming to:
* automate cluster installation hosting micro service (i.e. containers)
* explore cluster configuration & use.
* provide "sandboxing" capability to allow focusing on micro service / business usage -> do NOT used it "as is" for production (i.e harden / secure it before)


# Technology
This solution is based on opens source and/of aws free-tier solution:
 * ansible for automation installation
 * virtualbox for local vm hosting
 * docker for micro services (i.e. container) virtualization
 * swarm (from docker) for a simple & quick clustering solution
 * kubernetes (k8) for more a complete clustering solution
 * centos 7 (as centos 8 is not available as free-tier ami yet)
 * aws free-tier for cloud vm hosting (centos 7 & amazon linux 2)


# summary
| vm provider   | operating system   | cluster solution     | network type   | available  | create vm  | install vm  | create cluster |
| ------------- | ------------------ | -------------------- | -------------- | ---------- | ---------- | ----------- | -------------- |
| virtualbox    | centos 7           | swarm                | default        |  ![#f03c15](https://placehold.it/15/c5f015/000000?text=+)      | ok         | ok          | ok             |
| virtualbox    | centos 7           | kubernetes (k8)      | calico         |  ![#f03c15](https://placehold.it/15/f03c15/000000?text=+)      | ok         | ok          | nok            |
| virtualbox    | centos 7           | kubernetes (k8)      | flannel        |  ![#f03c15](https://placehold.it/15/f03c15/000000?text=+)      | ok         | ok          | nok            |
| aws           | centos 7 ami       | swarm                | default        |  ![#c5f015](https://placehold.it/15/c5f015/000000?text=+)      | ok         | ok          | ok             |
| aws           | centos 7 ami       | kubernetes (k8)      | calico         |  ![#f03c15](https://placehold.it/15/f03c15/000000?text=+)      | ok         | ok          | nok            |
| aws           | centos 7 ami       | kubernetes (k8)      | flannel        |  ![#f03c15](https://placehold.it/15/f03c15/000000?text=+)      | ok         | ok          | nok            |
| aws           | amazon linux 2 ami | swarm                | default        |  ![#f03c15](https://placehold.it/15/f03c15/000000?text=+)      | nok        | nok         | nok            |
| aws           | amazon linux 2 ami | kubernetes (k8)      | calico         |  ![#f03c15](https://placehold.it/15/f03c15/000000?text=+)      | nok        | nok         | nok            |
| aws           | amazon linux 2 ami | kubernetes (k8)      | flannel        |  ![#f03c15](https://placehold.it/15/f03c15/000000?text=+)      | nok        | nok         | nok            |


# Operating system used on vm
| vm provider | operating system                                        | user           | pwd                                                        |
| ----------- | ------------------------------------------------------- | -------------- | ---------------------------------------------------------- |
| virtualbox  | centos 7 (tested with CentOS-7-x86_64-Minimal-2003.iso) | ansible        | centos                                                     |
| aws         | centos 7 ami   (free tier)                              | ansible        | N/A ssh key used                                           |
| aws         | amazon linux 2 (free tier)                              | ec2-user       | N/A ssh key used                                           |


# Micro services file system
Micro services (i.e container) are sharing data (i.e configuration & data files) within the cluster thanks to glusterfs solution
the minimum size of the cluster is 1 master and 2 workers (default configuration)


# Prerequisites on local host
- docker installed & running (tested with v19.03.8)
- virtualbox installed (tested with 6.1.8 r137981 (Qt5.6.3))
- ansible installed (tested with v2.9.9)
- an aws account (tested on an account having root privilege)


# Configuration of vm
- all configuration files are stored in <myndo_root>/ansible_scripts/vars
- during vm's installation:
  - the latest version are used, except for docker, docker-compose, glusterfs and k8 (version fixed in configuration files)
  - regarding amazon ami, the latest version that is available in the "aws region" is used at vm creation.


# Preparation for virtualbox use:
  - vm iso template preparaiotn
    - download centos 7 installation iso
    - download VBoxGuestAdditions_x.y.z.iso from virtualbox web site
    - create a new brand vm & link the "centos 7 installation iso" to its cdrom drive
    - start vm & proceed to centos 7 installation
      - set root password as "centos" (you ill need to click twice on the validation button)
      - once the button "restart" available when the instalatino is done,
        - shutdown the vm,
        - replace the "centos 7 installation iso" by the "VBoxGuestAdditions_x.y.z.iso" to its cdrom drive
        - configure network as bridge in virtualbox's vm configuration panel
        - restart the vm
    - once restarted, login as root, and enable ip / networking capability:
      - vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
      - set "onboot" to "yes"
      - restart the vm
    - login as root and get vm ip
      - ip addr show
    - connection via ssh/terminal and install prerequisites for VBoxGuestAdditions by running:
        - ssh root@<ip found>
        - once logged:
          - rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
          - yum upgrade -y
          - yum install -y perl gcc dkms kernel-devel kernel-headers make bzip2 cloud-init
          - reboot
    - re-connect as root, and install VBoxGuestAdditions by running:
        - ls -l /usr/src/kernels/$(uname -r)
        - should be not empty
        - mount /dev/cdrom /mnt
        - cd /mnt
        - ./VBoxLinuxAdditions.run
        - reboot
    - shutdown it vm
    - export it as "CentOS_7_Minimal_baseline.ova"
    - copy or move it to <myndo_root>/ansible_scripts/vars
  - prerequisite for ansible ssh connection
    - ensure the files "id_rsa" and "id_rsa.pub" exist in "~/.ssh" folder
    - if not, create them:
    - mkdir -p ~/.ssh
    - cd ~/.ssh
    - ssh-keygen -t rsa -b 4096 -f ./id_rsa


# Preparation for aws use:
* prerequisite for ansible ssh connection
  - go to your aws console management
  - generate an ssh key & name it as "sandbox_key.pem"
  - download it
  - move it in <myndo_root>/ansible_scripts/vars/sandbox_key.pem
# create an ansible vault to store aws credentials:
  - cd <myndo_root>/ansible_scripts/vars
  - openssl genrsa -out ./vault.aws_sandbox.pass 2048
  - ansible-vault create ./credentials.aws_sandbox.vault.yml --vault-password-file ./vault.aws_sandbox.pass
  - ansible-vault edit ./credentials.aws_sandbox.vault.yml --vault-password-file ./vault.aws_sandbox.pass
  - add our credential (from aws management console)
    - aws_access_key: XXXXXXXXXXXXX
    - aws_secret_key: YYYYYYYYYYYYYYYYYYYYYYYYYYYYYY

# Accessing to vm via ssh
* virtualbox
  - CentOS
    - ssh ansible@<ip from ansible inventory file> -i  ~/.ssh/id_rsa
* aws
  - get <vm dns name> from aws administration console / ec2
  - ssh centos@192.168.0.27 -i /Users/olivier/.ssh/id_rsa
   - CentOS
     - ssh centos@<vm dns name> -i  <myndo_root>/ansible_scripts/vars/sandbox_key.pem
   - amazon linux 2:
     - ssh ec2-user@<vm dns name> -i  <myndo_root>/ansible_scripts/vars/sandbox_key.pem

# Using micro services through the created cluster
* swarm
  - get swarm node status
    login via ssh to a swarm master node
    execute: sudo docker node ls
  - get swarm running service list
    login via ssh to a swarm master node
    execute: sudo docker node ps
