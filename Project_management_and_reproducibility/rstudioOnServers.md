### First Time Ever
Do these steps the first time you use/will use the gencore server system, **not** per server
#### 1. Generate GitHub personal access token (PAT).
This is what you use instead of your GitHub account password when using git in RStudio.
**In a browser:**
Go to [https://github.com/settings/tokens](https://github.com/settings/tokens) and click “Generate token”.
Once generated, ==copy and save the token!== You will not see it again!
- We will be placing it in your .Renviron file, but be careful not to push this location to GitHub
#### 2. Make .Renviron file (I keep mine in my analyst folder) to access shared renv packages and hold your PAT
```
nano /yerkes-cifs/runs/analyst/rachel/R4.3.1/.Renviron

RENV_PATHS_ROOT='/yerkes-cifs/runs/tools/renv/'
RENV_PATHS_CACHE='/yerkes-cifs/runs/tools/renv/cache'
R_MAX_VSIZE=200Gb
GITHUB_PAT=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### 3. Make rsession.conf file to control how long it takes for the server to time out 
```
nano /yerkes-cifs/runs/analyst/rachel/R4.5.3/rsession.conf

session-timeout-minutes=7200
```

### **First Time On a Server**
#### 1. Access the server and add port
##### ssh into server
Check [[#Available Servers]]
`ssh -p 22 rdockma@sblab-wks06.enprc.emory.edu`
##### add assigned port to bypass firewall
You should be assigned a port; mine is 8801. Use that each time!
`sudo firewall-cmd --add-port=8801/tcp`
#### 2. Link GitHub to server
##### in the terminal:
add your github username and email to the global github config 
	Note: the global git config file ends up in /root, which cannot be accessed 
		When I initiate a project and load a repo in RStudio, I go to the terminal and use 
			git config user.name "your-git-username"
			git config user.email "your-git-email @gmail.com"
```
git config --global user.name "your-git-username"
git config --global user.email "your-git-email@gmail.com"
git config --global init.defaultBranch main # maybe not necessary?

git config --global --list # to inspect if everything worked
```
### **Beginning a New RStudio Session**
#### access server from terminal
```ssh -p 22 rdockma@sblab-wks06.enprc.emory.edu```
#### start up "screen"
```screen -S nameOfScreen```
#### open docker/podman image
For single cell, initiate podman/docker with:
```
podman run \
  -e PASSWORD=password \
  -e ROOT=TRUE \
  -p 8801:8787 \
  -v /yerkes-cifs:/yerkes-cifs \
  -v /yerkes-cifs/runs/analyst/rachel/R4.3.1/.Renviron:/root/.Renviron \
  -v /home/rdockma/.gitconfig:/root/.gitconfig \
  yerkesgencore/gencore-singlecell-rstudio:4.3.1-0.0.4
```
#### exit out of screen in terminal
press CTRL+a+d
#### navigate to RStudio server in an internet browser/Chrome
http:// sblab-wks==06==.enprc.emory.edu:==8801==
- use correct server and assigned port
  
#### clone template repository 
In RStudio, click:
1. new project in top right corner
![[Screenshot 2026-06-23 at 10.34.31 AM.png|443]]

2. version control
![[Screenshot 2026-06-23 at 10.34.50 AM.png|270]]![[Screenshot 2026-06-23 at 10.35.05 AM 1.png|270]]

3. use link from github repo
![[Screenshot 2026-06-23 at 10.36.20 AM.png|547]]
	Note. I still have to add a username and password (PAT) when prompted
	
4. Git tab should appear. You can choose a different branch if desired
![[Screenshot 2026-06-23 at 10.32.18 AM.png|542]]
![[Screenshot 2026-06-23 at 10.37.12 AM.png|537]]
#### initiate renv
in the console, initiate renv and restore packages
```
renv::init(bioconductor = TRUE)
renv::restore()
```
### Ensuring access to all R-projects regardless of server
info is stored, within R terminal, at ~/.local/share/rstudio (which is based on what you set to be root)
### Available Servers
The ones I have initiated are in **Bold**
	sblab-wks01.yerkes.emory.edu
	sblab-wks02.yerkes.emory.edu
	sblab-wks03.yerkes.emory.edu 
	**sblab-wks04.enprc.emory.edu**   *# higher memory*
	sblab-wks05.enprc.emory.edu  *# higher memory*
	**sblab-wks06.enprc.emory.edu** 
	ssh -p 22 rdockma@sblab-wks03.yerkes.emory.edu

helpful screen commands
	```screen -ls```            # check which screens are present or active
	```screen -d id```        # detach screen and let it run
		OR: CTRL+a+d
	```screen -r id```        # reattach screen
	
### **Building a new image**
Since R/Rstudio updates every now and again, sometimes a new image needs to be made to accommodate dependencies and stay up-to-date with packages.

I find the easiest way to do this is to use a [[Dockerfile]]. 

This file:
1. pulls the base image with the correct RStudio version
2. ensures Bioconductor is the correct version
3. installs system libraries that are required for general function
4. runs an Rscript that installs the required R packages 

So, when you load up the image, everything is ready to go!

To make the image, you navigate to the directory that contains the file "Dockerfile" and run the following:
	`docker build -t rstudio4.5.3packages .
	
Once everything is complete, you'll see a message 
	`Successfully tagged localhost/rstudio4.5.3packages:latest

Then, I run a command to save an archive file storing the image:
	`podman save localhost/rstudio4.5.3packages:latest | gzip > rstudio4.5.3packages.tar.gz
		*note: podman is technically what we use on the servers, but it seems docker/podman are interchangeable*

Now, others can access my image by finding the path to this archive and running the following:
	`podman load -i /path/to/rstudio4.5.3packages.tar.gz

Once you load the image, you can initiate the RStudio server by referring to your localhost location, as follows:
`podman load /path/to/rstudio4.5.3packages.tar.gz`

podman run \
  -e PASSWORD=password \
  -e ROOT=TRUE \
  -p 8801:8787 \
  -v /yerkes-cifs:/yerkes-cifs \
  -v /yerkes-cifs/runs/analyst/rachel/R4.5.3/.Renviron:/root/.Renviron \
  -v /home/rdockma/.gitconfig:/root/.gitconfig \
  -v /yerkes-cifs/runs/analyst/rachel/R4.5.3/rsession.conf:/etc/rstudio/rsession.conf \
  localhost/rstudio4.5.3packages:latest

# Troubleshooting
### error: server was rebooted, can no longer access gui in browser
Solution: need to expose your port again with ```sudo firewall-cmd --add-port=8801/tcp```

sudo podman save docker.io/cumulusprod/souporcell:2.5 | gzip > /yerkes-cifs/runs/analyst/rachel/docker/souporcellDocker.tar.gz
