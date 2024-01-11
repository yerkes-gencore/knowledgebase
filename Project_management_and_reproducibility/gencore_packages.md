# Gencore packages

Standardized code for common analyses is held in R packages hosted on github.
There are currently two packages: one for [bulk](https://github.com/yerkes-gencore/gencoreBulk) and one for [single-cell](https://github.com/yerkes-gencore/gencoreSC). They can be installed like normal github R packages
using a library like `remotes::install_github()` or `devtools::install_github()`.

Gencore packages tend to require many other packages as dependencies since they hold code for all parts
of an analysis and have wrappers that use standard libraries (e.g. Seurat and DESeq2). While a `remotes` or
`devtools` install should resolve all the dependencies, there are sometimes issues installing one or two
required libraries. You should try directly installing any failed libraries first, then re-installing the
gencore library. This often is enough to resolve dependency issues. If directly installing a dependency fails,
you may need certain system libraries. The gencore Docker images aim to have all the system requirements needed
to install these packages. See [Dockerized Rstudio](Project_management_and_reproducibility/Dockerized_Rstudio.md) for more info.

Once installed, the packages behave like normal R packages. You can call `?<function>` to pull up help
documentation for a function. All functions *should* have examples for how to use them as part of the documentation.
The packages have functions for all parts of analyses from loading data, processing, analyzing, visualizing, and exporting. The packages are used in the scripts in the [template repos](Project_management_and_reproducibility/template_repos.md) which can help guide you through when to use the gencore package functions. 

Ideally, any functions that represent standard procedure for analyses should be added to the package. If you find yourself copying and pasting functions from an old analysis, greatly consider taking the time to add it to the package so others can use it. This requires some generalization of functions developed for one project to be useable in other contexts. See the READMEs in the package repos for more info on how to contribute to the packages. Writing functions for R packages is only slightly different than writing them for general R, and tools like `roxygen` and `RMDCheck` greatly facilitate writing documentation and bulletproof code. See [this tutorial](https://kbroman.org/pkg_primer/) for further reading. 

## Contributing to packages

Please consider reading [this tutorial](https://kbroman.org/pkg_primer/) to familiarize yourself with authoring packages. This section is here to give a short overview of the procedure to show you it's not that scary and inspire you to make contributions.

### Writing functions for packages

The syntax of some code, mainly things relating to tidy evaluation, are slightly different within functions. In a normal script, code like `data %>% select(Pvalue)` might be valid, but in a function you may write that as `data %>% select(.data[['Pvalue']])`.

Try to keep the functions as generalizeable as possible. For example, if you're writing a visualization function that requires an output table from say a differential expression test, don't hardcode the name of the 'pvalue' column based on a specific output. Create a variable that allows the user to specify the name of the pvalue column in case they use different upstream processes to produce the output. As we change our methods and which tools we use, we want our libraries to require as little updating as possible. Extending the example above, instead of `data %>% select(.data[['Pvalue']])`, you might write `data %>% select(.data[[p_val_col]])`, where `p_val_col` is an argument to the function who's default value is 'Pvalue'. 

Functions that come from other packages have to be declared as such. For something like `data %>% select(.data[[p_val_col]])`, you may write `data %>% dplyr::select(.data[[p_val_col]])`, or otherwise specifically import
the package/function in the roxygen documentation.

1. Clone this repo into an isolated working directory (we suggest .../illumina/runs/analyst/<your_name>). You'll need a copy no one else will edit while you're working.
2. Fetch updates from the github repo via git pull
3. Create a new branch from the devel branch via git branch <new_branch> origin/devel. Be sure to switch to the new branch to make changes via git switch <new_branch>.
4. Make a new file in the `R` folder for your function (or edit an existing one). The filename does not have to be the same name as your function, and you can add multiple functions to the same file. In general, try to only keep functions
related to the same step in the same file, and make a new file for each major function/feature. 
5. Write your code. See the guidelines above for writing good package code.
6. When you think you're finished with your function, test it on one of your projects. We don't have many tests
built in to the package since our functions often rely on large intermediate objects. The major testing should be done 'manually', but later steps will check for any syntax issues.
7. When you're satisfied with the code, you can generate documentation for it. With the cursor inside your function,
go to the top bar of your rstudio window where you have File, Edit, Code etc. Select `code > Insert Roxygen skeleton`. This will autogenerate some documentation based on the parameters defined. Fill out the details here.
8. You will also need to declare any imports from other libraries. Check the `Description` file in the base of the package repo to see if the package you need is already imported. If not, add it. If it is not hosted on CRAN or Bioconductor, you may need to add the remote host in the Description file.
9. Add examples to the roxygen documentation. It's generally easiest to specify `dontrun` for your examples, since we don't have any example data distributed with the package. If you specify don't run for your examples, they don't actually
need to 'work', they can just serve as guides for filling in the arguments or how to chain multiple functions together. 
10. Add an `@returns` line to your documentation. There isn't a specific syntax for this, but the line is required.
11. Generate the documentation markdown by running `devtools::document()` in the console. 
12. When you're finished making changes, be sure to run `devtools::check()` to ensure there are no major issues. Ideally the check returns no issues, but in practice notes are not a big deal. Warnings should be dealt with, errors must be dealt with. When you're satisfied with the changes, push the changes to Github.
13. Open a pull request to merge your new branch into the devel branch. Ideally someone else should review the changes before merging, and the automated RMD Check action should pass.
14. Once the feature has been merged into the devel branch, you should safely delete that branch with `git branch -d <your-branch>`. You can always recover it with `git checkout <your-branch> <sha>`, where <sha> is the identifying SHA string for the commit at the tip of that branch (you can always find that in your git history).
15. Once sufficient changes have been made to the devel branch to prompt an update to the package, modify the package description to update the version.
16. Release a new version of the package.

