import sys

throughput_1_f = open(sys.argv[1])
throughput_2_f = open(sys.argv[2])

throughput_1 = throughput_1_f.readlines()[1:]
throughput_2 = throughput_2_f.readlines()[1:]

throughput_2_dict = {}
throughput = []

for line in throughput_2:
    curr = line.strip().split(",")
    throughput_2_dict[int(curr[0])*45] = int(curr[1])

for line in throughput_1:
    curr = line.strip().split(",")
    curr_key = int(curr[0])*45
    throughput.append({"key": curr_key , "tp_1": int(curr[1]) , "tp_2": throughput_2_dict[curr_key]})

print("Time , Low Priority Instance , High Priority Instance")
for x in throughput:
    print(x["key"] , "," , x["tp_1"] , "," , x["tp_2"])

