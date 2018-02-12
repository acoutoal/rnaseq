#!/bin/bash

while read fidx; do
 line=$fidx
 echo $line
 sbatch script_mbv_worker.sh $line
done < blood_ids.txt
#done < lcl_ids.txt
#done < skin_ids.txt
#done < fat_ids.txt


