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

[Ambient RNA](Single_cell/Ambient_RNA.md)

[Doublet detection](Single_cell/Doublet_detection.md)

[Cell cycle regression](Single_cell/Cell_cycle_regression.md)

[Reference based annotation](Single_cell/Reference_based_annotation.md)

[Demultiplexing](Single_cell/Demultiplexing.md)

[Pseudobulk](Single_cell/pseudobulk.md)


## R/RStudio/RStudio Server

## Nextflow

[Running nextflow](Nextflow/Running_nextflow.md)

## Project management and reproducibility

[Dockerized Rstudio](Project_management_and_reproducibility/Dockerized_Rstudio.md): 
Isolated containers with consistent architecture, R versions, and machine dependencies 
for essential libraries (e.g. DESeq2, Seurat).

[Renv](Project_management_and_reproducibility/Renv.md): Track versions of R 
libraries used for a project and enable a cache of different versions for 
different projects.

[Format files](Project_management_and_reproducibility/Format_files.md): Workflow
for rendering HTML reports.

[Git and GitHub with RStudio (server)](Project_management_and_reproducibility/git_and_github_with_rstudio.md): Getting git credentials setup in RStudio server, troubleshooting common git/GitHub/RStudio problems, and creating new gencore analysis projects from templates.

## Study designs

[Cancer exome](study_designs/Cancer_exome.md): Detecting mutations driving cancer

[Cancer fusions](study_designs/Cancer_fusions.md): Detecting RNA fusions in
tumor samples.

[TCR Analysis](study_designs/TCR_Analysis.md)

## Biology

[Orthologous gene symbols](Biology/orthologous_gene_symbols.md): Finding the corresponding gene symbol across species (e.g. mouse -> human, human -> macaca mulatta)

