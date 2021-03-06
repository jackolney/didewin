# didewin

> DIDE Windows Cluster Support

**NOTICE**: This will only be of use to people at DIDE, as it uses our [cluster web portal](https://mrcdata.dide.ic.ac.uk/hpc), local cluster, and local network file systems.

## What is this?

This is a package for interfacing with the DIDE cluster directly from R.  It is meant make jobs running on the cluster appear as if they are running locally but asynchronously.  The idea is to let the cluster appear as an extension of your own computer so you can get using it within an R project easily.

## How does it work?

The steps below are described in more detail in the [vignettes](https://dide-tools.github.io/didewin)

1. Ensure that your project is in a directory that the cluster can see (i.e. on one of the network drives).  See [notes](https://dide-tools.github.io/didewin/vignettes/didewin.html#mapping-network-drives) for instructions
2. Set your DIDE credentials up so that you can log in and tell `didewin` about them.
3. Create a "context" in which future expressions will be evaluated (which will be recreated on the cluster)
4. Create a "queue" that uses that context
5. Queue expressions which will be run at some future time on the cluster
6. Monitor progress, retrieve results, etc.

## Documentation

Documentation is a work in progress, but largely contained in two vignettes:

* [The main vignette](https://dide-tools.github.io/didewin/vignettes/didewin.html) contains full instructions and explanations about why some bits are needed.
* There is a [quickstart guide](https://dide-tools.github.io/didewin/vignettes/quickstart.html) which is much shorter and will be quicker to glance through.

## Installation

The simplest approach is to run:

```r
install.packages("didewin",
                 repos=c(CRAN="https://cran.rstudio.com",
                         drat="https://richfitz.github.io/drat"))
```

Alternatively, with devtools you can run:

```r
devtools::install_github(c(
  "richfitz/ids",
  "richfitz/syncr",
  "dide-tools/context",
  "richfitz/queuer",
  "dide-tools/didewin"))
```
