# Why bother with pseudobulk?

Besides the fact that `Seurat::FindMarkers` can't handle any contrast more complex than a simple pairwise comparison of two cell populations, such methods also have inflated FDR biased towards highly expressed genes and have poorer type 2 (false negative) control than pseudobulk.

[Orchestrating Single Cell Analysis](https://bioconductor.org/books/3.16/OSCA.multisample/multi-sample-comparisons.html#creating-pseudo-bulk-samples) summarizes the rationale behind "pseudo-bulking":

>- Larger counts are more amenable to standard DE analysis pipelines designed for bulk RNA-seq data. Normalization is more straightforward and certain statistical approximations are more accurate e.g., the saddlepoint approximation for quasi-likelihood methods or normality for linear models.
>- Collapsing cells into samples reflects the fact that our biological replication occurs at the sample level (Lun and Marioni 2017). Each sample is represented no more than once for each condition, avoiding problems from unmodelled correlations between samples. Supplying the per-cell counts directly to a DE analysis pipeline would imply that each cell is an independent biological replicate, which is not true from an experimental perspective. (A mixed effects model can handle this variance structure but involves extra statistical and computational complexity for little benefit, see Crowell et al. (2019).)
>- Variance between cells within each sample is masked, provided it does not affect variance across (replicate) samples. This avoids penalizing DEGs that are not uniformly up- or down-regulated for all cells in all samples of one condition. Masking is generally desirable as DEGs - unlike marker genes - do not need to have low within-sample variance to be interesting, e.g., if the treatment effect is consistent across replicate populations but heterogeneous on a per-cell basis. Of course, high per-cell variability will still result in weaker DE if it affects the variability across populations, while homogeneous per-cell responses will result in stronger DE due to a larger population-level log-fold change. These effects are also largely desirable.

See details on the performance advantages of pseudobulk over single-cell based DE methods below:

## Single-cell differential expression methods are prone to false discoveries

Single-cell DE methods (e.g. all `Seurat:FindMarkers` methods) and mixed models (such as `MAST` with random effect for indiviual) failed to control false discoveries in a systemic benchmark of differential expression in single-cell transcriptomics where the ground truth DE results ([Squair et al. 2021](https://www.nature.com/articles/s41467-021-25960-2)).

Single-cell DE methods are biased towards highly expressed genes. Squair et al. showed this across 18 "gold standard" studies with matched bulk and single-cell samples.
### Fig. 1: A systematic benchmark of differential expression in single-cell transcriptomics.
![Single-cell DE methods are biased towards highly expressed genes.](https://media.springernature.com/full/springer-static/image/art%3A10.1038%2Fs41467-021-25960-2/MediaObjects/41467_2021_25960_Fig2_HTML.png?as=webp)

Single-cell DE methods can even produce false discoveries in the absense of any biological difference. Squair at al. showed this using simulation studies with varying degrees of heterogenity between replicates, and with replicates randomly assigned to either a 'treatment' or 'control' group.
### Fig. 2: Single-cell DE methods are biased towards highly expressed genes.
![False discoveries in single-cell DE.](https://media.springernature.com/lw685/springer-static/image/art%3A10.1038%2Fs41467-021-25960-2/MediaObjects/41467_2021_25960_Fig4_HTML.png?as=webp)

The advantage of pseudobulk methods (for simple experiments) comes largely from the procedure of aggregating cells, not from some other property of the popular analytical frameworks developed for bulk. When the DESeq2, edgeR and limma are applied to datasets where pseudobulk aggregation has been "disabled", i.e. they are run on individual cells, they lose their advantage over single-cell methods:
### Fig. 3: DE analysis of single-cell data must account for biological replicates.
![DE analysis of single-cell data must account for biological replicates.](https://media.springernature.com/lw685/springer-static/image/art%3A10.1038%2Fs41467-021-25960-2/MediaObjects/41467_2021_25960_Fig3_HTML.png?as=webp)

## Pseudobulk methods out-perform single-cell mixed modeling methods

Some have proposed mixed models modelling single cell expression with replicate as a random effect ([Zimmerman et al. 2021](https://www.nature.com/articles/s41467-021-21038-1)). 

They argue that pseudobulk methods over-estimate their type 1 error rate (i.e. FDR) above what is actually observed and thus are too conservative. However, **pseudobulk methods have the lowest type 2 error (false negative) rate of any of the methods tested** ([Murphy & Skene 2022](https://www.nature.com/articles/s41467-022-35519-4)).

The supposed superiority of mixed models found by Zimmerman et al. based on type 1 error isn't true because they didn't account the superior performance of pseudobulk in terms of type 2 error rates (Murphy & Skene 2022).

Interestingly, the performance of two-part hurdle models (used by `MAST`) decreased with increasing numbers of cells, whereas pseudobulk methods increased in performance as numbers of cell increased (Murphy & Skene 2022).

### Fig. 1: Performance of the analysed models.
![Performance of the analysed models.](https://media.springernature.com/lw685/springer-static/image/art%3A10.1038%2Fs41467-022-35519-4/MediaObjects/41467_2022_35519_Fig1_HTML.png?as=webp)

**TLDR** `Seurat::FindMarkers()` is called "FindMarkers" for a reason. If you want to detect differential expression across samples/treatments/conditions/genotypes, use pseudobulk.

## But I don't have enough samples to do pseudobulk!

Then your analysis is 

- preliminary and/or
- you need to increase your sample size or
- redirect your efforts away from across-sample differential expression (e.g. end at identifying cell types).

If you have fewer than 2 replicate per group, pseudobulk statistics is technically impossible and any inference you draw will be preliminary at best. Two replicates is technically possible with `limma`/`edgeR` but practically still only preliminary. Would you really trust a PCA with only two samples in a group? Just two tossed of a loaded die?

Three is the absolute bare minimum but more replicates and fewer groups is advised if you want any hope of your DE analysis to be reproducible.

***

# How to run a pseudobulk analysis with limma/edgeR

Here are a collection of ideas and links that I've come across while developing the pseudobulk analysis for the p21242_Satish project. See [07-T+ILC-pseudobulk_P11CvsOVA-runfile.Rmd](https://github.com/yerkes-gencore/p21242_Satish_UM5_Analysis/blob/4b54113429b3cefb2e9703c5bf4196725ffd5436/analysis_scripts/07-T%2BILC-pseudobulk_P11CvsOVA-runfile.Rmd#L967) for a full working example of the pipeline I arrived at.

## Pre-pseudobulking quality control

Before pseudobulk DE, you need a dataset with multiple biological replicates per factor level of interest and with cells labeled as confidently as you can with the cell types of interest.

*[to be continued...]*

### Examine cell counts by sample, cull abberant samples


### Define clusters of interest


### Define contrasts of interest


### Check sample sizes by contrast


### Decide which samples and clusters to drop


## Pseudobulking quality control

### Create pseudobulk object


### Filter genes with low expression


### Check library sizes of pseudobulk samples


### Plot PCA


## Pseudobulk DE quality control

### Plot group-wise mean-variance trends using `voomByGroup()` (optional)


### Run `edgeR::voomLmFit()`


### Check MD plots


### Check p-value distributions


## Pseudobulk DE results

### Summarize DEG counts


### Wrangle, write and present results tables








If we had to give a rule of thumb, it would be something like, "Shoot for at least 5-7 biological replicates per group because three-quarters of at least one of your groups will likely fail".
