## Doublet Removal

Most single-cell technologies are imperfect at isolating a single-cells. 
It is not impossible to have 2 or more cells in the same GEM or well, 
where each cell would be tagged with the same barcode. After sequencing, 
the shared barcode makes all reads appear to have come from one cell. 
This has various negative effects, including obscuring real signal. 
They should be removed when possible. 

Some tools/papers distinguish between two types of doublets:
* Heterotypic doublets have reads from two transcriptionally distinct cells
(e.g. two different cell types)
* Homotypic doublets include transcriptionally similar cells (e.g. two B cells)
Some approaches to doublet removal are more tailored two resolving one or the other.  

### Doublet Finder

[Github](https://github.com/chris-mcginnis-ucsf/DoubletFinder)

#### How it works

1. Preprocess data, including removing low quality cells/clusters, normalizing, clustering, and possibly annotating cell types (for additional functionality).

1. Create simulated doublets in the dataset by averaging cells
2. Process mixed data using a constant Seurat pipeline
3. Cluster mixed data 
4. Predict doublets as cells with high number of artificial neighbors

DoubletFinder can also be supplied with 'Ground Truth' data: 
doublets in your dataset identified by conflicting sets of antibody 
tags in hashed studies (see cell hashing section). This can help seed
the expected doublet rate for your capture. 

DoubletFinder is incorporated in the gencoreSC package. See the 'using-gencoreSC' package for more details on using it in our standard workflow.

#### Runtime considerations

Doublet finder overestimates detectable doublets due to difficulty in identifying homotypic doublets. This can be somewhat remedied by providing cell-type annotations and using them to calculate a lower-bound of doublet rate.
[More info](https://github.com/chris-mcginnis-ucsf/DoubletFinder#doublet-number-estimation)
