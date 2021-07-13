# Prepare the environment
# First, update the repositories
sudo apt update

#  Then, install essential KVM packages with the following command
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Only members of the libvirt and kvm user groups can run virtual machines. Add a user to the libvirt
sudo adduser [username] libvirt

# the same for the kvm group
sudo adduser [username] kvm

# Confirm the installation was successful by using the virsh comman
virsh list --all

sudo systemctl enable --now libvirtd

sudo apt install virt-manager




