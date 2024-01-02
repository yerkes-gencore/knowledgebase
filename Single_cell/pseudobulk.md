# Why bother with pseudobulk?

Besides the fact that `Seurat::FindMarkers` can't handle any contrast more complex than a simple pairwise comparison of two cell populations, such methods also have inflated FDR biased towards highly expressed genes and have poorer type 2 (false negative) control than pseudobulk.

Here are the details:

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

If we had to give a rule of thumb, it would be something like, "Shoot for at least 5-7 biological replicates per group because three-quarters of at least one of your groups will likely fail".
