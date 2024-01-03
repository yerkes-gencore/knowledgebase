# Finding orthologous gene symbols

It's best to avoid simply "translating" human gene symbols to Mus gene symbols by lowercase-ing them. Orthologous genes in human and mouse may have different names, and genes that have the same name may not always be the most biologically relevant ortholog. See https://www.biostars.org/p/149115/#149142 for the same logic.

Instead, it is better to search existing orthology databases for genes that correspond biologically across species. My (Micah's) recommended workflow is to

1. Use the [`orthogene`](https://neurogenomics.github.io/orthogene/articles/orthogene.html) package's `convert_orthologs()` function to query the [`g:Profiler`](https://biit.cs.ut.ee/gprofiler/orth) database, which uses information retrieved from the Ensemble, HomoloGene and WormBase databases.
2. If you are ok with sacrificing accuracy for the sake of including as many genes as possible and you are going from mouse/macaque to human, you can try finding the genes in your dataset that match the query in a case-insensitve way. This will definitely introduce some false positives, so if your gene list is short manually curate them as in step 3.
3. If your list is short enough, you can manually curate the remaining non-matching genes by searching for them on https://www.alliancegenome.org.

Here's an example of the workflow above:

## Orthogene plus triage

Let's say you have a dataframe (or tibble) called `nfkb_targets_tbl` with a column `Hs_gene` specifying the human gene symbols we'd like to convert to mouse symbols.

Start by adding a new column with the mouse orthologs using gprofiler's interface.
```
nfkb_targets_tbl_gprofiler <- nfkb_targets_tbl %>%
  filter(!is.na(Hs_gene)) %>%
  distinct(Hs_gene) %>%
  convert_orthologs(gene_df = .,
                    gene_input = "Hs_gene",
                    gene_output = "columns",
                    method = "gprofiler",
                    input_species = "Human",
                    output_species = "Mus musculus",
                    non121_strategy = "keep_popular") %>%
  as_tibble()
```

It's likely that a decent proportion of gene symbols will have `NA`s in the new column because gprofiler didn't have an ortholog on file.

If you are ok with sacrificing accuracy for the sake of including as many genes as possible and you are going from mouse/macaque to human, you can try finding the genes in your dataset that match the query in a case-insensitve way. This will definitely introduce some false positives, so if your gene list is short manually curate them as in step 3.

First - assuming you've been given a set of preliminary mouse gene names but need symbols - `orthogene::map_genes()` can help you convert gene names or symbols that may contain a mix of naming conventions to a common gene symbol. In this case we use Ensembl gene symbols as the target. You can simply use these names if no ortholog was found.
```
mapped_genes_Mus2Mus <- nfkb_targets_tbl$gene_name %>%
  unique() %>%
  map_genes(species = "Mus musculus", target = "ENSG") %>%
  as_tibble() %>%
  dplyr::select(gene_name = input, Mus2Mus = name)
```

Second, simply convert the human gene symbols into a format resembling Mus symbols. This will basically lowercase every letter after the first, but will drop any genes that don't exist as such in the Mus genome.
```
mapped_genes_Human2Mus <- nfkb_targets_tbl$Hs_gene %>%
  unique() %>%
  map_genes(species = "Mus musculus", target = "ENSG") %>%
  as_tibble() %>%
  dplyr::select(Hs_gene = input, Human2Mus = name)
```

Finally, we can choose the official gprofiler ortholog if available; if not, choose the "corrected" Mus gene symbol if available; if not, choose the Human -> Mus hacky symbols if you're ok with introducing false positives.
```
nfkb_targets_tbl_alt_names <- nfkb_targets_tbl %>%
  left_join(nfkb_targets_tbl_gprofiler %>% dplyr::select(Hs_gene = input_gene, ortholog_gene), relationship = "many-to-many") %>%
  left_join(mapped_genes_Mus2Mus, relationship = "many-to-many") %>%
  left_join(mapped_genes_Human2Mus, relationship = "many-to-many") %>%
  left_join(mapped_genes_Human2Human, relationship = "many-to-many")

nfkb_targets_tbl_alt_names %>%
  dplyr::select(input_gene, ortholog_gene, Hs_gene, Human2Human, Human2Mus, Mus2Mus) %>%
  filter(is.na(ortholog_gene))

nfkb_targets_tbl_alt_names %>%
  dplyr::count(!is.na(ortholog_gene), !is.na(Human2Human), !is.na(Human2Mus), !is.na(Mus2Mus))

nfkb_targets_symbols_tbl <- nfkb_targets_tbl_alt_names %>%
  mutate(Mus_symbol = ifelse(!is.na(ortholog_gene), ortholog_gene,
                             ifelse(!is.na(Mus2Mus), Mus2Mus, 
                                    ifelse(!is.na(Human2Mus), Human2Mus, NA)))) %>%
  dplyr::select(input_gene, Mus_symbol, Hs_gene, list, indirect_evidence, Function, everything(), -`Acc #`)
```

There will no doubt be many genes that still don't match anything. It could be that is no evidence that those genes have an ortholog in mouse, or it could be that the databases queried by gprofiler are incomplete.

If the list is short enough or if there are mission-critical genes that are left out, search the gene symbol at https://www.alliancegenome.org.

For example, in the above workflow, CXCL1 didn't have a Mus ortholog. Searching for it at https://www.alliancegenome.org reveals that there are three Mus musculus gene symbols with mixed evidence of orthology using various computational methods, and that the Ensemble and HGNC databases don't list them as orthologs.

Each database predicts orthologs in different ways for different reasons and there seems to be so such thing as a universally accepted "right" answer for how to do this, so ultimately someone has to make a judgement. I like this interface a lot because it shows you which methods agree and disagree on the call rather than just taking one. I wish there was a way to query this database from R...

## Other (less flexible and more clunky) ways of finding orthologs

### Querying Ensemble using `BioMaRt`

Ensembl has it's own `R` interface, [`BioMaRt`](http://useast.ensembl.org/info/data/biomart/biomart_r_package.html) but it's got clunkier syntax, it doesn't update as often and is buggy.

```
### Basic function to convert mouse to human gene names
convertMouseGeneList <- function(x){
require("biomaRt")
human <- useMart("ensembl", dataset = "hsapiens_gene_ensembl", host = "https://dec2021.archive.ensembl.org/") 
mouse <- useMart("ensembl", dataset = "mmusculus_gene_ensembl", host = "https://dec2021.archive.ensembl.org/")
genesV2 <- getLDS(values = x, uniqueRows=T, filters = "hgnc_symbol",
                  attributes = c("hgnc_symbol"), mart = human,
                  attributesL = c("mgi_symbol"), martL = mouse)
mousex <- unique(genesV2[, 2])
return(mousex)
}
```

### Querying NCBI's orthology database using `Orthology.eg.db`

```
# From https://support.bioconductor.org/p/9143371/
convertHs2Mm <- function(gns){
  require(org.Hs.eg.db)
  require(Orthology.eg.db)
  require(org.Mm.eg.db)
  egs <- mapIds(org.Hs.eg.db, 
                keys = gns, 
                column = "ENTREZID",
                keytype = "SYMBOL")
  mapped <- select(Orthology.eg.db,
                   keys = egs, 
                   columns = "Mus.musculus",
                   keytype = "Homo.sapiens")
  mapped$Hs_gene <- gns
  mapped$Mm_gene <- mapIds(org.Mm.eg.db,
                       keys = as.character(mapped$Mus.musculus), 
                       column = "SYMBOL", 
                       keytype = "ENTREZID")
  mapped <- mapped %>% 
    as_tibble() %>% 
    dplyr::select(Hs_gene, Mm_gene)
  return(mapped)
}
```

