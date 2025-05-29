## Spatial Domain Clustering

Identifying distinct cell types or states is a fundamental step in data analysis, as it enables the generation of key biological hypotheses.
	•	This is typically achieved by clustering cells based on similarity in feature space.
	•	A widely used method involves constructing a nearest neighbor graph from a low-dimensional representation of the data, followed by community detection on this graph.
	•	For spatial omics data, this method can be extended to incorporate spatial proximity, not just similarity in gene expression. This extended analysis is often referred to as “identification of spatial domains”, as it accounts for both molecular and spatial features when defining clusters.

Source: [https://www.sc-best-practices.org/spatial/domains.html](https://www.sc-best-practices.org/spatial/domains.html)

### Benchmark papers:

- [Benchmarking clustering, alignment, and integration methods for spatial transcriptomics](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-024-03361-0)

- [Benchmarking spatial clustering methods with spatially resolved transcriptomics data ](https://www.nature.com/articles/s41592-024-02215-8)

### Tools:

- [stDyer](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-025-03503-y)

- [HERGAST](https://www.nature.com/articles/s41467-025-59139-w)

- [STGATE](https://www.nature.com/articles/s41467-022-29439-6)

- [Banksy](https://www.nature.com/articles/s41588-024-01664-3)