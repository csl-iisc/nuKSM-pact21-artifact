import math
import sys

if len(sys.argv) < 7:
    print("\nUsage:\npython parse_remote_local.py local1 local2 remote1 remote2 outputvm1 outputvm2\n")
    exit(1)

local_1=open(sys.argv[1])
local_2=open(sys.argv[2])
remote_1=open(sys.argv[3])
remote_2=open(sys.argv[4])

output_file_1=sys.argv[5]
output_file_2=sys.argv[6]

#local_1=open('/tmp/local_1')
#local_2=open('/tmp/local_2')
#remote_1=open('/tmp/remote_1')
#remote_2=open('/tmp/remote_2')


local_1_lines = local_1.readlines()
local_1_arr = {}
for x in local_1_lines:
    x_arr = x.strip().split(",")
    sec = math.floor(float(x_arr[0]))
    local_loads = int(x_arr[1].replace(',', ''))
    local_1_arr[sec] = local_loads

remote_1_lines = remote_1.readlines()
remote_1_arr = {}
for x in remote_1_lines:
    x_arr = x.strip().split(",")
    sec = math.floor(float(x_arr[0]))
    remote_loads = int(x_arr[1].replace(',', ''))
    remote_1_arr[sec] = remote_loads

#print(local_1_arr)
#print(remote_1_arr)

local_2_lines = local_2.readlines()
local_2_arr = {}
for x in local_2_lines:
    x_arr = x.strip().split(",")
    sec = math.floor(float(x_arr[0]))
    local_loads = int(x_arr[1].replace(',', ''))
    local_2_arr[sec] = local_loads

remote_2_lines = remote_2.readlines()
remote_2_arr = {}
for x in remote_2_lines:
    x_arr = x.strip().split(",")
    sec = math.floor(float(x_arr[0]))
    remote_loads = int(x_arr[1].replace(',', ''))
    remote_2_arr[sec] = remote_loads

#print(local_2_arr)
#print(remote_2_arr)

file_csv = open(output_file_1 , "w")
file_csv.write("Time,Local Loads,Remote Loads\n")
for x in local_1_arr:
    if x in remote_1_arr:
        file_csv.write(str(x) + "," + str(local_1_arr[x]) + "," + str(remote_1_arr[x])+ "\n")

file_csv = open( output_file_2, "w")
file_csv.write("Time,Local Loads,Remote Loads\n")
for x in local_2_arr:
    if x in remote_2_arr:
        file_csv.write(str(x) + "," +str(local_2_arr[x]) + "," + str(remote_2_arr[x]) + "\n")
