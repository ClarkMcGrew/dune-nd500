#!/bin/bash
# Setup the spack configuration for use with the dune-nd574 software.
# This assumes that the dun-nd574 package was cloned and has had the
# configuration script run already.  After this has been run, the
# spack-setup alias is available and can be used to reconfigure.
#
#  i.e.  The command
#
#     $ nd574-setup
#
# will cause the setup to be refreshed.
#
# NOTE: This does not set the paths for any particular release of the
# software.  This needs to be done by sourcing the setup in that
# release.
#
# The dune-nd574 uses a lightly customized version of spack.  In
# particular, it can use a local set of configuration files (not
# associated with the users account).  To make this work, this defines
# the SPACK_CONFIG environment variable which points to the current
# users configuration file.  If it's not defined, then ~/.spack/ is
# used (the old default).

if [ "x${BASH_VERSION}" = "x" ]; then
    echo This must be run using bash
    exit 1
fi

___release_candidate=$1
shift

export ND574_SPACK_ROOT
ND574_SPACK_ROOT=$(dirname $(realpath ${BASH_SOURCE}))

# Set the location of the local spack configuration files.
export SPACK_CONFIG
SPACK_CONFIG=${ND574_SPACK_ROOT}/spack-config

# Make sure spack is configured
if [ ! -f ${ND574_SPACK_ROOT}/spack/share/spack/setup-env.sh ]; then
    ${ND574_SPACK_ROOT}/configure.sh
fi

# Setup the spack configuration
source ${ND574_SPACK_ROOT}/spack/share/spack/setup-env.sh

# Setup the alias to rerun this setup.
alias nd574-setup="source ${ND574_SPACK_ROOT}/setup.sh"

# Define some local worker functions to help set paths
___path_remove ()  {
    export $1=$(eval echo -n \$$1 | \
	awk -v RS=: -v ORS=: '$0 != "'$2'"' | \
	sed 's/:$//'); 
}
___path_append ()  {
    ___path_remove $1 $2
    eval export $1="\$$1:$2"
}
___path_prepend () {
    ___path_remove $1 $2
    eval export $1="$2:\$$1"
}

# Add the scripts directory to the path.
___path_prepend PATH ${ND574_SPACK_ROOT}/scripts

# Remove the local worker functions from the definitions.
unset -f ___path_append
unset -f ___path_prepend
unset -f ___path_remove

# Now see if we should setup a particular release
if [ ! -d ${ND574_SPACK_ROOT}/releases ]; then
    echo No releases installed
    unset -v ___release_candidate
    return
fi

if [ ${#___release_candidate} == 0 ]; then
    ___release_candidate=$( \
	find ${ND574_SPACK_ROOT}/releases -mindepth 1 -maxdepth 1 \
	| sort \
	| grep $(spack arch) \
	| tail -1)
	       
else
    ___release_candidate=$(\
	find ${ND574_SPACK_ROOT}/releases -mindepth 1 -maxdepth 1 \
	| sort \
	| grep ${___release_candidate} \
	| tail -1)
fi

if [ ${#___release_candidate} == 0 ]; then
    echo No release selected
    unset -v ___release_candidate
    return
fi

if [ ! -f ${___release_candidate}/setup.sh ]; then
    echo No setup file for $(basename ${___release_candidate})
    unset -v ___release_candidate
    return 
fi

source ${___release_candidate}/setup.sh

echo ND574_ROOT setup for $(basename ${ND574_ROOT})

unset -v ___release_candidate
