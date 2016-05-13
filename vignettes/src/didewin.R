## ---
## title: "R and the DIDE cluster"
## author: "Rich FitzJohn"
## date: "`r Sys.Date()`"
## output: rmarkdown::html_vignette
## vignette: >
##   %\VignetteIndexEntry{R and the DIDE cluster}
##   %\VignetteEngine{knitr::rmarkdown}
##   %\VignetteEncoding{UTF-8}
## ---

## # Background and concepts

## Parallel computing on a cluster can be more challenging than
## running things locally because it's often the first time that you
## need to package up code to run elsewhere.  Much of the difficulty
## of getting things running involves working out what your code
## depends on, and getting that installed in the right place on a
## computer that you can't physically poke at.  The next set of
## problems is dealing with the balloning set of files that end up
## being created - templates, scripts, output files, etc.

## This set of packages (`didewin`, `queuer` and `context`) aims to
## remove the pain of getting everything set up, and in keeping
## cluster tasks running.

## Once everything is set up, running a job on the cluster should be
## as straightforward as writing (approximately):
##
## ```r
## didewin_enqueue(long_running_calculation(x))
## ```
##
## or running a series of calculations with
##
## ```r
## queuer::qlapply(1:10, long_running_calculation)
## ```

## The documentation here runs through a few of the key concepts, then
## walks through setting this all up.  There's also a "quick start"
## guide that contains much less discussion.

## ## Functions

## The biggest conceptual move is from thinking about running
## **scripts** that generate *files* to running **functions** that
## return *objects*.  The reason for this is that gives a well defined
## interface to build everything else around.
##
## Scripts do almost anything.  They depend on untold files and
## packages which they load wherever.  The produce any number of
## objects.  That's fine, but it becomes hard to reason about them to
## plan deploying them elsewhere, to capture the outputs
## appropriately, or to orchestrate looping over a bunch of paramter
## values.  If you've found yourself writing a number of script files
## changing values with text substitution you have run into this.
##
## In contrast, functions do (ideally) one thing.  They have a well
## defined set of inputs (their arguments) and outputs (their return
## value).  We can loop over a range of input values by iterating over
## a set of arguments.
##
## This set of packages tends to work best if you let it look after
## filenames.  Rather than trying to come up with a naming scheme for
## different files as based on parameter values, just return objects
## and the packages will arrange for them to be saved and reloaded.

## ## Filesystems

## The DIDE cluster needs everything to be available on a filesystem
## that the cluster can read.  Practically this means the filesystems
## //fi--didef2/tmp` or `//fi--san02/homes/username` and the like.
## For Windows users these are probably mapped to drives (`Q:` or `T:`
## or similar) already, but for other platforms you will need to do a
## little extra work to get things set up (see below).

## At present, *everything* that is needed for a project must be in the directory that is visible on the cluster.  Soon, I do hope to implement


## # Getting started

## See the section [configuration](#configuration) below for much more
## detail on what to use here.

## # Configuration

## The configuration is handled in a two stage process.  First, some
## bits that are machine specific are set using
## `didewin::didewin_config_global`, which also looks in a number of
## of R's options.  Then when a queue is created, further values can
## be passed along via the `config` argument that will use the
## "global" options as a default.

## The reason for this separation is that ideally the machine-specific
## options will not end up in scripts, because that makes things less
## portable (for example,we need to get your username, but your
## username is unlikely to work for your collaborators.

## Ideally in your ~/.Rprofile file, you will add something like:
##
## ```r
## options(
##   didewin.username="rfitzjoh",
##   didewin.home="~/net/home")
## ```
##
## and then set only options (such as cluster and cores or template)
## that vary with a project.

## ## Packages

## If you list packages as a character vector then all packages will
## be installed fo you, but they will also be *attached*.  This is not
## always what is required, especially if you have packages that
## clobber functions in base packages (e.g., `dplyr`!).  An
## alternative is to list a set of packages that you want installed
## and split them into packages you would like attached and packages
## you would like loaded:

packages <- list(loaded="geiger", attached="ape")

## In this case, the packages in the `loaded` section will be
## installed (along with their dependencies) and before anything runs,
## we will run `loadNamespace` on them to confirm that they are
## properly available.  Access functions in this package with the
## double-colon operator, like `geiger::fitContinuous`.  However they
## will not be attached so will not modify the search path.

## In contrast, packages listed in `attached` will be loaded with
## `library` so they will be available without qualification (e.g.,
## `read.tree` rather than `ape::read.tree`).