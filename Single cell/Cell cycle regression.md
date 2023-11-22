## Cell cycle regression

Cells at different stages of growth can exhibit unique expression profiles. For some studies, detecting signal between cells of different stages in not interesting and can confound or obscure results of interest. A set of cell-cycle marker genes can be used to approximate growth stage and regress expression data to ignore variance due to cell cycle.

Note that this is probably not a desirable outcome for studies focusing on cell differentiation or other inquiries related to cell growth & cycling. 

You should at least check if your data is affected by CC differences and consider regressing. At the very least, you can say you did not see any separation by CC that would call your results into question. 

Related vignettes: [Harvard Chan Bioinformatics Core](https://github.com/hbctraining/scRNA-seq_online/blob/master/lessons/cell_cycle_scoring.md)

[Seurat](https://satijalab.org/seurat/articles/cell_cycle_vignette.html)

Cell cycle regression checking is incorporated in the gencoreSC package. See the 'using-gencoreSC' package for more details on using it in our standard workflow.