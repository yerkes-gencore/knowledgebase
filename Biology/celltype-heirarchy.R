library(yaml)
library(data.tree)
library(DiagrammeR)
library(DiagrammeRsvg)
library(here)
library(rsvg)

data <- yaml::read_yaml(here('Biology/celltype-heirarchy.yaml'))

osNode <- data.tree::as.Node(data, interpretNullAsList = TRUE)

export_graph(ToDiagrammeRGraph(osNode), "Biology/celltype-heirarchy.pdf")

