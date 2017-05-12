#! /bin/bash
# Setup the dune-ndx code for developing.  This should run in a
# directory that is going to be used to build the spack stuff, or
# after it's been built to reconfigure.

if [ "x${BASH_VERSION}" = "x" ]; then
    echo This must be run using bash
    exit 1
fi

___spack_root=$(dirname $(realpath ${BASH_SOURCE}))
cd ${___spack_root}

# For commit access...
# GIT_REPO=git@github.com:ClarkMcGrew

# For distribution.
GIT_REPO=https://github.com/ClarkMcGrew

# Make sure spack is up-to-date, and get it if it doesn't exist.  This
# will define the setup script needed by dune-ndx/setup.sh and
# prevents recursion when ./setup is run by this script.
if [ ! -d ./spack ]; then
    git clone https://github.com/LLNL/spack.git
    # Patch SPACK so that it understand the SPACK_CONFIG env variable
    (cd spack; patch -p1 < ../scripts/spack.patch)
    # Change the misc_cach which has unfortunate hardcoded default.
    cat > spack/etc/spack/config.yaml <<EOF 
config:
   misc_cache: ${PWD}/spack-config/cache
   build_stage: ${PWD}/spack/var/spack/stage
EOF
fi

# Setup the local configuration before doing anything else.
source ./setup.sh

# Make sure the ndx-spack repo is known to spack.
if ! (spack repo list --scope=site | grep ndx-spack); then
    spack repo add --scope=site ./ndx-spack
fi

# Make sure that the compilers are known.
if [ -f ${SPACK_CONFIG}/linux/compilers.yaml ]; then
    rm -f ${SPACK_CONFIG}/linux/compilers.yaml
fi
spack compiler find

# Make sure a release is installed.  This should be changed when the
# production release version changes.
ndx-release -v release@develop

# All done.
