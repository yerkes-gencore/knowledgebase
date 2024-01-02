library(yaml)
library(data.tree)
library(DiagrammeR)
# library(here)

# here::i_am('Immunology/celltype-heirarchy.R')

data <- yaml::read_yaml('celltype-heirarchy.yaml')

osNode <- data.tree::as.Node(data, interpretNullAsList = TRUE)

pdf(file = 'celltype-heirarchy.pdf', width = 10, height = 10)
plot(osNode)
dev.off()
