i=1
echo "total,used,free"
while true
do
    free -m | grep Mem | awk '{print $2","$3","$4}'
    i=$((i+1))
    sleep 30
done
