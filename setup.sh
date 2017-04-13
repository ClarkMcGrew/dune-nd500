#!/bin/bash
# Setup the spack configuration for use with the dune-ndx software.
# This assumes that the dun-ndx package was cloned and has had the
# configuration script run already.  After this has been run, the
# spack-setup alias is available and can be used to reconfigure.
#
#  i.e.  The command
#
#     $ ndx-setup
#
# will cause the setup to be refreshed.
#
# NOTE: This does not set the paths for any particular release of the
# software.  This needs to be done by sourcing the setup in that
# release.
#
# The dune-ndx uses a lightly customized version of spack.  In
# particular, it can use a local set of configuration files (not
# associated with the users account).  To make this work, this defines
# the SPACK_CONFIG environment variable which points to the current
# users configuration file.  If it's not defined, then ~/.spack/ is
# used (the old default).

if [ "x${BASH_VERSION}" = "x" ]; then
    echo This must be run using bash
    return 1
fi

___release_candidate=$1
shift

# Add the scripts.
___path_remove ()  {
    export $1=$(eval echo -n \$$1 | \
	awk -v RS=: -v ORS=: '$0 != "'$2'"' | \
	sed 's/:$//'); 
}
___path_append ()  {
    ___path_remove $1 $2
    if [ -d ${2} ]; then
	eval export $1="\$$1:$2"
    fi
}
___path_prepend () {
    ___path_remove $1 $2
    if [ -d ${2} ]; then
	eval export $1="$2:\$$1"
    fi
}

# Update the environment.
___path_prepend PATH "${NDX_SPACK_ROOT}/scripts"

if [ "x$___release_candidate" = "x-h" ]; then
    echo "usage: ndx-setup <release-version>"
    echo "   The default is the highest version found."
    return 1
fi

export NDX_SPACK_ROOT
NDX_SPACK_ROOT=$(dirname $(realpath ${BASH_SOURCE}))

# Set the location of the local spack configuration files.
export SPACK_CONFIG
SPACK_CONFIG=${NDX_SPACK_ROOT}/spack-config

# Make sure spack is configured
if [ ! -f ${NDX_SPACK_ROOT}/spack/share/spack/setup-env.sh ]; then
    ${NDX_SPACK_ROOT}/configure.sh
fi

# Setup the spack configuration
source ${NDX_SPACK_ROOT}/spack/share/spack/setup-env.sh

# Setup the alias to rerun this setup.
alias ndx-setup="source ${NDX_SPACK_ROOT}/setup.sh"

# Define the environment modules.
MODULESHOME=$(spack location --install-dir environment-modules 2> /dev/null)
if [ $? != 0 ]; then
    echo Release not installed yet.
    unset -v ___release_candidate
    unset -f ___path_append
    unset -f ___path_prepend
    unset -f ___path_remove
    return 1
fi

source ${MODULESHOME}/Modules/init/bash
source ${MODULESHOME}/init/bash_completion

# Make sure the environment is clean.
module purge

# Check to see if the requested release exists.  The sed command is
# doing backflips to remove the spack pretty printing.
if [ ${#___release_candidate} != 0 ]; then
    ___release_candidate=$(spack find release \
				  | sed 's/\x1B[[:print:]]*[mGK]//g' \
				  | tail +2 \
				  | grep ${___release_candidate} \
				  | sort \
				  | tail -1)
fi

# If there isn't a release, find a default. The sed command is doing
# backflips to remove the spack pretty printing.
if [ ${#___release_candidate} == 0 ]; then
    ___release_candidate=$(spack find release \
				  | sed 's/\x1B[[:print:]]*[mGK]//g' \
				  | tail +2 \
				  | sort \
				  | tail -1)
fi

# If there still isn't a release, print a message and stop.
if [ ${#___release_candidate} == 0 ]; then
    echo No release candidate found.
    return 0
fi

echo Setting up environment for ${___release_candidate}

LOCAL_ENVIRONMENT=$(mktemp)
spack module loads -r ${___release_candidate} > ${LOCAL_ENVIRONMENT}
. ${LOCAL_ENVIRONMENT}
rm ${LOCAL_ENVIRONMENT}

# Try to setup geant4.  GEANT4 installs geant4.sh in the bin directory
# to setup the environment.  The first "geant4.sh" in the path will
# define the geant that is used.  This gives the G4 build script the
# ability to make sure all of the G4 environment variables are
# correctly defined.
. geant4.sh >& /dev/null
if [ $? != 0 ]; then
    echo GEANT not available.
fi

# Try to setup root.  ROOT installs thisroot.sh in the bin directory
# to setup the environment.  This gives the ROOT build script the
# ability to make sure all of the ROOT environment variables are
# correctly defined.
. thisroot.sh >& /dev/null
if [ $? != 0 ]; then
    echo ROOT not available.
fi

unset -v ___release_candidate
unset -f ___path_append
unset -f ___path_prepend
unset -f ___path_remove

