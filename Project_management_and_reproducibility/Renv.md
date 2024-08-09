# Renv

## Setting up renv in a new RStudio project

Renv is an R package that captures versions of packages used in a project. It can help you use different versions of packages for different projects. This is useful for making reproducible workflows, allowing you to jump back to old projects and share projects with other users. 

The directions below should get `renv` up and running for your project quickly, but if you are new to `renv` it's a good idea to read up on how it works and the basic workflow here: https://rstudio.github.io/renv/articles/renv.html

Basically, running `renv::init()` will initialize the infrastructure required by `renv`, `renv::status()` will check which packages are used but not installed. See `?renv::status()` for details how and when to use the other key functions, `renv::restore()`, `renv::install()`, and `renv::snapshot()`.

![Overview of Renv workflow](https://rstudio.github.io/renv/articles/renv.png)


### Set up shared cache

One advantage of Renv is having a cache of packages to avoid having multiple installs of the same package/version. This is especially useful if you want to have multiple users access the project on a shared file system. Assuming you've followed the tutorial to set up renv in your project, you can point the project to a shared library cache via an environmental variable. If you plan to consistently use renv on a shared system, it may be worthwhile to edit the shared cache location as part of your user-level [.Renviron](https://support.posit.co/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf), so you don't have to set it for each project.

So, before initializing, make sure `renv` [knows where to look for our share cache of libraries](https://rstudio.github.io/renv/reference/paths.html).
```
usethis::edit_r_environ()
```

This will open an editor window to edit the .Renviron, which is a bash script that is run when a new R session starts. Add the following two lines if using RStudio server:
```
RENV_PATHS_ROOT='/yerkes-cifs/runs/tools/renv/'
RENV_PATHS_CACHE='/yerkes-cifs/runs/tools/renv/cache'
```

Or if you're using RStudio on your local machine while connected to our server it will look something like this:
```
RENV_PATHS_ROOT='/Volumes/yerkes/genomelab/illumina/runs/tools/renv/'
RENV_PATHS_CACHE='/Volumes/yerkes/genomelab/illumina/runs/tools/renv/cache'
```

Restart R to allow this to take effect. You can check if it worked by running `renv::paths$root()` and `renv::paths$cache()`.

### Make sure R package manager repo is up-to-date

Run the below command in the R console to set the package manager repo to the latest version.

```
options(repos = "https://packagemanager.rstudio.com/all/__linux__/focal/latest")
```

### Initialize renv

To set up renv in a project where it isn't in use yet. Run the following line and follow the prompts.
```
renv::init(bioconductor = TRUE)
```

The `bioconductor=TRUE` argument ensures that renv knows to look for bioconductor packages, otherwise it will just look in CRAN and fail. 

This can take a long time to run at first, as you will have to copy versions of packages used from your local disk to the server. Once they are in the cache/project, your workflow continues like normal. Note that if you want to set up the project to use the shared drive cache, you should set that up before running init, otherwise it will use a project-local cache.

If you're trying to correct a deeply messed up `renv`-enabled project (e.g. it's not using the shared cache), run `renv::deactivate()` to start over entirely.

## Using renv

Once `renv` is set up, run `renv::status()` to check the status of your environment. This will output useful messages with suggestions of what to do if there are any issues that need fixing. For example, once all of the packages used for your project are installed in the `renv` project library (or linked from the cache), you should run `renv::snapshot()` to record the packages and versions used so you can recover the environment with `renv::restore()` if needed.

Once `renv` is set up, you should install pacakges through `renv::install()`. This can handle CRAN, bioconductor and github repos all with this one function and simple syntax, plus it handles the proper workflow caching and lockfile updating for you. 
