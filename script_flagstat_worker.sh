#!/bin/bash
# partition (queue)
#SBATCH -N 1
# number of nodes
#SBATCH -n 1
# number of cores
#SBATCH --mem 100G

echo "##################################################################"
echo FLAGSTAT Worker 
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo Running shell from $SHELL
echo "##################################################################"


echo $0 $1;echo;echo
line=$1
echo $line;echo

PATH=$PATH:/media/shared_data/software/QTLtools_1.0
GTFFILE=/media/shared_data/data/gencode.v19.annotation.gtf
THREAD_NO=4
#line=21
#indir=/media/shared_data/data/adipose_out/$line/reference
#indir=/media/shared_data/data/skin_out/$line/reference
#indir=/media/shared_data/data/LCL_out/$line/reference
indir=/media/shared_data/data/blood_out/$line/reference
#outdir=/media/shared_data/alex/proj/exonquant/results/adipose
#outdir=/media/shared_data/alex/proj/exonquant/results/skin
#outdir=/media/shared_data/alex/proj/exonquant/results/lcl
outdir=/media/shared_data/alex/proj/exonquant/results/blood
mytemp=/tmp/alex


#Print current dir
echo "Current dir: "`pwd`
echo "Input dir:   "$indir
echo "Output dir:  "$outdir
echo "Input file:  "$indir/$line'_ref.Aligned.sortedByCoord.out.bam'
echo "Output file: "$outdir/$line/reference/$line'.flagstat'

#wait between 1-5s before moving data around the cluster
sleep $(( ( RANDOM % 3 )  + 1 ))

#Copy files to tmp dir
samtools flagstat $indir/$line'_ref.Aligned.sortedByCoord.out.bam' >  $outdir/$line/reference/$line'.flagstat'

#Job statistics
echo `sstat --format=AveCPU,MaxRSS,MaxVMSize,JobID -j $SLURM_JOB_ID`

echo "##################################################################"
echo  Finished running script on host `hostname`
echo  Time is `date`
echo "##################################################################"



