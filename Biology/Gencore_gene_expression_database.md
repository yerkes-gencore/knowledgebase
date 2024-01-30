# Gencore gene expression database overview

Finding difinitive gene expression markers for assigning celltypes can be a mess. While finding literature precedent is ideal, it's not always
easy or possible. Since we run many projects through the gencore, it can be useful to leverage previous studies with known systems, wet-lab procedures, 
and processing steps. The Gencore gene expression database aims to collect gene expression data from many studies into one easily queriable file. 
The idea is to focus on strong, celltype-defining markers. These may be produced by something like Seurat's `FindMarkers/FindAllMarkers`, but methods 
may change in the future, and we want a consistent location and structure for this information. A helper script walks you through adding data to the 
database, including any necessary filtering or maping of columns. It also tries to enforce good consistent celltype annotations across projects
by using the [celltype-heirarchy](celltype-heirarchy.yaml). This should allow for easier aggregation across different studies. Another helper script
walks you through setting up a query to retrieve data as an R table. This script can be sourced while actively working on an analysis, providing
your environment with a single object for your query results.

For more information, see the [Gencore database]() repo. 
