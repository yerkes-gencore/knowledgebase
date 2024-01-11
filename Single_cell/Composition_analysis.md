# Composition analysis

Composition analysis attempts to determine if certain cell-types are more/less
frequent in a given condition. It relies on the cell-type annotations at a 
capture level, and hence is only as useful as the quality of the cell-type annotations.
Since single-cell captures are a subsampling of a full population, and community
structure is interdependent (i.e, increased abundance of one celltype leaves less space for other cells),
one should be careful not to be overly reliant on scRNA-seq based composition analyses. 
There are likely better (and cheaper) methods for determining changes
in cell abundance as the primary goal of an analysis. However, it can be a useful
secondary analysis for scRNA-seq. 

Since different captures recover different amounts of cells, compositions must
be considered as proportions of the whole capture. 

**scCODA** is one algorithm for assigning significance to changes in cell populations. It accounts for the
interdependence of cell-types within a capture, generally leading to conservative estimates
of significance. It also allows you to theoretically fit a mixed model, but in practice I
had trouble getting the random effects to work (not sure if syntax issues or insufficient representation across
fixed effects). It is python based, but it does not require loading count data, it only requires
counts of cell-types which can be easily exported from R. The single-cell RNA-seq template
repo has a jupyter notebook in the 'helper_scripts' folder. See the README there for more information.