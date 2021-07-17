import sys
import os
import subprocess
import time
import signal 

curr_file_dir_path=os.path.dirname(os.path.realpath(__file__))
sys.path.append(curr_file_dir_path + "/config/")
import config

def sigusr1_handler(a,b):
    exit(0)

signal.signal(signal.SIGUSR1 , sigusr1_handler);

f=open('pid_file');
pid = int(f.read());
argument = sys.argv[1]
if argument == "complete" :
    os.kill(pid , signal.SIGUSR1)
    time.sleep(100)
    os.kill(pid , signal.SIGUSR2)
elif argument == "access" :
    os.kill(pid , signal.SIGUSR2)
    while(1):
        continue
elif argument == "filldata" :
    os.kill(pid , signal.SIGUSR1);
    while(1):
        continue
