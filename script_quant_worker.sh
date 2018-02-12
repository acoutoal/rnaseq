#!/bin/bash
# partition (queue)
#SBATCH -N 1
# number of nodes
#SBATCH -n 1
# number of cores
#SBATCH --mem 100G

echo "##################################################################"
echo QUANT Worker
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo Running shell from $SHELL
echo "##################################################################"

echo $0 $1 $2 $3 $4;echo;echo
line=$1
indir=$2
outdir=$3
tissue=$4
echo $line;echo
echo $indir;echo
echo $outdir;echo
echo $tissue;echo

PATH=$PATH:/media/shared_data/software/QTLtools_1.0
GTFFILE=/media/shared_data/data/gencode.v19.annotation.gtf
mytemp=/tmp/alex/$tissue
THREAD_NO=4

#Create temporary directories
mkdir -p $mytemp/$line/reference

#Change to my temp directory
cd $mytemp

#Print current dir
echo "Current dir $"`pwd`
echo "Input dir: "$indir
echo "Input dir content: "`ls $indir`

#wait between 1-3s before moving data around the cluster
sleep $(( ( RANDOM % 3 )  + 1 ))

#Copy files to tmp dir
cp  $indir/$line'_ref.Aligned.sortedByCoord.out.bam' $line/reference

echo "1. Temp dir content: "`ls $line/reference`

#STAR aligned BAMs were filtered using the following parameters:
samtools view -@ $THREAD_NO -b -F4 -q 30 $line/reference/$line'_ref.Aligned.sortedByCoord.out.bam' \
-o $line/reference/$line'.filtered.bam'

echo "2. Temp dir content: "`ls $line/reference`

#Index bam files
samtools index $line/reference/$line'.filtered.bam'  $line/reference/$line'.filtered.bai'

#Calculate exon counts
qtltools quan --bam $line/reference/$line'.filtered.bam' \
--gtf $GTFFILE --samples $line'_ref' \
--out-prefix $line/reference/$line'.filtered.quant' \
--filter-mapping-quality 30 --filter-mismatch 5 --filter-mismatch-total 5 \
--check-proper-pairing --check-consistency \
--rpkm --no-merge

echo "3. Temp dir content: "`ls $line/reference`

#move files to repository
mkdir -p $outdir/$line/reference/
cp $line/reference/$line'.filtered.quant'* $outdir/$line/reference/
echo "Copying files to $"$outdir/$line/reference/

#Change to home dir
cd /media/shared_data/alex/proj/exonquant/bin

echo "Removing tmp dir $"$mytemp/$line

#cleaning tmp
rm -r $mytemp/$line

#Job statistics
#echo `sstat --format=MaxCPU,MaxRSS,MaxVMSize,JobID -j $SLURM_JOB_ID`

echo "##################################################################"
echo  Finished running script on host `hostname`
echo  Time is `date`
echo "##################################################################"

