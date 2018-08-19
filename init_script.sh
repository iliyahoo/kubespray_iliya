#!/bin/bash

src_key=$1
ssh_dir="/home/vagrant/.ssh"

# disable swap
swapoff -a
sed -i "/\bswap\b/d" /etc/fstab

# add custom SSH public key
if [[ ! -f "${ssh_dir}/injected" ]] ; then
  cat "${src_key}/id_rsa.pub" >> ${ssh_dir}/authorized_keys \
  && touch "${ssh_dir}/injected"
fi
