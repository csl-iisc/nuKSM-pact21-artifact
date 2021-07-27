import sys

local_remote_off_1 = open(sys.argv[1])
local_remote_off_2 = open(sys.argv[2])
local_remote_on_1 = open(sys.argv[3])
local_remote_on_2 = open(sys.argv[4])

local_remote_off_1_lines = local_remote_off_1.readlines()[1:]
local_remote_off_2_lines = local_remote_off_2.readlines()[1:]
local_remote_on_1_lines = local_remote_on_1.readlines()[1:]
local_remote_on_2_lines = local_remote_on_2.readlines()[1:]

def get_local_remote(filelines):
    local = 0
    remote = 0
    for x in filelines:
        y = x.strip().split(",")
        local += int(y[1])
        remote += int(y[2])
    sum_of_local_remote = local+remote
    local_percentage = 100 * local / (sum_of_local_remote)
    remote_percentage = 100 * remote / (sum_of_local_remote)
    return (local_percentage , remote_percentage)

(instance1_local_off , instance1_remote_off) = get_local_remote(local_remote_off_1_lines)
(instance2_local_off , instance2_remote_off) = get_local_remote(local_remote_off_2_lines)
(instance1_local_on , instance1_remote_on) = get_local_remote(local_remote_on_1_lines)
(instance2_local_on , instance2_remote_on) = get_local_remote(local_remote_on_2_lines)
print(instance1_local_off , "," ,  instance1_remote_off ,"," ,  instance2_local_off , "," , instance2_remote_off , "," , instance1_local_on , "," , instance1_remote_on , "," , instance2_local_on , "," , instance2_remote_on)
        

