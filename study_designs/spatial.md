## Study overview and goals

Identify spatial patterns in gene expression or cell location. 

## Study design considerations

While newer spatial technologies claim to be single-cell resolution, most platforms cannot guarantee
all reads from a single location will be from a single cell, as things like tissue slice thickness and varying cell sizes
make it difficult to define clear boundaries. Spatial analyses interested in single-cell resolution will likely have to
rely on some deconvolution algorithm to separate reads. I/we have not vetted any of these, so you will have to do some research
for the most appropriate tool. 

## Required data and information

You will need images of the tissues, sometimes called the fiducial, to associate the coordinates with biological structures. 

## Workflow

I haven't advanced an analysis beyond the seurat vignette. 

https://satijalab.org/seurat/articles/spatial_vignette.html
