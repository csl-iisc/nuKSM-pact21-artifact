a=`ps aux | grep ksm  | grep -v grep | awk '{print $2}'`
while true
do
    top -b -d1 -p $a -n 1 | grep -i "$a"
    sleep 1
done
