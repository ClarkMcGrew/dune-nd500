# dune-ndx

A meta-repository to setup a working environment for DUNE ndx work.  This
will download and compile the necessary support code.

## Requirements

This assumes that your shell is bash, and all of the shell scripts
described assume bash is installed in "/bin/bash".  A lot of the installed
code assumes that you are using at least gcc 4.9.x, and it hasn't been
tested against other compilers.

## Installation

This is installed by cloning the package from github.  This won't make any
changes outside of your `<work-area>` directory.  By convention, the
suggested work area is `~/work/dune/software`, but that is entirely up to
you.

```bash
cd <work-area>
``` 

```bash
git clone https://github.com/ClarkMcGrew/dune-ndx.git
```
or
```bash
git clone git@github.com:ClarkMcGrew/dune-ndx.git
```

The preferred way to setup and install the software is to source

```bash
cd dune-ndx
source setup.sh
```

Notice that setup is being sourced, not run (this assumes you are using
bash).  This will appropriately modify the path, and define some
environment variable described below.  The first time this is run will take
quite a while (depending on the machine, a couple hours).

If you want to run the installation in background or on a queue, the
dune-ndx software can also be configured using the commands

```bash
cd dune-ndx
./configure.sh >& configure.output &
```

## General Usage

The dune-ndx software is setup using

```bash
source <work-area>/dune-ndx/setup.sh [release specification]
```

This will make sure that the basic infrastructure is installed and clone
the necessary spack packages, and can be safely run anytime.  It will
define a convenience alias so it can be rerun (i.e. `ndx-setup`).  Be aware
that if the configure script has not been run, this can take a *VERY* long
time.  The optional argument is a wildcard for the release name.  If you
don't specify a particular release, the default release will be setup.

After the `setup.sh` file (above) has been source, then you can configure a
particular release of the software using

```bash
ndx-setup <version>
```

where the <version> is a wild card for the release name.  If this is run
without an argument, a default release will be provided (In the early
stages, it's "0.0.0").  In the future, an example might be `ndx-setup
release@3.14.15`, or equivalently `ndx-setup 3.14.15`.  The last version
that matches both the wild card and the current machine architecture will
be selected.

If you find yourself using this a lot, it is convenient to put an alias in
your .bashrc.

```bash
alias ndx-setup="source <work-area>/dune-ndx/setup.sh"
```

After running `ndx-setup` the installed software will be in your path, and
ready to be used.  By default, both root and geant4 are setup and placed in
your path.  It also defines environment variables so that it's fairly
straight forward to use cmake with the installed libraries.  The following
special environment variables are also defined.

`NDX_SPACK_ROOT`: This is the directory where the bundling package is
installed.  This will have the value of `<work-area>/dune-ndx`.

`NDX_ROOT`: This is the directory containing the installed release.  For
example, the executables are installed in `${NDX_ROOT}/bin`.  For example,
if you have run `ndx-setup release@0.0.0`, this has a value of
`<work-area>/dune-ndx/releases/release@0.0.0~machine` (where machine is
system dependent).
	   
## Low Level Hints

These are hints, not instructions, but may help guide you in the right
direction.

The releases are defined in
`${NDX_SPACK_ROOT}/ndx-spack/packages/release/package.py` and can be
installed using

```ndx-release -v release@<version>```

The releases that can be installed can be found by running

```
spack info release
```

The installed releases can be found by running

```
spack find release
```

If you want to force a recompile of part of a release, you can use

```
spack uninstall --dependents <package>
./configure.sh
```

