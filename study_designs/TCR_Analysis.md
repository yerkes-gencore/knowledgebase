## Study overview and goals

Identify clonal expansion of T-cells.
Ben Bimber is a collaborator of Steve's who does lots of TCR work in macaques.
He is a good reference for these inquiries and has some custom references with
additional data not present in IMGT. 

## Study design considerations

Ben suggests the rate of recovery can be broad. He suggested as high as 90%
clonotype recovery from T cells, whereas we observed sub 50% recovery in the
p23120 study. 

Multiple chains can appear in the same clone/cell. E.g. multiple alpha or beta
chains. This can be a product of the biology (possibly due to the first chain 
being non-functional) and not necessarily technical artifact. Depending on the
collapsing criteria, you may consider discordant alphas with matching betas 
as a clone with multiple chains. 

Bimber does some extra work with gamma delta chains, which we didn't get the
full details on for the p23120 study as they weren't relevant, but he has an 
extended reference for all the chains they've identified in their lab (including
gamma and delta chains). 

## Required data and information

Extended TCR reference provided by the Bimber lab is available at 

`/yerkes-cifs/runs/scrna_seq_ref/TCR-ref-Bimber`

https://pubmed.ncbi.nlm.nih.gov/34810222/

## Workflow

There seems to be not a clear consensus on how to collapse slight differences
to call clones. It seems to be on a 'per study' basis. 

What we did for the p23120 study was
1) Run cellranger with the modified reference from Ben. I filtered out the gamma
and delta chains from the FASTA, as we were not interested in those.
2) Run a custom script to call clonotypes on the cellranger outputs. For each cell,
the alpha and beta chains with the most UMIs were selected as the TRA/TRB chains for 
that cell. Not every cell had both chains. A clone had to have perfect identity
in the V-gene, J-gene, and CDR3 AA sequence for the respective chains.
We explored 3 collapsing algorithms:
2a) Only call clonotypes for cells with both a TRA and TRB
2b) Call clonotypes on TRA and TRB, but if a cell has only a TRB chain, see if it
matches one (and ONLY one) existing clonotype of TRA+TRB. If so, we assume these
are part of the same clonotype and collapse them.
2c) Only call clonotypes based on the TRB chain. 
We went forward with the 2b) approach. 