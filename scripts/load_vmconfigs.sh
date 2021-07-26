#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


COPY_CURRENT_CONFIGS()
{
    sudo cp /etc/libvirt/qemu/ubuntu_nuksm_1.xml ${CURRENT_DIR}/../resources/vm_xmls/dump/ubuntu_nuksm_1.xml
    sudo cp /etc/libvirt/qemu/ubuntu_nuksm_2.xml ${CURRENT_DIR}/../resources/vm_xmls/dump/ubuntu_nuksm_2.xml
}

LOAD_NEW_CONFIGS()
{
   sudo cp ${CURRENT_DIR}/../resources/vm_xmls/live/ubuntu_nuksm_1.xml /etc/libvirt/qemu/ubuntu_nuksm_1.xml
   sudo cp ${CURRENT_DIR}/../resources/vm_xmls/live/ubuntu_nuksm_2.xml /etc/libvirt/qemu/ubuntu_nuksm_2.xml
}

mkdir -p ${CURRENT_DIR}/../resources/vm_xmls/dump/
COPY_CURRENT_CONFIGS
LOAD_NEW_CONFIGS
