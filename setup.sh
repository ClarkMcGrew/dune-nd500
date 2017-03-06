# Setup the spack configuration for use with the dune-nd574 software.
# This assumes that the dun-nd574 package was cloned and has had the
# configuration script run already.  After this has been run, the
# spack-setup alias is available and can be used to reconfigure.
#
#  i.e.  The command
#
#     $ spack-setup
#
# will cause the setup to be refreshed.
#
# The dune-nd574 uses a lightly customized version of spack.  In
# particular, it can use a local set of configuration files (not
# associated with the users account).  To make this work, this defines
# the SPACK_CONFIG environment variable which points to the current
# users configuration file.  If it's not defined, then ~/.spack/ is
# used (the old default).

___spack_root=$(dirname $(realpath ${BASH_SOURCE}))

export SPACK_CONFIG
SPACK_CONFIG=${___spack_root}/spack-config
. ${___spack_root}/spack/share/spack/setup-env.sh
alias spack-setup=". ${___spack_root}/setup.sh"

unset ___spack_root

