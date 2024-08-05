# Using git and github with RStudio server

## Identify yourself to git

Add your email and username to the global config (if you hadn't mounted it to the container):

```
git config --global user.name "your-git-username"
git config --global user.email "your-git-email@gmail.com"
```

## Add the project directory to 'safe directories'

When you open a project in RStudio in a container for the first time, you may not see the git tab in the Enrivonment/History pane. This is because you need to add the current directory to the 'safe-directories' list in the global git config, like so in the RStudio terminal:

```
git config --global --add safe.directory /yerkes-cifs/runs/analyst/micah/templates/scRNAseq_template # But change the path to your project directory
```

After that, quit (i.e. restart) the RStudio session and the git tab should appear!

When in doubt, you can also find the correct command by running `git status` in the RStudio terminal, which will print out the above line to copy and paste.

By default, the 'global' git config inside a docker/podman container is stored in `/root/.gitconfig` and is set to the default settings (unless you mounted that file manually when creating the container, which is probably good practice).

## Install gh and yous gh auth login to authenticate github credentials

Install the github commandline tool `gh` (if this wasn't already done with the Dockerfile).

```
sudo apt-get update
sudo apt-get install gh
```

Then login to github by running the following command and following the prompts. This may require two-factor authentication. When asked, I recommend using HTTPS rather than SSH as I don't think RStudio plays nicely with ssh. 
```
gh auth login
```

After following the prompts, you should be able to pull, push etc. to github for some reasonable length of time (as yet unclear to me). You may need to re-authenticate periodically but this is much less cumbersome than handling GITHUB_PATs or other alternatives.

## How to access an existing analysis project or set up a new one

For most single cell or bulk analyses, it's best to create a new repo from the `yerkes-gencore/scRNAseq_template` repo or `yerkes-gencore/Bulk_template` repo on github first. Then you can either open RStudio and start a new project from this remote repo (RStudio will clone the repo for you), or you can clone the repo first and then create an RStudio project in that repo afterwards. Both work fine. For detailed instructions on how to do this see https://happygitwithr.com/usage-intro.

In general, it's best to clone the repo into a separate location from the `/yerkes-cifs/runs/Analysis` directory where the `data` and `processing` directories are so that if multiple people need to work on the same repo they will clone it into their own remotes rather than opening up the same project and messing with eachother's git history, `renv` setups etc. This is exactly the situation that Git was designed for.

## Git/github/R troubleshooting

I recommend running `usethis::gitsitrep()` in the R console when in doubt about the status of your git/github credentials or troubleshooting when first opening a project that someone else initialized, like below.

## Colloborating on the same repo

***TLDR: You can skip all this hassle if you remember to give the `yerkes-gencore/gencore` github team `Maintainer` access when you first initialize the repo.***

If user #1 starts a repo and user #2 clones it and attempts to push changes, they may get an error. When running `usethis::gitsitrep()` user #2 may see something like this:
```
── GitHub project 
• Type = 'theirs'
• Host = 'https://github.com'
• Config supports a pull request = FALSE
• origin = 'yerkes-gencore/p23224_Matthew_Analysis' (can not push)
• upstream = <not configured>
• Desc = The only configured GitHub remote is 'origin', which
  you cannot push to.
  If your goal is to make a pull request, you must fork-and-clone.
  `usethis::create_from_github()` can do this.
```

This mprobably means that Person #1 hasn't given Person #2 write permission for the repo. Person #1 can do this on github by going to the repo, clicking `Settings`, then on the sidebar under `Access` click `Collaborators and teams`, then `Add people` and add Person #2's username and give them (at least) `Maintainer` access if it's someone in the core or `Write` access if it's some other collaborator you trust.
