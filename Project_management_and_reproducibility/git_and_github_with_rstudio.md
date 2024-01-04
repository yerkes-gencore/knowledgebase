# Using git and github with RStudio server

### TL;DR
*Note: If you're struggling with git/github/RStudio, https://happygitwithr.com is a great place to learn the basics and* `usethis::git_sitrep()` *will help diagnose your session-specific problems and guide you towards fixing them.*

## Helpful packages

The RStudio server image is built with git already installed, but there are a few things you need to do to connect with your github account and start pulling, commiting and pushing.

A few packages are handy for working with git in RStudio. If `usethis` and `gitcreds` aren't already installed do that before proceeding. If you're already in an existing project with `renv` activated, these are installed (unless `renv` isn't pointing to the global cache).

```
install.packages("usethis")
install.packages("gitcreds")
```

## Identify yourself

Tell git who you are:
```
usethis::use_git_config(user.name = "micahpf", user.email = "micahpfletcher@gmail.com")
```

## Set up github PAT

### Generate a token
To connect with github via RStudio (to pull or push to origin or to install private libraries) you will need to have a github personal access token (PAT) stored in the Git credentials store. This is basically a password with a specific set of permissions and a limited lifetime. Thus it's best not to store is as plain text somewhere where someone other than you can find it. Once you have it in the Git credentials store, you won't be asked to enter it in; Git/R/RStudio will automatically use your PAT.

First, generate a PAT with the right permissions scopes to allow RStudio to do what it needs to do. The easiest way to do this is to call
```
usethis::create_github_token()
```

Which will result in the following message, and will redirect you to the URL where you can name your PAT. If you get an error about popup-blockers or something you aren't automatically re-directed, just copy and paste the URL.
```
• Call `gitcreds::gitcreds_set()` to register this token in the local Git credential store
  It is also a great idea to store this token in any password-management software that you use
✔ Opening URL 'https://github.com/settings/tokens/new?scopes=repo,user,gist,workflow&description=DESCRIBE THE TOKEN\'S USE CASE'
```

Name your PAT something useful to signify the purpose of the PAT and where it will be stored, probably something like RStudio_server or MacBookPro2023. The idea is to only have one PAT for one machine/purpose so you don't have to track down outdated/conflicting PATs if it expires. When it is about to expire, you will get an email. Just go back to your PAT settings on github and generate a new token for the same PAT name with all the same premission scopes, which is better than creating new names and getting yourself confused with a long list of interfering/outdated PATs.

### Store your PAT for current and future use

One you've generated the token, copy it to your clipboard, return to RStudio and run:
```
gitcreds::gitcreds_set()
```
And when prompted, paste your PAT token. Now it's stored until you quit the R session or switch projects (I think). I think this works better on non-Linux / non-RStudio server systems, where it stores the PAT more intelligently across sessions and projects, but I haven't figured out a way to do that for RStudio server's Linux build. Until we figure that out, it's good idea to save it somewhere secure so you don't have to keep generating new ones everytime you switch between projects or start a new R session. For example, a password-protected plaintext file on your local machine. 🤷‍♂️

It's best not to store the PAT token as an environmental variable in `~/.Renviron` because this is 1. not secure and 2. it's really easy to accidentally have an old expired PAT there and not be able to track it down. R will load that expired PAT on start and cause problems. See the [`usethis` article on git credentials](https://usethis.r-lib.org/articles/articles/git-credentials.html) for details.

## Git situation report

Now that you have your PAT setup and stored, you should be ready to push and pull to origin or install private github repo packages.

To check that everything is set up right, run `usethis::git_sitrep()` (i.e. "git situation report"). If everything is configured correctly you will get a long message with lots of details, something like this:

```

── Git global (user) 
• Name: 'micahpf'
• Email: 'micahpfletcher@gmail.com'
• Global (user-level) gitignore file: '~/.gitignore'
• Vaccinated: TRUE
ℹ Defaulting to 'https' Git protocol
• Default Git protocol: 'https'
• Default initial branch name: <unset>

── GitHub user 
• Default GitHub host: 'https://github.com'
• Personal access token for 'https://github.com': '<discovered>'
• GitHub user: 'micahpf'
• Token scopes: 'gist, repo, user, workflow'
• Email(s): 'micahpfletcher@gmail.com (primary)', 'mpfletc@emory.edu'

── Active usethis project: '/yerkes-cifs/runs/analyst/micah/Analysis/2023_Analyses/p21242_Satish_UM5/p21242_Satish_UM5_Analysis' ──

── Git local (project) 
• Name: 'micahpf'
• Email: 'micahpfletcher@gmail.com'
• Default branch: 'main'
• Current local branch -> remote tracking branch:
  'main' -> 'origin/main'

── GitHub project 
• Type = 'ours'
• Host = 'https://github.com'
• Config supports a pull request = TRUE
• origin = 'yerkes-gencore/p21242_Satish_UM5_Analysis' (can push)
• upstream = <not configured>
• Desc = 'origin' is both the source and primary repo.
  
  Read more about the GitHub remote configurations that usethis supports at:
  'https://happygitwithr.com/common-remote-setups.html'
```

If something went wrong you will see a lot of (informative and helpful) messages with a red dot next to them. It's a good idea to start with running `usethis::git_sitrep()` anytime you encounter a git problem in RStudio because they give lots of helpful advice on how to fix problems and link to detailed vignettes and articles on how this stuff works.

In general, keep following their advice and rerunning `usethis::git_sitrep()` until you see no more messages with red dots. It will save yo ua lot of time in the future troubleshooting mysterious problems.

## RStudio not recognizing that the project is git-tracked

If you try running git status in RStudio's terminal you will likely get an error looking something like this:

```
fatal: detected dubious ownership in repository at '/yerkes-cifs/runs/analyst/micah/templates/scRNAseq_template'
To add an exception for this directory, call:

        git config --global --add safe.directory /yerkes-cifs/runs/analyst/micah/templates/scRNAseq_template
```

If so, just run that last line in the RStudio terminal, then Quit Session (and restart a new session) and it should be visible again. In general, if a git command isn't working in the RStudio terminal, it probably won't work in the GUI, that's a better place to troubleshoot than a separate terminal window.

## How to access an existing analysis project or set up a new one

For most single cell or bulk analyses, it's best to create a new repo from the `yerkes-gencore/scRNAseq_template` repo or `yerkes-gencore/Bulk_template` repo on github first. Then you can either open RStudio and start a new project from this remote repo (RStudio will clone the repo for you), or you can clone the repo first and then create an RStudio project in that repo afterwards. Both work fine. For detailed instructions on how to do this see https://happygitwithr.com/usage-intro.

In general, it's best to clone the repo into a separate location from the `/yerkes-cifs/runs/Analysis` directory where the `data` and `processing` directories are so that if multiple people need to work on the same repo they will clone it into their own remotes rather than opening up the same project and messing with eachother's git history, `renv` setups etc. This is exactly the situation that Git was designed for.



