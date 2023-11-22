## Ambient RNA contamination

"In droplet based, single cell RNA-seq experiments, there is always a certain amount of background mRNAs present in the dilution that gets distributed into the droplets with cells and sequenced along with them. The net effect of this is to produce a background contamination that represents expression not from the cell contained within a droplet, but the solution that contained the cells.

This collection of cell free mRNAs floating in the input solution (henceforth referred to as “the soup”) is created from cells in the input solution being lysed. Because of this, the soup looks different for each input solution and strongly resembles the expression pattern obtained by summing all the individual cells." taken from [SoupX vignette](https://rawcdn.githack.com/constantAmateur/SoupX/204b602418df12e9fdb4b68775a8b486c6504fe4/inst/doc/pbmcTutorial.html)

Soup should at worst decrease power in detecting DEG due to shrinking LFC estimates,
but shouldn't impact highly expressed genes ([Advanced Single-Cell Analysis with Bioconductor](http://bioconductor.org/books/3.16/OSCA.advanced/droplet-processing.html#removing-ambient-contamination)).
Soup may be a greater problem in more complex / bigger / multiplexed 
protocols ([Multi-Sample Single-Cell Analyses with Bioconductor](http://bioconductor.org/books/3.16/OSCA.multisample/ambient-problems.html#ambient-problems)). Tumor and low-viability cells are likely to have more ambient RNA [SoupX github](https://github.com/constantAmateur/SoupX)

Relevant tools

* `SoupX`
* `DropletUtils::removeAmbience()`

### SoupX

[Github](https://github.com/constantAmateur/SoupX):

```
Even if you decide you don't want to use the SoupX correction methods for whatever reason, you should at least want to know how contaminated your data are... 
In our experience most experiments have somewhere between 2-10% contamination.
```

[Vignette](https://rawcdn.githack.com/constantAmateur/SoupX/204b602418df12e9fdb4b68775a8b486c6504fe4/inst/doc/pbmcTutorial.html):
```
It is worth considering simply manually fixing the contamination fraction at a certain value. This seems like a bad thing to do intuitively, but there are actually good reasons you might want to. When the contamination fraction is set too high, true expression will be removed from your data. However, this is done in such a way that the counts that are most specific to a subset of cells (i.e., good marker genes) will be the absolute last thing to be removed. Because of this, it can be a sensible thing to set a high contamination fraction for a set of experiments and be confident that the vast majority of the contamination has been removed.

Even when you have a good estimate of the contamination fraction, you may want to set the value used artificially higher. SoupX has been designed to be conservative in the sense that it errs on the side of retaining true expression at the cost of letting some contamination to creep through. Our tests show that a well estimated contamination fraction will remove 80-90% of the contamination (i.e. the soup is reduced by an order of magnitude). For most applications this is sufficient. However, in cases where complete removal of contamination is essential, it can be worthwhile to increase the contamination fraction used by SoupX to remove a greater portion of the contamination.

Our experiments indicate that adding 5% extra removes 90-95% of the soup, 10% gets rid of 95-98% and 20% removes 99% or more.

...

...mitochondrial genes are over represented in the background compared to cells, presumably as a result of the soup being generated from distressed cells.
```

SoupX is incorporated in the gencoreSC package. See the 'using-gencoreSC' package for more details on using it in our standard workflow.

#### How it works

Input

* unfiltered counts matrix
* filtered count matrix (empty drops removed)
* preliminary clustering

Process

* Find genes specific to clusters that are also highly expressed in empty cells
* Look at expression of those genes in non-expressing clusters 
  + not super clear, is this clusters of empty cells? 
* Contamination is calculated on a per-cell basis for all gene/cluster combinations
* Update global posterior contamination estimate from observations & prior
* Report contamination fraction as maximum of posterior distribution
* Update counts matrix based on contamination fraction, trying to preserve expression and variability in clusters that have 'true' expression of the gene

#### Runtime considerations

SoupX should be performed on a per-channel basis.

Requires clustering information, though it claims to be 'not strongly sensitive to the clustering used',
so the default clustering from Cellranger is sufficient

`roundToInt` parameter of `adjustCounts()` is stochastic and is not recommended by the authors.

Has wrapper function for pulling in all necessary 10x data, but it doesn't seem
to work with Cellranger Multi outputs, so you have to manually load them in.

Genes can be manually specified rather than automatically detected, but this 
is more involved and requires some knowledge of the cells you expect to see. 
They suggest the automatic method is sufficient for most use cases. 

It seems worthwhile to run, estimate contamination fraction, and possibly look at results
with and without SoupX. 

#### QC and introspection

Compare ratio of adjusted counts to previous counts, see which genes were most
affected. You should expect to see highly specific markers and mitochondrial genes. 

`SoupX::plotChangeMap()` can layer soup fraction estimations on a Umap or other
dim redux plot. 
