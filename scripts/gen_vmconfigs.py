#!/usr/bin/python3

import xml.etree.ElementTree as ET
import os
import sys
import multiprocessing
import subprocess
import psutil


root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

nr_cpus = multiprocessing.cpu_count()
nr_sockets =  int(subprocess.check_output('cat /proc/cpuinfo | grep "physical id" \
                | sort -u | wc -l', shell=True))
# --- XML helper
def remove_tag(parent, child):
    for element in list(parent):
        if element.tag == child:
            parent.remove(element)

# --- XML helper
def new_element(parent, tag, text):
    attrib = {}
    element = parent.makeelement(tag, attrib)
    parent.append(element)
    element.text = text
    return element


# return the number of CPUs from a single socket
def get_vcpu_count(config):
	return min(4, int(nr_cpus/nr_sockets))

# return memory size of a single socket
def get_memory_size(config):
    mem = int(psutil.virtual_memory().total)/1024 # --- converted to KB
    return int(min(int((mem * 0.90) / nr_sockets), 62914560)) # --- min(available, 60GB)

# Bind vCPUs 1:1: to pCPUs
def add_vcpu_numa_tune(config, main, child, node, head):
    nr_cpus = int(child.text)
    pos = list(main).index(child)
    remove_tag(main, 'cputune')
    new = ET.Element('cputune')
    main.insert(pos + 1, new)
    cpus = [i for i in range(nr_cpus)]
    cmd = 'numactl -H | grep "node %d cpus" | cut -d " " -f4-' %node
    out = subprocess.check_output(cmd, shell  = True)
    out = str(out, 'utf-8')
    cpus = out.split()
    nr_pcpus = len(cpus)
    for i in range(nr_cpus):
        newtag = ET.SubElement(new, 'vcpupin')
        newtag.set('cpuset', str(cpus[i]))
        newtag.set('vcpu', str(i))
        # --- first or last cpus of the node
        if not head:
            newtag.set('cpuset', str(cpus[nr_pcpus - i - 1]))

    remove_tag(main, 'numatune')

def rewrite_interface(config, element):
    element.set('type', 'network')
    mac = '52:54:00:78:47:9d'
    if config == 'ubuntu_nuksm_2':
        mac = '52:54:00:91:ef:df'
    for child in element:
        if child.tag == 'mac':
            child.set('address', mac)
        if child.tag == 'source':
            child.set('network', 'network-01')


# -- the following tags are important
# 1. os: update to booth VM with mitosis kernel
# 2. vcpu: number of vcpus for the VM
# 3. memory: amount of memory for the VM -- in KiB
# 4. vcputune: add after the vcpu tag, bind with a 1:1 mapping
# 5. numa: add inside cpu tag to mirror host NUMA topology inside guest
def rewrite_config(config, node, head):
    vmconfigs = os.path.join(root, 'resources/vm_xmls/live')
    src = os.path.join(vmconfigs, config + '.xml')
    tree = ET.parse(src)
    main = tree.getroot()
    for child in main:
        if child.tag == 'vcpu':
            child.text = str(get_vcpu_count(config))
            if child.get('cpuset') is not None:
                cpuset = '%d-%d' %(0, get_vcpu_count(config) - 1)
                child.set('cpuset', cpuset)
            add_vcpu_numa_tune(config, main, child, node, head)
        if child.tag == 'memory' or child.tag == 'currentMemory':
            child.text = str(get_memory_size(config))
        if child.tag == 'devices':
            for subchild in child:
                if subchild.tag == 'interface':
                    rewrite_interface(config, subchild)

    tree.write(src)

def dump_vm_config(vm):
    #print('dumping template XML from %s\'s current config...' %vm)
    cmd = 'virsh dumpxml %s' %vm
    dst = os.path.join(root, 'resources/vm_xmls/live')
    if not os.path.exists(dst):
        os.makedirs(dst)
    dst = os.path.join(dst, vm + '.xml')
    cmd += '> %s' %dst
    os.system(cmd)

if __name__ == '__main__':
    vm0_node = 0
    vm1_node = 1
    head = True
    if len(sys.argv) == 3:
        vm0_node = int(sys.argv[1])
        vm1_node = int(sys.argv[2])
        if vm0_node == vm1_node:
            head = False
    else:
        print('Supply 2 nodes where vCPUs are to be pinned...')
        sys.exit(0)

    parent_vm = 'ubuntu_nuksm_1'
    configs = ['ubuntu_nuksm_1', 'ubuntu_nuksm_2']

    #dump_vm_config_template(parent_vm, configs)
    dump_vm_config('ubuntu_nuksm_1')
    dump_vm_config('ubuntu_nuksm_2')

    rewrite_config('ubuntu_nuksm_1', vm0_node, True)
    rewrite_config('ubuntu_nuksm_2', vm1_node, head)

    # --- prettify XML files
    for config in configs:
        vmconfigs = os.path.join(root, 'resources/vm_xmls/live')
        src = os.path.join(vmconfigs, config + '.xml')
        cmd = 'xmllint --format %s' %src
        tmp = 'tmp.xml'
        cmd += ' > %s' %tmp
        os.system(cmd)
        os.rename(tmp, src)
