# Slurm submission scripts
This markdown file describes formatting a submission script for the HPC. Several submission scripts for different jobs are included as examples.

## Header 
The header dictates how resources are allocated for the job you are submitting. If you don't know exactly how much memory/threads/time you need, overestimate the first time, record what resources are used, then adjust your header accordingly. 

Below are the required components for a job on a CPU partition. Other parameters can be found at: https://slurm.schedmd.com/sbatch.html 

```
#!/bin/bash
#SBATCH --job-name=freebayes
#SBATCH --output slurm-%j.out
#SBATCH --account=epc-account
#SBATCH --partition=c128-m1024
#SBATCH --nodes=1
#SBATCH --mem=200G
#SBATCH --cpus-per-task=110
#SBATCH --time=12:00:00
```
