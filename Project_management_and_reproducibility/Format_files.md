## Report format files

Template repos for analyses contain paired scripts for each step, termed 'runfile' and 'format'.
The runfile is where the active analysis will occur, often requiring inputs from you to perform
the processing or analysis as necessary. Once all the steps have been completed in the runfile,
you can call `rmarkdown::render` within the runfile to refer to the format file for generating
a report. 

This allows you to separate the computationally intensive steps from the report rendering. You
will not have to rerun the full runfile to knit a report. Using `rmarkdown::render` will pull
all objects from the current environment, so make sure your objects are in their 'final' state.

You can then edit the format file to arrange figures etc. in any order you like. This is much 
faster than re-runing the whole runfile for each knit, allowing quick iterations of aesthetic
tweaks.

An example of the render call:

```{r}
## This only works if all the variables called in the format file 
## are in the current environment. Check the format file to tweak
## aesthetics 
rmarkdown::render(here('analysis_scripts/02_processing_template.format.Rmd'),
                  output_file = '02_processing_report.html',
                  output_dir = here('reports'))
```

The suggested workflow is to name the file something generic in the argument,
e.g. '02_processing_report.html'. That way you don't accidentally overwrite a 'finished' report.
Once you are happy with the report, rename the output to something like 
`<project_number>_<report_contents>_<date>.html`. For example, 
`p23120_Clustering-annotations_2023-10-12.html'
