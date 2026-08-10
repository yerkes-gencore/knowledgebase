# Emory High Performance Computing Cluster
<img width="960" height="455" alt="image" src="https://github.com/user-attachments/assets/1b7d63d6-e642-4a39-ab82-9e94ae8179e0" />
Emory University expanded its scientific computing infrastructure and services with its Hybrid High-Performance Computing Platform for Education and Research (HyPER). The [HyPER C3](https://emory.sharepoint.com/sites/HyPER) "provides... centrally-managed, user-friendly, and subsidized access to shared high-performance computing resources" hosted on AWS infrastructure.

## Overview of cluster organization
There are three storage areas on the HPC with different storage and access capacities.

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


## Troubleshooting

### 1. WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!

Periodically, you may come across this message:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Redownload the `ssh_ca.pub` file from step 2 and rerun the listed commands. This should restore access.
