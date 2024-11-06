# Installing and Running Snakemake

Snakemake is a workflow management system that enables reproducible and scalable data analyses. This guide provides detailed instructions on how to install and run Snakemake using various methods.

## Table of Contents

1. [Installation via Conda/Mamba](#installation-via-condamamba)
    - [Full Installation](#full-installation)
    - [Minimal Installation](#minimal-installation)
2. [Installation via pip](#installation-via-pip)
3. [Running Snakemake](#running-snakemake)

## Installation via Conda/Mamba

Installing Snakemake through Conda or Mamba is the recommended approach, as it facilitates the management of software dependencies within your workflows.

### Prerequisites

Ensure that you have a Conda-based Python 3 distribution installed. The recommended choice is [Miniforge](https://github.com/conda-forge/miniforge). Alternatively, you can use other Conda-based package managers such as [Pixi](https://github.com/mamba-org/pixi), [Mamba](https://github.com/mamba-org/mamba), or [Micromamba](https://github.com/mamba-org/micromamba). Note that for Snakemake’s Conda integration, the `conda` command should be available in the root environment or the same environment as Snakemake.

### Full Installation

To install Snakemake with all features, including the ability to create interactive reports, execute the following commands:

```sh
conda create -c conda-forge -c bioconda -n snakemake snakemake
conda activate snakemake
snakemake --help
```

This sequence creates a new Conda environment named `snakemake`, installs Snakemake within it, activates the environment, and verifies the installation by displaying the help message.

### Minimal Installation

For a minimal installation that includes only the essential components, use:

```sh
conda create -c conda-forge -c bioconda -n snakemake snakemake-minimal
```

This command sets up a new Conda environment named `snakemake` with the minimal version of Snakemake.

## Installation via pip

Alternatively, you can install Snakemake using pip:

```sh
pip install snakemake
```

Be aware that Snakemake has non-Python dependencies. Therefore, the pip-based installation may have limited functionality unless these dependencies are manually installed.

## Running Snakemake

After installation, you can run Snakemake by activating the appropriate environment and executing the `snakemake` command. For example:

```sh
conda activate snakemake
snakemake --help
```

This command displays the help message, confirming that Snakemake is installed and ready to use.

For more detailed information and advanced usage, refer to the [official Snakemake documentation](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html).