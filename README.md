# knowledgebase
Recipes, SOPs, notes on best practices. Format inspired by https://github.com/hbc/knowledgebase/.

This repo should be living documentation that is 
updated with alternative methods as we discover them, but should preserve
old methods for posterity and include rationale for changing them. Whenever 
possible, we should include links to papers, repos, vignettes, etc. that support
a practice, and we should attempt to summarize the methods and justifications 
of a particular step. If we explore a procedure that we decide not to implement,
it is worth including it here too to avoid revisiting dead topics and save others
from wasting time. 

## Admin
*Using our servers, data management, etc.*

## Bulk RNA-seq


## Single cell

[Ambient RNA](Single cell/Ambient RNA.md)

[Doublet detection](Single cell/Doublet detection.md)

[Cell cycle regression](Single cell/Cell cycle regression.md)

[Reference based annotation](Single cell/Reference based annotation.md)

[Demultiplexing](Single cell/Demultiplexing.md)


## R/RStudio/RStudio Server


## Nextflow


## Project management and reproducibility

[Dockerized Rstudio](Project management and reproducibility/Dockerized rstudio.md): 
Isolated containers with consistent architecture, R versions, and machine dependencies 
for essential libraries (e.g. DESeq2, Seurat).

[Renv](Project management and reproducibility/Renv.md): Track versions of R 
libraries used for a project and enable a cache of different versions for 
different projects.

