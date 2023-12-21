ip=$1
name=$2
current_date=$(date +"%Y-%m-%d")
#filename="${name}_${current_date}.txt"
filename="${name}.txt"

start_time=$(date +%s)

while true
do 
 #echo "Acquiring transceivers temperature measurements..."
 current_time=$(date +%s)
 elapsed_time=$((current_time - start_time))

 fpga=$(sshpass -p "" ssh root@$1 "/wr/bin/wrs_dump_shmem | grep -e HAL.temp.fpga: " | awk '{print $2}')
 echo -n "$elapsed_time " >> $filename
 echo -n "$fpga " >> $filename
 for i in $(seq 1 18)
   do
     sfp=$(sshpass -p "" ssh root@$1 "/wr/bin/wrs_sfp_dump -L -d -p $i | grep Temp" | awk '{print $2}')
     if [ $i -eq 18 ]; then
	  echo -e -n "$sfp\n" >> $filename
     else
	 echo -n "$sfp " >> $filename
     #echo $i $(date +%s) $(/root/sfp.sh 10.0.100.1 $i) >> data.txt
     fi
   done
#echo "Completed. File ${file} updated"
#echo "Wait ${minutes} minutes before next measurement..."
#sleep $wait
   sleep 5
done
