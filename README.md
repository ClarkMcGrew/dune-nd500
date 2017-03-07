# dune-nd500

A meta-repository to setup a working environment for DUNE nd500 work.  This
will download and compile the necessary support code.

## Installation

This is installed by cloning the package from github.  This won't make any
changes outside of your `<work-area>` directory.  By convention, the
suggested work area is `~/work/dune/software`, but that is entirely up to
you.

```bash
cd <work-area>
``` 

```bash
git clone https://github.com/ClarkMcGrew/dune-nd500.git
```
or
```bash
git clone git@github.com:ClarkMcGrew/dune-nd500.git
```

```bash
cd dune-nd500
./configure.sh
```

The configure script will (try to) compile the software, so it can take a
long time.


## General Usage

The software can then be setup using

```bash
source <work-area>/dune-nd500/setup.sh
```

This will make sure that the basic infrastructure is installed and clone
the necessary spack packages, and can be safely run anytime.  It will
define a convenient alias so it can be rerun (i.e. `nd574-setup`).  Be aware
that if the configure script has not been run, this can take a *VERY* long
time.

After the `setup.sh` file (above) has been source, then you can configure a
particular release of the software using

```bash
nd574-setup <spec>
```

where the spec is a wild card for the release name.  If this is run without an argument, a default release will be provided (usually "develop").  An example might be `nd574-setup release@0.0.0`

After running `nd574-setup` the install software will be in your path, and
ready to be used.  In particular, these environment variables are defined
so that it's fairly straight forward to use cmake with the installed
libraries.



## Low Level SPACK Hints

The installable releases can be found by running

```
spack info release
```

The installed release can be found by running

```
spack find release
```

The package can then be installed using the command

```
spack install release@<version>
```

The most recent packages can be installed using

```
spack install release@master
```
