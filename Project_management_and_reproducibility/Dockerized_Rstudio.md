# Dockerized Rstudio server

Dockerized sessions of Rstudio ensure a reproducible architecture for all analyses. Using dockerized sessions (to control system architecture and R version) and the R package `Renv` (to control and document R package versions) and well-organized code in R projects (to control R session environment) helps keep code reproducible.

The Rocker project maintains base images for dockerized Rstudio servers. These 
serve as good starting points which you may want to extend with system libraries
as needed for R packages. 

[BioConductor also maintains docker images](https://www.bioconductor.org/help/docker/).
While these extend the Rocker images
to include more system libraries and common R packages (e.g. BioCManager), they
also freeze the repositories used for installing R packages, which can be frustrating
if you aren't expecting it or don't know how to work around it.

The gencore is trying to maintain docker images to standardize our routine
analyses. We try to make these include any system libraries needed for our work,
such as the HDF5 library for reading H5 files from cellranger, and other libraries
for the gencoreSC workflow. See the following links for more details:

`https://hub.docker.com/repository/docker/yerkesgencore/gencore-singlecell-rstudio`

`https://github.com/yerkes-gencore/rstudio-server`.

# Starting up a dockerized RStudio server

You will likely want to start the container in the background (e.g. via `screen`) 
to allow the image to stay running even if your computer disconnects from the server.

SBlab servers 1-3 have docker installed, while 4-6 have Podman (a docker wrapper).
You can start a dockerized Rstudio with something resembling the following command
(subbing `podman` for `docker` where appropriate):

```
podman run \
  -e PASSWORD=password \
  -e ROOT=TRUE \
  -p 8788:8787 \
  -v /yerkes-cifs:/yerkes-cifs \
  yerkesgencore/gencore-singlecell-rstudio:4.3.1-0.0.4
```

* `podman run` the base call to start a container

* `-e PASSWORD=<your password here>` The `-e` flag is used to set environment
variables within the container. You can set a password for the login if desired,
although no-one outside ofEmory should be able to access these servers (I think?). 

* `-e ROOT=TRUE` grants root permissions, generally useful for installing system 
libraries inside the container. For some Rocker images, this changes the login
ID from 'rstudio' to 'root'.

* `-p 8788:8787` sets the port to access the container at, see [ports](#ports) 
for more details

* `-v` mounts volumes, see [Mounts](#mounts) for more details

* The final line specifies the name of the container to run, which can include
a version tag.

When you run the docker image (aka create a container) on the server via the command line, you can access the RStudio Server app instance via a URL such as `http://sblab-wks02.yerkes.emory.edu:8787`. 

The first part of the URL is the address to the server (e.g. `http://sblab-wks02.yerkes.emory.edu`). The second part is the port used by the server to communicate to the app (e.g. `8787`). See the [Ports]() section for more info.

# Ports

The default port that the RStudio-Server app uses is 8787. Only one person/session 
can use a given port on a server. To allow multiple users to use the separate app
instances on a server at the same time, we bind a different port (e.g. `8791`) 
to the port used by RStudio Server with the 
`-p` parameter of `podman run` when we start up the container:

```
podman run -e PASSWORD=password -e ROOT=TRUE -p ${your_desired_port}:8787 -v /yerkes-cifs:/yerkes-cifs yerkesgencore/gencore-singlecell-rstudio
```

You will need to expose the port to be able to access it from your browser. Run
this command on the server with your port

`sudo firewall-cmd --add-port=${your_desired_port}/tcp`

Try to use the same port number on all servers, and try to use port numbers > 8788 (the default for Rstudio servers). If you anticipate your instance requiring lots of memory, please communicate that in the `#servers` channel to coordinate use.

| Port | Sblab4 | Sblab5 | Sblab6 | Sblab02 |
|------|--------|--------|--------| --------|
| 8789 |  Greg  |  Greg  |  Greg  | |
| 8790 | Micah  |  Micah | Micah  | |
| 8791 | Derrik | Derrik | Derrik | |
| 8792 | Amit   | Amit   | Amit   | |
| 8794 | Chris  | Chris  | Chris  | |
| 8795 | Amit   | Kivanc   | Amit   | |
| 8796 | Kivanc   | Kivanc   | Kivanc   | |
| 8787 |        |        |        | Naga | |
| 8797 | Naga   | Naga   | Naga   | |
| 8798 | Amit   | Amit   | Amit   | |

# Mounts

You will likely want to just mount the whole server in the same style as the actual server. This will keep filepaths consistent between the server and the dockerized image, which is especially relevant for symlinks or paths in your code.

`-v /yerkes-cifs:/yerkes-cifs` (as in the above example)

You will also likely want to have an `.Renviron` file that is mounted with your containers. This can store variables like your github PAT and Renv shared cache path (see Renv section) across sessions and projects. It's probably best to put this in your analyst directory in directory for the specific R version (e.g. `/yerkes-cifs/runs/analyst/micah/rstudio-server/4.3.1`).

`-v ${path_to_saved_configs}/.Renviron:/root/.Renviron`

You may want to setup a `rsession.conf` file to increase the timeout length for your session. A plaintext file with the expression `session-timeout-minutes=7200` can be mounted to `/etc/rstudio/rsession.conf` to set your timeout length. 

# Git tab isn't showing up in RStudio interface

If you try running `git status` in RStudio's terminal you will likely get an error looking something like this:
```
fatal: detected dubious ownership in repository at '/yerkes-cifs/runs/analyst/micah/templates/scRNAseq_template'
To add an exception for this directory, call:

        git config --global --add safe.directory /yerkes-cifs/runs/analyst/micah/templates/scRNAseq_template
```

If so, just run that last line in the terminal, then `Quit Session` and it should be visible again.

# Resources for resolving system dependencies of R packages

The `pak` library can help identify all dependencies needed for a package. E.g.:

```
> pak::pkg_sysreqs('scDblFinder')
✔ Updated metadata database: 2.97 MB in 9 files.                          
✔ Updating metadata database ... done                                     
── Install scripts ────────────────────────────────────────────────────────────────────────────────────────────────────────── Ubuntu 22.04 ──
apt-get -y update
apt-get -y install libcairo2-dev make libcurl4-openssl-dev libxml2-dev zlib1g-dev libglpk-dev libgmp3-dev libpng-dev libfreetype6-dev \
  libjpeg-dev libtiff-dev python3 libfontconfig1-dev libfribidi-dev libharfbuzz-dev

── Packages and their system dependencies ───────────────────────────────────────────────────────────────────────────────────────────────────
Cairo       – libcairo2-dev
data.table  – zlib1g-dev
igraph      – libglpk-dev, libgmp3-dev, libxml2-dev
png         – libpng-dev
ragg        – libfreetype6-dev, libjpeg-dev, libpng-dev, libtiff-dev
RCurl       – libcurl4-openssl-dev, make
reticulate  – python3
Rhtslib     – libcurl4-openssl-dev
Rsamtools   – make
systemfonts – libfontconfig1-dev, libfreetype6-dev
textshaping – libfreetype6-dev, libfribidi-dev, libharfbuzz-dev
xgboost     – make
XML         – libxml2-dev
```

These tools may also help trace the dependency tree for packages. There is an API, but it might just be easiest to look through the JSONs in the repos and copy the dependencies. 

https://github.com/rstudio/r-system-requirements

https://r-universe.dev/sysdeps/
