# Template repos

Template repos are used to initialize skeletons for new analysis projects. They include standard directory structures and common scripts/files used for analyses.

There are two template repos: one for [single cell](https://github.com/yerkes-gencore/scRNAseq_template) and one for [bulk RNA](https://github.com/yerkes-gencore/bulk_template) analyses.

When you are starting a new project with a template, you can follow this workflow:

1)  Go to the github page for the template repository
2)  Click the `Use this template` button in the top right of the webpage (it should be green). Select `Create a new repository` from the dropdown options.
3)  Name the new repository for your project. You should not need to include all branches.
4)  Click `create repository`
5)  Clone this repo to your server/local machine as you would normally.
6)  Follow the repository README to get started using the templates. They usually have some form of config files that you'll need to edit to get the project started.

It's also a good idea to initialize an `renv` library when you first start working on the project in R. See the `renv` knowledgebase page for more info.
