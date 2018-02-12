#!/bin/bash
tissue="adipose"
#tissue="skin"
#tissue="blood"
#tissue="LCL"

case $tissue in
"adipose")
	id_file=fat_ids.txt
;;
"skin")
	id_file=skin_ids.txt
;;
"blood")
	id_file=blood_ids.txt
;;
"LCL")
	id_file=lcl_ids.txt
esac


while read fidx; do
 line=$fidx
 echo $line

case $tissue in
"adipose")
 indir=/media/shared_data/data/adipose_out/$line/reference
 outdir=/media/shared_data/alex/proj/exonquant/results/adipose/qc4
;;
"skin")
 indir=/media/shared_data/data/skin_out/$line/reference
 outdir=/media/shared_data/alex/proj/exonquant/results/skin/qc4
;;
"blood")
 indir=/media/shared_data/data/blood_out/$line/reference
 outdir=/media/shared_data/alex/proj/exonquant/results/blood/qc4
;;
"LCL")
 indir=/media/shared_data/data/LCL_out/$line/reference
 outdir=/media/shared_data/alex/proj/exonquant/results/LCL/qc4
esac

sbatch script_quant_worker.sh $line $indir $outdir $tissue

done < $id_file

#done < fat_ids.txt
#done < blood_ids.txt
#done < lcl_ids.txt
#done < skin_ids.txt


