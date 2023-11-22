Dockerized sessions of Rstudio ensure a reproducible architecture for all analyses. 
There is a dockerfile for the gencore Rstudio image at
https://github.com/yerkes-gencore/rstudio-server, or even better yet at
https://hub.docker.com/repository/docker/dgratz100/gencore-singlecell-rstudio/general.

Using the gencore dockerized Rstudio
allows use of the Renv cache to avoid re-downloading packages in each container (see the
next session). We try to keep the dockerfile minimal, but if there are linux dependencies
or other installations that are useful, consider updating the dockerfile for 
full reproducibility. 

You can build the image from the dockerfile using Docker (or Podman)

```
cd /yerkes-cifs/runs/tools/rstudio-server/
git pull ## make sure the dockerfile is up-to-date!
podman build -t gencore/rstudio:<your r version here> .
```

or by just pointing to the dockerhub version

```
podman build dgratz100/gencore-singlecell-rstudio
```

then you can run the container (ideally behind a screen or other session manager
to avoid random detachments). It can be useful to set `ROOT=TRUE` in case you 
need to install linux dependencies from the terminal.

```
podman run -e PASSWORD=password -e ROOT=TRUE -p 8787:8787 dgratz100/gencore-singlecell-rstudio
```

Note that the port number may need to change to avoid conflicts with other users, 
but you also may need to allow that port through the firewall if it has not been
already. The following command will allow the port through, or tell you if
it already is. the 'tcp' specification is the protocol needed to use rstudio server
through the port.

```
sudo firewall-cmd --add-port=8787/tcp
```

For some unknown reason, rstudio server sessions don't seem
to recognize git tracking set up not through rstudio server.
So if you want to use rstudio's built in git interface,
you'll have to create a new project from a git tracked repo,
rather than creating the git tracked repo first and creating
a new project later.

## Mounts

You will likely want to just mount the whole server in the same style as the actual server.
This will keep filepaths consistent between the server and the dockerized image, which
is especially relevant for symlinks or paths in your code. 

`-v /yerkes-cifs:/yerkes-cifs`

You will also likely want to have an `.Renviron` file that is mounted with
your containers. This can store variables like your github PAT and 
Renv shared cache path (see Renv section) across sessions and projects.

`-v <path_to_saved_configs/.Renviron:/root/.Renviron`

The path for these user level mounted

The dockerized rstudio also has issues with editing the ~/.local file, not sure why. You may have to mount folders there as necessary to work with things like `SeuratData`, or manually chmod and create the folders from the terminal as sudo. 