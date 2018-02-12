#!/bin/bash
# partition (queue)
#SBATCH -N 1
# number of nodes
#SBATCH -n 1
# number of cores
#SBATCH --mem 10G

echo "##################################################################"
echo MBV worker
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`
echo Running shell from $SHELL
echo "##################################################################"


echo $0 $1;echo;echo
line=$1
echo $line;echo


PATH=$PATH:/media/shared_data/software/QTLtools_1.0
INVCFFILE=/media/shared_data/alex/data/genotypes/matrixqtl/Brent.Final.GW.ref.chr.final.vcf.gz
THREAD_NO=4
VCFFILE=$line"/reference/"$(basename $INVCFFILE)

#indir=/media/shared_data/data/skin_out/$line/reference
#indir=/media/shared_data/data/adipose_out/$line/reference
#indir=/media/shared_data/data/LCL_out/$line/reference
#outdir=/media/shared_data/alex/proj/exonquant/results/adipose
#outdir=/media/shared_data/alex/proj/exonquant/results/skin
#outdir=/media/shared_data/alex/proj/exonquant/results/lcl
outdir=/media/shared_data/alex/proj/exonquant/results/blood
indir=/media/shared_data/data/blood_out/$line/reference
mytemp=/tmp/alex

#Create temporary directories
mkdir -p $mytemp/$line/reference

#Change to my temp directory
cd $mytemp

#Print current dir
echo "Current dir $"`pwd`
echo "Input dir: "$indir
echo "Input dir content: "`ls $indir`

#wait between 1-10s before moving data around the cluster
sleep $(( ( RANDOM % 3 )  + 1 ))

#Copy files to tmp dir
echo "1. Temp dir content: "`ls $line/reference`

#STAR aligned BAMs were filtered using the following parameters:
cp  $indir/$line'_ref.Aligned.sortedByCoord.out.bam' $line/reference
cp $INVCFFILE* $line/reference

samtools view -@ $THREAD_NO -b -F4 -q 30 \
$line/reference/$line'_ref.Aligned.sortedByCoord.out.bam' \
-o $line/reference/$line'.filtered.bam'

echo "2. Temp dir content: "`ls $line/reference`

#Index bam files
samtools index $line/reference/$line'.filtered.bam'  \
$line/reference/$line'.filtered.bai'

#Calculate exon counts
qtltools match --bam $line/reference/$line'.filtered.bam' \
--vcf $VCFFILE \
--out $line/reference/$line'.filtered.match' \
--filter-mapping-quality 30

echo "3. Temp dir content: "`ls $line/reference`

#move files to repository
mkdir -p $outdir/$line/reference/
cp $line/reference/$line'.filtered.match'* $outdir/$line/reference/
echo "Copying files to: "$outdir/$line/reference/

#Change to home dir
cd /media/shared_data/alex/proj/exonquant/bin

echo "Removing tmp dir: "$mytemp/$line

#cleaning tmp
rm -r $mytemp/$line

#Job statistics
#echo `sstat --format=AveCPU,MaxRSS,MaxVMSize,JobID -j $SLURM_JOB_ID`

echo "##################################################################"
echo  Finished running script on host `hostname`
echo  Time is `date`
echo "##################################################################"

