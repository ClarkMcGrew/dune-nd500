# dune-ndx

A meta-repository to setup a working environment for DUNE ndx work.  This
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
git clone https://github.com/ClarkMcGrew/dune-ndx.git
```
or
```bash
git clone git@github.com:ClarkMcGrew/dune-ndx.git
```

```bash
cd dune-ndx
./configure.sh
```

The configure script will (try to) compile the software, so it can take a
long time.


## General Usage

The software can then be setup using

```bash
source <work-area>/dune-ndx/setup.sh
```

This will make sure that the basic infrastructure is installed and clone
the necessary spack packages, and can be safely run anytime.  It will
define a convenient alias so it can be rerun (i.e. `ndx-setup`).  Be aware
that if the configure script has not been run, this can take a *VERY* long
time.

After the `setup.sh` file (above) has been source, then you can configure a
particular release of the software using

```bash
ndx-setup <spec>
```

where the spec is a wild card for the release name.  If this is run without an argument, a default release will be provided (usually "develop").  An example might be `ndx-setup release@0.0.0`

After running `ndx-setup` the install software will be in your path, and
ready to be used.  In particular, these environment variables are defined
so that it's fairly straight forward to use cmake with the installed
libraries.  The following special environment variables are also defined.

`NDX_ROOT`: This is the directory containing the installed release.  For
			example, the executables are installed in `${NDX_ROOT}/bin`
	   
`NDX_SPACK_ROOT`: This is the directory where the bundling package is installed.

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
