## Report format files

You can utilize the runfile:formatfile workflow to manage the aesthetics
of a rendered report separate from the major computational intensive
lines. Have one script generate all the environment variables you need
for the report, then have a separate report with the markdown syntax and plots.
This allows you to quickly render reports to make small aesthetic changes without
waiting for the processing lines to run again. It also allows you to present
data in a different order than you generated it. 
E.g:

```{r}
## This only works if all the variables called in the format file 
## are in the current environment. Check the format file to tweak
## aesthetics 
rmarkdown::render(here('analysis_scripts/02_processing_template.format.Rmd'),
                  output_file = '02_processing_report.html',
                  output_dir = here('reports'))
```
