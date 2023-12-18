## Study overview and goals

Exome or whole-genome sequencing of cancer patients is performed to
identify mutations associated with clinical outcomes. Exome is cheaper
and more focused than WGS, and is generally sufficient for this type of
inquiry. Mutations are queried against known databases of cancerous
mutations, or in a more experimental study, you may use computational
prediction algorithms to identify mutations that affect the biological
function of important genes, either enhancing the function of
oncodrivers or impeding the function of tumor-supressors, thereby
possibly identifying new oncogenes.

OncoKB seems to be a widely utilized resource for cancer research. You
can acquire an API key to query mutations identified in your study
against the OncoKB database to identify known oncogenic mutations and
possible drugs to target them.

## Study design considerations

Ideally, each patient sequenced would have paired tumor and normal
(sample from non-cancerous tissue) samples. This allows the germline
mutations to be filtered from somatic or tumor-specific mutations where
appropriate. Having paired normals for only some samples is an
acceptable shortcut, as you can create a 'pool of normals' to capture a
range of SNPs and technical artifacts to represent the whole study. Like
any controls, the more the better, but I'm not sure what a sufficient
number of these would be. For the p22162 study, we had \~30 normals for
\~100 samples.

## Required data and information

If WES is performed, you may need to get a BED file of all the regions
captured with the library preparation. This is usually provided by the
kit vendor. This is provided to mutation calling algorithms to narrow
the scope of alignments.

You may need to download databases of known human SNPs for use with
mutation calling algorithms. GnomAD and dbSNP are two possible
resources.

## Workflow

This processing workflow was loosely inspired by GATK guidelines and
TCGA methods. The filtering criteria and workflow were developed under
the guidance of Tom Schneider (a collaborator on the p22162 project).

We used 2 variant calling algorithms (Mutect and LoFreq) and took the
intersection of those to be our defacto mutations, filtered mutations
with high frequencies in population SNP databases, and selected
mutations with strong read evidence and predicted impact on phenotype to
produce the final set of mutations for each sample. Those were then
queried against OncoKB.

There are other tools and workflows in GATK resources and other
literature that may be better or more appropriate for your study.

```         
Raw reads were processed by Cutadapt to remove adapters, then fed into BWA for alignment to GRCh38 [26]. BAM files were processed by Samtools to sort and index, Picard Tools [28] to mark PCR duplicates, and LoFreq [29] to add indel qualities. Each sample had two BAMs from separate sequencing runs, which were merged by Samtools. Since only some of our samples had matching normal samples, we created a panel of normals (PON) as a shared germline/techincal artifact reference for all samples based on GATK guidelines [30]. We then performed somatic-sample variant calling through Mutect2 with the PON and a GnomAD SNP database serving as references [30]. The Mutect2 output was processed according to GATK guidelines to remove orientation bias artifact, calculate contamination, and filter germline calls [30]. We also performed variant calling using LoFreq with dbSNP (Build ID = 155, reference = GRCh38.p13) as a germline resource database. BCFtools was used to take the intersection of the filtered variant calls from each method (Mutect2 and Lofreq) and remove calls with less than 10% or greater than 90% allele frequency to produce the final set of variants for a given sample [27,31]. Sample variants were annotated with VEP32 and gnomAD v2.1.1 [33]. Annotated VCFs were converted to MAF format via vcf2maf tools34. These results were pulled into R and analyzed with MAFtools [35]. We filtered our analysis set to include SNVs based on annotations for PolyPhen = 'probably_damaging', SIFT = 'deleterious', and a maximum gnomAD population-level allele frequency no greater than 0.1%. We included all frame-shift indels and any acceptor or donor splice-site variants. All in-frame indels were excluded from analysis. Analysis pathways were taken from MSigDB [23,24] (collections H, C2, C5 filtered for pathways containing the phrase 'cancer') and a TCGA publication [25]. Drug information was pulled from OncoKB [36].

23. Liberzon A, Birger C, Thorvaldsdottir H, Ghandi M, Mesirov JP, Tamayo P. The Molecular Signatures Database (MSigDB) hallmark gene set collection. Cell Syst. 2015;1(6):417-425.
24. Liberzon A, Subramanian A, Pinchback R, Thorvaldsdottir H, Tamayo P, Mesirov JP. Molecular signatures database (MSigDB) 3.0. Bioinformatics. 2011;27(12):1739-1740.
25. Sanchez-Vega F, Mina M, Armenia J, et al. Oncogenic Signaling Pathways in The Cancer Genome Atlas. Cell. 2018;173(2):321-337 e310.
26. Li H, Durbin R. Fast and accurate short read alignment with Burrows-Wheeler transform. Bioinformatics. 2009;25(14):1754-1760.
27. Danecek P, Bonfield JK, Liddle J, et al. Twelve years of SAMtools and BCFtools. Gigascience. 2021;10(2).
28. Wilm A, Aw PP, Bertrand D, et al. LoFreq: a sequence-quality aware, ultra-sensitive variant caller for uncovering cell-population heterogeneity from high-throughput sequencing datasets. Nucleic Acids Res. 2012;40(22):11189-11201.
29. Broad Institute. Picard Toolkit, 2019. https://broadinstitute.github.io/picard/.
30. O’Connor, B. D.; Van der Auwera. Genomics in the Cloud; O’Reilly Media, Inc., 2020.
31. Benjamin, D.; Sato, T.; Cibulskis, K.; Getz, G.; Stewart, C.; Lichtenstein, L. Calling Somatic SNVs and Indels with Mutect2. bioRxiv December 2, 2019, p 861054. https://doi.org/10.1101/861054.
32. McLaren W, Gil L, Hunt SE, et al. The Ensembl Variant Effect Predictor. Genome Biol. 2016;17(1):122.
33. Karczewski KJ, Francioli LC, Tiao G, et al. The mutational constraint spectrum quantified from variation in 141,456 humans. Nature. 2020;581(7809):434-443.
34. Kandoth, C. Vcf2maf, 2020. doi:10.5281/zenodo.593251.
35. Mayakonda A, Lin DC, Assenov Y, Plass C, Koeffler HP. Maftools: efficient and comprehensive analysis of somatic variants in cancer. Genome Res. 2018;28(11):1747-1756.
36. Chakravarty D, Gao J, Phillips SM, et al. OncoKB: A Precision Oncology Knowledge Base. JCO Precis Oncol. 2017;2017.
```
