# Setup the dune-nd500 code for developing.  This should run in a
# directory that is going to be used to build the spack stuff, or
# after it's been built to reconfigure.

# Make sure spack is up-to-date.
if [ ! -d ./spack ]; then
   git clone git@github.com:ClarkMcGrew/spack.git
fi
(cd spack; git pull)

. ./setup.sh

# Make sure hep-spack is up-to-date.
if [ ! -d ./hep-spack ]; then
   git clone git@github.com:ClarkMcGrew/hep-spack.git
fi
(cd hep-spack; git pull)

# Make sure the hep-spack repo is known to spack.
if ! (spack repo list --scope=site | grep hep-spack); then
    spack repo add --scope=site ./hep-spack
fi

# Make sure the nd574-spack repo is known to spack.
if ! (spack repo list --scope=site | grep nd574-spack); then
    spack repo add --scope=site ./nd574-spack
fi

# Make sure that the compilers are known.
if [ -f ${SPACK_CONFIG}/linux/compilers.yaml ]; then
    rm -f ${SPACK_CONFIG}/linux/compilers.yaml
fi
spack compiler find

