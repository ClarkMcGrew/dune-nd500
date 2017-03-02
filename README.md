# dune-nd500
A meta-repository to setup a working environment for DUNE nd500 work.  This
will download and compile the necessary support code.

This is installed by cloning the package from github

cd <work-area>
git clone git@github.com:ClarkMcGrew/dune-nd500.git

cd dune-nd500
source dune-nd500/setup.sh

This will make sure that the basic infrastructure is installed and clone
the necessary spack packages.

The packages are then installed using the command

spack install release@<version>

The most recent packages can be installed using

spack install release@master

