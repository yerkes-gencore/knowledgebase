#!/bin/bash
#SBATCH --job-name=freebayes
#SBATCH --output fb_slurm-%j.out
#SBATCH --account=epc-account
#SBATCH --partition=c128-m1024
#SBATCH --nodes=1
#SBATCH --mem=200G
#SBATCH --cpus-per-task=110
#SBATCH --time=12:00:00
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=rachel.dockman@emory.edu

# note: did not need as much memory as requested at all, <100Gb is sufficient
date 
source activate /group/sbosing-g00/env/freebayes
cd /scratch/rdockma/projects/p25097_Vincent
ls *_R1_001.fastq.gz | awk -F"_R" '{print $1}' > p25097_samples.txt

for sample in $(cat p25097_samples.txt); do
    # used minimap settings directly from souporcell rec
    singularity exec /group/sbosing-g00/env/soupOrCell/souporcell_release.sif /opt/minimap2-2.26_x64-linux/minimap2 -ax splice -t 100 \
    -G50k -k 21 -w 11 --sr -A2 -B8 -O12,32 -E2,1 -r200 -p.5 -N20 -f1000,5000 -n2 -m20 -s40 -g2000 -2K50m --secondary=no \
    /scratch/rdockma/projects/p25097_Vincent/cellranger_Mmul10_100.fasta "$sample"_R1_001.fastq.gz "$sample"_R2_001.fastq.gz | samtools sort -@ 96 -o "$sample"_Sort.bam

    # need RGs with sample id, need to make sure these match sample ids when sc data are processed
    samtools addreplacerg -r ID:"$sample" -r SM:"$sample" -@ 96 -o "$sample"_tagSort.bam "$sample"_Sort.bam

    # removed duplicates, reduced bam file size by about half
    samtools rmdup -S --reference /scratch/rdockma/projects/p25097_Vincent/cellranger_Mmul10_100.fasta "$sample"_tagSort.bam "$sample"_tagSortDedup.bam

    # again checking new file exists and isn't empty before deleting old file
    if [ -f "$sample"_tagSortDedup.bam ] && [ "$(stat -c %s "$sample"_tagSortDedup.bam)" -gt 10485760 ]; then
        rm "$sample"_tagSort.bam
	rm "$sample"_Sort.bam
    fi

    # index bam files
    samtools index "$sample"_tagSortDedup.bam
done

# list to feed into freebayes
ls *.bam > bamList.txt

# index genome if you haven't already
samtools faidx cellranger_Mmul10_100.fasta

date

# running in parallel with 96 threads
freebayes-parallel <(fasta_generate_regions.py cellranger_Mmul10_100.fasta.fai 100000) 96 -f cellranger_Mmul10_100.fasta -C 4 -q 20 -n 4 -E 3 -m 30 --min-coverage 6 --limit-coverage 100000 \
-L bamList.txt > p25097_Vincent_3Aug26_24c.vcf

date 

