library(yaml)
library(data.tree)
library(DiagrammeR)
library(DiagrammeRsvg)
library(here)
library(rsvg)
if(packageVersion("data.tree") < "1.1.0") {
  stop("Your version of the data.tree package is too old and will not work. 
       Install data.tree with a minimum version of 1.1.0")
  ## Because of this: https://github.com/gluc/data.tree/issues/169
  ## If you're using Renv or something else, you may need to access an unlocked CRAN mirror
  ## devtools::install_version(data.tree, repos = 'http://cran.r-project.org')
}

data <- yaml::read_yaml(here('Biology/celltype-heirarchy.yaml'))

osNode <- data.tree::as.Node(data, interpretNullAsList = TRUE)

export_graph(ToDiagrammeRGraph(osNode), "Biology/celltype-heirarchy.pdf")

