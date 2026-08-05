# Sharepoint site for the HPC
https://emory.sharepoint.com/sites/HyPER/SitePages/Community-Cloud-Cluster-Cirrostratus.aspx

# Using the Emory HPC 
This is where info on using the Emory computing cluster will be stored, along with example slurm scripts, troubleshooting, and best practices 

## Getting Started
Access must be requested through a group involved with the Emory EPC. Once your account is established, you will sign into the HPC with your Emory NETID. 

### 1. VPN
If you are accessing off-campus (or are using the dev HPC), you need to first log in to the [Emory VPN](https://vpn.emory.edu/my.policy). If you have not done this before, follow the instructions in the link to install the proper software 

### 2. Access HPC with SSH

In terminal: `ssh YOUR_NETID@ondemand-dev.it.emory.edu` 

Enter your Emory password when prompted. 

### 3. Initiate conda environment


## Troubleshooting

### 1. WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!

Periodically, you may come across this message:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

You will need to download the file `ssh_ca.pub` and add the cluster to your list of known hosts. Instructions are at:
https://emory.sharepoint.com/sites/HyPER/SitePages/Cirrostratus-User-Guide---Logging-in-to-the-Cluster.aspx

I downloaded the file ssh_ca.pub to my desktop, and ran it as so:

`echo "@cert-authority ondemand-dev.it.emory.edu $(cat Desktop/ssh_ca.pub)" >> ~/.ssh/known_hosts`
