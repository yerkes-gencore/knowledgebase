## Demultiplexing hashed captures

[Paper on cell hashing](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-018-1603-1)

[Seurat vignette](https://satijalab.org/seurat/articles/hashing_vignette.html)

Cells from multiple samples can be loaded in the same capture as a cost saving
method. The cells are associated with a sample by ADTs. Seurat has methods
to assign sample names to cells based on the abundance of sample-specific
ADTs. 

HTO information can also be used to feed ground truth data for doublet detection.
See the Doublet Removal section of the vignette for more details. 

HTO data should be separated from other antibodies for the purpose of normalization.

### Within gencoreSC

The helper function `demuxAntibodyData()` serves as a wrapper to Seurat's
`HTODemux()`. See the 'using-gencoreSC' vignette for more details.
