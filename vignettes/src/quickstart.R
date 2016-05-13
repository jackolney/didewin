## ---
## title: "Quickstart for R and the DIDE cluster"
## author: "Rich FitzJohn"
## date: "`r Sys.Date()`"
## output: rmarkdown::html_vignette
## vignette: >
##   %\VignetteIndexEntry{Quickstart for R and the DIDE cluster}
##   %\VignetteEngine{knitr::rmarkdown}
##   %\VignetteEncoding{UTF-8}
## ---

## > Get yourself running R jobs on the cluster in 10 minutes or so.

## Assumptions that I make here:

## * you are using R
##
## * your task can be represented as running a function on some inputs
##   to create an output (a file based output is OK)
##
## * you are working on a network share and have this mounted on your
##   computer
##
## * you know what packages your code depends on
##
## * your package dependencies are all on CRAN, and are all available
##   in windows binary form.

## If any of these do not apply to you, you'll probably need to read
## the full vignette.  In any case the full vignette contains a bunch
## more information anyway.

## ## Install a lot of packages

## On windows in particular, this step can be infuriating if something
## triggers an upgrade in a package that is being depended on.  If you
## end up in a situation where packages simply can't be loaded you may
## need to restart R and try installing things from scratch.
## Hopefully I can come up with a way of reducing the pain here.

##+ eval=FALSE
install.packages("devtools")
devtools::install_github(c(
  "richfitz/ids",
  "dide-tools/context",
  "richfitz/queuer",
  "dide-tools/didewin"))

## Or:
##+ eval=FALSE
drat:::add("richfitz")
install.packages("didewin")

## Or:
##+ eval=FALSE
install.packages("didewin", repos=c(CRAN="https://cran.rstudio.com",
                                    drat="https://richfitz.github.io/drat"))

## ## Describe your computer so we can find things

## On windows if you are using a domain machine, you should need only
## to select the cluster you want to use

##+ eval=FALSE
didewin::didewin_config_global(cluster="fi--didemrchnb")

## Otherwise, and on any other platform you'll need to provide your username:
didewin::didewin_config_global(username="rfitzjoh",
                               cluster="fi--didemrchnb")

## If this is the first time you have run this package, best to try
## out the login proceedure with:
didewin::web_login()

## ## Describe your project dependencies so we can recreate that on the cluster

## Make a vector of packages that you use in your project:
packages <- c("ape", "MASS")

## And of files that define functions that you ned to run things:
sources <- c("mysources.R", "utils.R")

## Then save this together to form a "context".
ctx <- context::context_save("contexts", packages=packages, sources=sources)

## ## Build a queue, based on this context.

## This will prompt you for your password, as it will try and log in.
obj <- didewin::queue_didewin(ctx)

## Once you get to this point we're ready to start running things on
## the cluster.  Let's fire off a test to make sure that everything works OK:
t <- obj$enqueue(sessionInfo())

## We can poll the job for a while, which will print a progress bar.
## If the job is returned in time, it will return the result of
## running the function.  Otherwise it will throw an error.
t$wait(120)

## You can use `t$result()` to get the result straight away (throwing
## an error if it is not ready) or `t$wait(Inf)` to wait forever.