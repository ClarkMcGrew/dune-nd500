from spack import *
import spack
import os
import datetime

class Release(Package):
    """A metapackage to release the entire shebang."""

    url = "https://github.com/ClarkMcGrew/dune-nd500/"
    homepage = "https://github.com/ClarkMcGrew/dune-nd500/"

    #The version which installs the latest copy of the release.  It's
    #not a number to emphasize that it's "moving"
    version('develop', url='dummy')
    version('0.0.0', url='dummy')
    
    # The dependencies for the release.  These should be in reverse order with
    # the lastest dependency first.  If releases use the same version,
    # the range can be specified using
    #
    #    depends_on("thing",when="@0.0:@1.0")'
    #
    # The release version is selected using the normal spack rules
    #   1) "develop" is always the highest version
    #   2) Numeric version in the obvious order
    #   3) Any other alphanumeric version.
    #
    # spack install release@develop -- installs the new version
    # spack install release@0.0     -- installs depends_on('stuff',when="@0.0")
    #
    # Ranges of dependencies can be set.  For example,
    # depends_on('stuff',when='@0.0:@1.0') will depend on 'stuff' for
    # any release version between release@0.0 and release@1.0.

    # The GEANT4 dependencies
    depends_on("geant4")        # The highest version. 
    depends_on("geant4@10.02.p01", when="@0.0.0")

    # The ROOT dependencies
    depends_on("root")          # The highest version.
    depends_on("root@6.08.02", when="@0.0.0")

    def install(self,spec,prefix):
        """Create a file in the installation area.  This serves two purposes.
        First, it records what has been installed, and that will be
        copied to any views.  Second, it lets spack know that
        something was installed.

        """
        releaseFile = open(prefix + "/dune-nd574.release",'a')
        print >>releaseFile, self.name + "@" + str(self.version)
        print >>releaseFile, datetime.datetime.today()
        print >>releaseFile, os.getenv("SPACK_CC")
        print >>releaseFile, os.getenv("SPACK_CXX")
        print >>releaseFile, os.getenv("SPACK_FC")
        print >>releaseFile, os.getenv("SPACK_F77")
        try: os.makedirs(prefix+"/bin")
        except: pass
        try: os.symlink(os.getenv("SPACK_CC"),prefix+"/bin/cc")
        except: pass
        try: os.symlink(prefix+"/bin/cc",prefix+"/bin/gcc")
        except: pass
        try: os.symlink(os.getenv("SPACK_CXX"),prefix+"/bin/c++")
        except: pass
        try: os.symlink(prefix+"/bin/c++",prefix+"/bin/g++")
        except: pass
        try: os.symlink(os.getenv("SPACK_FC"),prefix+"/bin/fc")
        except: pass
        try: os.symlink(os.getenv("SPACK_F77"),prefix+"/bin/f77")
        except: pass
        pass

# Beware, here be dragons.  Below this you will find the
# implementation of a metapackage.
    
    def do_install(self,
                   keep_prefix=False,
                   keep_stage=False,
                   install_deps=True,
                   skip_patch=False,
                   verbose=False,
                   make_jobs=None,
                   run_tests=False,
                   fake=False,
                   explicit=False,
                   dirty=None,
                   **kwargs):
        """
        Implement a metapackage by setting the stage to a fixed
        directory (i.e. DIYStage()), and then calling the
        do_install method for the base class.
        """
        # There isn't any source for this, so just use the current directory.
        self._stage = spack.stage.DIYStage(".")
        super(Release, self).do_install(
            keep_prefix=keep_prefix,
            keep_stage=keep_stage,
            install_deps=install_deps,
            fake=fake,
            skip_patch=skip_patch,
            verbose=verbose,
            make_jobs=make_jobs,
            run_tests=run_tests,
            dirty=dirty,
            **kwargs)
        pass

