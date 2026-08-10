# Emory High Performance Computing Cluster
<img width="960" height="455" alt="image" src="https://github.com/user-attachments/assets/1b7d63d6-e642-4a39-ab82-9e94ae8179e0" />
Emory University expanded its scientific computing infrastructure and services with its Hybrid High-Performance Computing Platform for Education and Research (HyPER). The [HyPER C3](https://emory.sharepoint.com/sites/HyPER) cluster "provides... centrally-managed, user-friendly, and subsidized access to shared high-performance computing resources" hosted on AWS infrastructure.

## Overview of cluster organization
The cluster consists of **login nodes** and **compute nodes** which share the same storage directories. 

- You access the HPC via SSH on to the **login nodes**. You do NOT run analyses on this node; you may download files, edit and submit SLURM submission scripts, and organize directories at this location.

- Actual computational work occurs on the **compute nodes**, which are divided into *partitions* with specific memory, thread, and processing unit characteristics.

Below are tables outlining partition and storage characteristics (up-to-date as of August 2026).

### Partitions
<img width="1413" height="487" alt="Screenshot 2026-08-10 at 2 14 08 PM" src="https://github.com/user-attachments/assets/6e90bdb7-08b0-4732-9e0c-0a45f62cc22b" />

- **CPU partitions**: c64-m512, c128-m1024

- **GPU partitions**: rp6b-1-gm96-c8-m64, l4-4-gm96-c48-m192, rp6b-8-gm768-c192-m2048, b200-8-gm1432-c192-m2048

- **Jupyter notebook partitions**: jptr-l4-1-gm24-c4-m16 (GPU), jptr-c4-m32 (CPU)

### Storage

|Storage Area|Path|Purpose|Quota|Purge Policy|Increase Policy|Backup|
| :--- | :--- |:--- |  :--- | :--- | :--- | :--- |
|User Home|/user/YOUR_NETID|Storage for small reused objects, eg submission scripts|50Gb|No job submission for 90 days|None|Daily backup|
|User Scratch|/scratch/YOUR_NETID|High performance personal workspace for analysis|1Tb|No job submission for 90 days|Temporary increase to 1.5Tb on request|None|
|Group Share|/group/sbosing-g00|Shared storage among group members, eg software, genome references, environments|1Tb|None|$0.15 per additional GB-mo|None|

## Getting Started
Access must be requested through a group involved with the Emory EPC by completing [this application](https://redcap.emory.edu/surveys/?s=YNM3LND7LKNFAMNL). Once your account is established, you will sign into the HPC with your Emory NETID. 

### 1. VPN
If you are accessing off-campus (or are using the dev HPC), you need to first log in to the [Emory VPN](https://vpn.emory.edu/my.policy). If you have not done this before, follow the instructions in the link to install the proper software.

### 2. Add HPC to known hosts
To add the HPC locations to your list of known hosts, first download the file `ssh_ca.pub` from the [SharePoint site](https://emory.sharepoint.com/sites/HyPER/SitePages/Cirrostratus-User-Guide---Logging-in-to-the-Cluster.aspx), then run the following commands:

**Mac/Linux:**
```
echo "@cert-authority ondemand-dev.it.emory.edu $(cat Downloads/ssh_ca.pub)" >> ~/.ssh/known_hosts
echo "@cert-authority ondemand.it.emory.edu $(cat Downloads/ssh_ca.pub)" >> ~/.ssh/known_hosts
echo "@cert-authority cirrostratus.it.emory.edu $(cat Downloads/ssh_ca.pub)" >> ~/.ssh/known_hosts
```

**Windows powershell:**
```
(Get-Content 'C:\path\to\ssh_ca.pub') | ForEach-Object { '@cert-authority cirrostratus.it.emory.edu ' + $_ } | Add-Content ‘%USERPROFILE%\.ssh\known_hosts’
(Get-Content 'C:\path\to\ssh_ca.pub') | ForEach-Object { '@cert-authority ondemand.it.emory.edu ' + $_ } | Add-Content ‘%USERPROFILE%\.ssh\known_hosts’
(Get-Content 'C:\path\to\ssh_ca.pub') | ForEach-Object { '@cert-authority ondemand-dev.it.emory.edu ' + $_ } | Add-Content ‘%USERPROFILE%\.ssh\known_hosts’
```

### 3. Connect to the HPC
Using your terminal or terminal client (such as PuTTY for Windows computers), access the HPC through SSH with your NETID.

- Dev. cluster: `ssh YOUR_NETID@ondemand-dev.it.emory.edu`
- Cirrostratus: `ssh YOUR_NETID@cirrostratus.it.emory.edu`
- On Demand: `ssh YOUR_NETID@ondemand.it.emory.edu`

Enter your Emory password when prompted. 

### 4. Configure conda environment management
After logging in for the first time, run `conda init bash` and log out. You do not need to do this again for future logins. 

## Useful commands
These are commands I frequently use on the cluster. Read the User Guide or linux manuals for more detailed guides.

- `sinfo` to check available partitions
<img width="774" height="149" alt="Screenshot 2026-08-10 at 2 41 18 PM" src="https://github.com/user-attachments/assets/475fdb54-efea-4d58-8f66-acd46032e8f9" />

- `sbatch` to submit a job
<img width="774" height="74" alt="Screenshot 2026-08-10 at 2 39 43 PM" src="https://github.com/user-attachments/assets/ff19529b-5d2c-4201-b64b-e737b17e8f60" />

- `squeue --me` to check job status
<img width="774" height="54" alt="Screenshot 2026-08-10 at 2 39 08 PM" src="https://github.com/user-attachments/assets/4893a8a0-01a7-4301-aacd-7973bc899ca7" />

- `scancel {JOBID}` to cancel job
<img width="774" height="74" alt="Screenshot 2026-08-10 at 2 40 08 PM" src="https://github.com/user-attachments/assets/f9d8fff8-f2ac-4f11-94df-2fecad748c6b" />

- `du -sh` to check storage
    - Note: I only have 2 projects in my /scratch directory during this screenshot, and I am almost halfway to my quota! Monitor usage carefully.
<img width="774" height="109" alt="Screenshot 2026-08-10 at 2 46 22 PM" src="https://github.com/user-attachments/assets/56578965-4820-4c5d-b9b0-5f74b05916d1" />
 

# Troubleshooting

## 1. WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!

Periodically, you may come across this message:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Redownload the `ssh_ca.pub` file from step 2 and rerun the listed commands. This should restore access.
