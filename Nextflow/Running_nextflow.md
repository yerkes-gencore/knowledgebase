# Installing Nextflow

Nextflow requires Java. You can run `java --version` to see what you have installed.
You probably only have to worry about the java versioning if you get errors. 
If you don't have java installed, you can try running these lines,
although there is probably a more sophisticated Java installation procedure we
should follow for the servers in the future. See the nextflow documentation 
for the minimum requirements and suggested installation methods.

```
curl -s "https://get.sdkman.io" | bash
source "~/.sdkman/bin/sdkman-init.sh"
sdk install java 17.0.6-tem
```

Once Java is installed, you can install nextflow by following the documentation.

# Running nextflow

An invocation of a nextflow pipeline may look like the following:

```
nextflow run \
  -latest \
  -c ./nextflow.config \
  --run_dir <your_path> \
  yerkes-gencore/extractions_nextflow \
```

* `nextflow run` the base command

* `-latest` checks public repositories for updates to the workflow and pulls them.
This may not be desirable in every instance. See the 
[Managing workflow versions](#managing_workflow_versions) for more details. 

* `-c ./nextflow.config` specifying an entire config file of parameters. This 
will override any defaults for the pipeline, but will NOT take precedence over
parameters set with the `--` notation.

* `--run_dir` an example of a run parameter being set at the command line

* `yerkes-gencore/extractions_nextflow` the name of the workflow to start. In this
case, the workflow is hosted in github, indicated by the `yerkes-gencore/` prefix.
Nextflow defaults to looking for this workflow on Github. 


# Managing workflow versions

If your workflow is hosted on a public repository, 
`nextflow run <your_workflow>` will automatically pull a copy of the workflow if
it isn't already locally available.

The `-latest` argument can be provided to check the local copy of the pipeline 
against the public repo. If the pipeline is out of date, this flag will ensure
the latest version is executed. You can remove this flag, which will cause the 
execution to warn that you're running an out-of-date pipeline, but will still 
execute the version you have. This could be desirable if their are substantial 
changes to the workflow that you aren't ready to adopt yet and want to keep your
implementation consistent.

If you prefer to not default to using the newest version, you can install 
versions of the pipeline manually using   
`nextflow pull yerkes-gencore/extractions_nextflow`. 
You can also specify specific revisions of the pipeline if you want to revert 
to a previous version. Use `-r` with a version tag such as a commit hash, 
branch name, or release version.