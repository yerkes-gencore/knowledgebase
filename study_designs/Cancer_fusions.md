## Study overview and goals

Gene fusions are not uncommon causes of cancer. Gene fusions can be detected
in short-read RNA sequencing with the help of additional algorithms. These gene
fusions can be queried against databases such as OncoKB or ChimerDB to identify
known fusions and possible drug interventions. 

## Study design considerations

Detecting fusions in RNA-seq data can be tricky as these transcripts are often
under-expressed. It may be prudent to have deeper sequencing than for general
RNA-seq experiments focused on differential gene expression to improve
detection and support for subtle findings.

## Required data and information

## Workflow

From the p22162 manuscript:

```
Fusion detection was performed with Arriba [37]. Raw reads were mapped to Ensembl v107 Homo sapiens GRCh38 [38] reference by Star 2.7.9a [21] using the parameters suggested by Arriba. Fusion processing was performed using the hg38 reference databases provided by the Arriba helper script download_references.sh. Processed fusions were queried against ChimerDB v4.0 [39]. Fusions with at least 2 valid supporting reads were reported as present in ChimerDB if they were in ChimerKB, in ChimerPub with a prediction score >= 0.8, or in ChimerSeq-Plus. Drug targets were identified by querying OncoKB [36]. Novel fusions were reported only if they had a ‘high’ confidence rating from Arriba’s algorithm and were not deletion/read-through events due to high false positive rate [37].

21.	Dobin A, Davis CA, Schlesinger F, et al. STAR: ultrafast universal RNA-seq aligner. Bioinformatics. 2013;29(1):15-21.

36.	Chakravarty D, Gao J, Phillips SM, et al. OncoKB: A Precision Oncology Knowledge Base. JCO Precis Oncol. 2017;2017.
37.	Uhrig S, Ellermann J, Walther T, et al. Accurate and efficient detection of gene fusions from RNA sequencing data. Genome Res. 2021;31(3):448-460.
38.	Cunningham F, Allen JE, Allen J, et al. Ensembl 2022. Nucleic Acids Res. 2022;50(D1):D988-D995.
39.	Jang YE, Jang I, Kim S, et al. ChimerDB 4.0: an updated and expanded database of fusion genes. Nucleic Acids Res. 2020;48(D1):D817-D824.
```
