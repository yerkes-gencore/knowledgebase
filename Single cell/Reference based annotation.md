## Mapping reference annotations

Datasets with cell-type annotations can be used to estimate cell-types in your
own data. When possible, you should run multiple reference datasets or mapping methods
and compare results. Cell-types in your data may be missing or scarce in a reference,
causing them to be poorly identified when querying. The package has a few
visualization tools to help compare results from multiple references/methods.

### SingleR

SingleR can map metadata from a reference dataset of bulk or single-cell data.
It compares the expression profile (of all genes by default) of the query set to
the reference to find similarities. This can be done on a per-cell level or
using clusters within the query, which uses the aggregate expression profile. 
Since it can be done on a per-cell level, without much need for processing,
it is easy to use SingleR on multiple captures in a single merged object 
without any integration.

[Vignette](https://bioconductor.org/packages/release/bioc/vignettes/SingleR/inst/doc/SingleR.html)
[Github](https://github.com/dviraran/SingleR)

#### Runtime considerations

SingleR expects both the query and reference to be normalized and log-transformed.
You should not use SCTransform data for SingleR since the normalization does 
not seem to be on a per-cell level [(more on this discussion here)](https://github.com/immunogenomics/harmony/issues/41).

The `de.method` should be set to 'wilcox' for single-cell data ([from vignette](https://bioconductor.org/packages/release/bioc/vignettes/SingleR/inst/doc/SingleR.html)).

### Azimuth

Azimuth is built by some of the same people who work on Seurat. They have a web
interface you can use to do annotations, but you lose some ability to manipulate
inputs and outputs. The same functions used in the web GUI can be accessed through
their R library. It is mostly just a wrapper for Seurat's native reference mapping
functions, but with some optimized parameters. 

Azimuth provides some functions to use any annotated Seurat dataset. The benefit
of using Azimuth over using the Seurat functions directly are convenience and 
reproducibility/consistency. 

Azimuth produces two metrics per cell: prediction score and mapping score. 

[Ref](https://azimuth.hubmapconsortium.org/#Mapping%20QC)

**Mapping score** This value from 0 to 1 reflects confidence that this cell is well represented by the reference.
If your query has a cell population not present in the reference, these will likely
have a poor mapping score. 

**Prediction score** Cell prediction scores range from 0 to 1 and reflect the confidence associated with each annotation. Cells with high-confidence annotations (for example, prediction scores > 0.75) reflect predictions that are supported by multiple consistent anchors. 

A cell may have high mapping score but low prediction score if it is split between
two similar clusters of cells, e.g. CD4 central memory and effector memory. 

A cell with high prediction score but low mapping score is likely near a single 
consistent group of cell-types, but not within them. Since no other cell-type neighborhoods
are nearby, there are no conflicting prediction scores. See [Ref](https://azimuth.hubmapconsortium.org/#Mapping%20QC) for more info. 

[Github](https://satijalab.github.io/azimuth/index.html)
[Website](https://azimuth.hubmapconsortium.org/)

#### How it works

```
Here, we introduce “weighted-nearest neighbor” (WNN) analysis, an analytical framework to integrate multiple data types measured within a cell and to obtain a joint definition of cellular state. Our approach is based on an unsupervised strategy to learn cell-specific modality “weights,” which reflect the information content for each modality and determine its relative importance in downstream analyses. 
```
[Ref](https://www.cell.com/cell/fulltext/S0092-8674(21)00583-3)

Briefly (and perhaps naively), it works by 'anchor' cells with similar transcriptional profiles
across the datasets. These anchors are used to normalize differences between the
datasets, which can then be mapped in shared space. Annotations are then predicted
by the annotations of a cell's nearest neighbors from the reference dataset. 

gencoreSC has a helper function to create a custom reference dataset for use
with Azimuth. See the 'using-gencoreSC' vignette for more information.

#### Runtime considerations

```
We have observed that the results (both for visualization and annotation) are very similar when mapping individual batches separately, or combined together. This is because Azimuth can successfully remove batch effects between query and reference cells, even when there are multiple query batches. However, as discussed further below, the results of QC metrics may change. For example, cells from certain batches sometimes receive high mapping scores when the batches are mapped separately but receive low mapping scores when batches are mapped together, as the batch effect represents a source of heterogeneity in the query that is removed by Azimuth.
```

* Reference datasets can be any(?) size, but the web app subsamples to 5000 cells
for resource considerations. In practice, I've used references with 40,000+ cells.
It just takes a little longer, but it might be worth it to preserve niche cell types.

* Creating a reference can be a little tricky. The wrapper function should 
simplify things, but hasn't been super robustly tested. One known consideration
is you need to use at least 50 dimensions for PCA (the default in the wrapper is 
set to 50)

### GencoreSC visualization tools

`extractTopRefMapResults()` will give you a table of the top cell-type predictions
per cluster

`referenceMappingOutcomesFacetPlot()` will give you a more comprehensive look at
all predicted cell-types and the associated prediction scores for each cluster.
