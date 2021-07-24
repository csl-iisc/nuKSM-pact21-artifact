import sys

csv_ksm = open(sys.argv[1])
csv_nuksm = open(sys.argv[2])

figure_type = sys.argv[3]

csv_ksm = csv_ksm.readlines()[1:]
csv_nuksm = csv_nuksm.readlines()[1:]

csv_ksm_dict = {}

for line in csv_ksm:
    curr = line.strip().split(",")
    time = int(curr[0])
    cpu_percentage = float(curr[-1]) 
    free_memory = int(curr[-5])
    deduplicated_memory = ((int(curr[-3])) * 4)/1000000
    csv_ksm_dict[time] = {"free_memory": free_memory , "deduplicated_memory":deduplicated_memory , "cpu_percentage":cpu_percentage}

freeMemComputed=False
oom=False

print("Time , KSM , nuKSM" )
for line in csv_nuksm:
    curr = line.strip().split(",")
    time = int(curr[0])
    cpu_percentage = float(curr[-1])
    free_memory = int(curr[-5])
    deduplicated_memory = ((int(curr[-3])) * 4)/1000000
    csv_ksm_dict_value =  {"free_memory": "" , "deduplicated_memory":"" , "cpu_percentage":""}    
    if time in csv_ksm_dict:
        csv_ksm_dict_value = csv_ksm_dict[time]

    if freeMemComputed == False:
        prev_ksm_free_memory = csv_ksm_dict_value["free_memory"]
        freeMemComputed=True
    elif oom==False:
        if 10000 < (csv_ksm_dict_value["free_memory"] - prev_ksm_free_memory):
            oom=True
        prev_ksm_free_memory = csv_ksm_dict_value["free_memory"]

    if figure_type == "FREE_MEM":
        if oom == False:
            print(time , "," , csv_ksm_dict_value["free_memory"] , "," , free_memory)
        else:
            print(time , "," , "OOM" , "," , free_memory)
    elif figure_type == "DEDUP_MEM":
        if oom == False:
            print(time , "," , csv_ksm_dict_value["deduplicated_memory"] , "," , deduplicated_memory)
        else:
             print(time , "," , "OOM" , "," , deduplicated_memory)
    elif figure_type == "CPU_PERCENTAGE":
        if oom == False:
            print(time , "," , csv_ksm_dict_value["cpu_percentage"] , "," , cpu_percentage)
        else:
            print(time , "," , "OOM" , "," , cpu_percentage)
        
