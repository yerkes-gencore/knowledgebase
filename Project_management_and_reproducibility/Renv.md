[See the site for full details](https://rstudio.github.io/renv/articles/renv.html)

Renv is an R package that captures versions of packages used in a project. It can help you use different versions of packages for different projects. This is useful for making reproducible workflows, allowing you to jump back to old projects and share projects with other users. 

One advantage of Renv is having a cache of packages to avoid having multiple installs of the same package/version. If you plan to consistently use renv on a shared system, it may be worthwhile to edit the shared cache location as part of your user-level .Renviron, so you don't have to set it for each project. `usethis::edit_r_environ()` can help you edit that file.
This is especially useful if you want to have multiple users access the project on a shared file system. Assuming you've followed the tutorial to set up renv in your project, you can point the project to a shared library cache via an environmental variable.
[more info](https://support.posit.co/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf)

Edit .Renviron

`RENV_PATHS_ROOT='/Volumes/yerkes/genomelab/illumina/runs/tools/renv/'`

Or .Rprofile

`Sys.setenv(RENV_PATHS_ROOT = "/Volumes/yerkes/genomelab/illumina/runs/tools/renv")`

To use renv, run `renv::init(bioconductor=TRUE)` in a project opened in rstudio. The `bioconductor=TRUE` argument ensures that renv knows to look for bioconductor packages, otherwise it will just look in CRAN and fail. This can take a long time to run at first, as you will have to copy versions of packages used from your local disk to the server. Once they are in the cache/project, your workflow continues like normal. Note that if you want to set up the project to use the shared drive cache, you should set that up before running init, otherwise it will use a project-local cache.

Once `renv` is installed, you should install pacakges through `renv::install()`. This handles the proper workflow caching and lockfile updating for you. 
