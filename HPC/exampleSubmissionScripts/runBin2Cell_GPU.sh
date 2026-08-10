#!/bin/bash
#SBATCH --job-name=runB2CwGPU
#SBATCH --account=epc-account
#SBATCH --partition=rp6b-2-gm192-c48-m512
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=24G
#SBATCH --gpus=1
#SBATCH --time=03:00:00

# Note: this script uses a conda environment and a custom python script to run Bin2Cell
## the header points to a GPU partition with the associated parameters

source activate /group/sbosing-g00/env/Bin2Cell

python /users/rdockma/scripts/runB2C.py \
-d /scratch/rdockma/projects/p25215_Chaoran \
-s WT --mpp 0.2 \
--p_he 0.05 \
--nms_he 0.4 \
-b 4 -c 2400 2500 175 375 
