from spack import *
import spack
import os
import datetime

class Release(Package):
    """A metapackage to release the entire shebang for dune-ndx."""

    url = "https://github.com/ClarkMcGrew/dune-ndx/"
    homepage = "https://github.com/ClarkMcGrew/dune-ndx/"

    #The version which installs the latest copy of the release.  It's
    #not a number to emphasize that it's "moving"
    version('develop', url='dummy')
    version('1.0.0', url='dummy')
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

    # The necessary support software.  This should only include
    # packages that are independently required.  It's not a good idea
    # to list all the packages that the later dependencies require.
    # Initially, this includes cmake which is going to be needed by
    # users, and environment-modules which is needed to maintain the
    # environment.
    depends_on("cmake")
    depends_on("environment-modules")
    
    # The ROOT dependencies
    depends_on("root+gdml+debug@6.08.02", when="@1.0.0:")
    depends_on("root@5.34.36", when="@0.0.0:0.0.99")

    # The GEANT4 dependencies
    depends_on("geant4~qt+debug@10.02.p02", when="@1.0.0:")
    depends_on("geant4~qt+debug@10.02.p02", when="@0.0.0:0.0.99")

    # depends_on("edep-sim")

    # depends_on("dunendggd")
    
    def install(self,spec,prefix):
        """Create a file in the installation area.  This serves two purposes.
        First, it records what has been installed, and that will be
        copied to any views.  Second, it lets spack know that
        something was installed.
        """
        releaseFile = open(prefix + "/dune-ndx.release",'a')
        print >>releaseFile, "Package:", self.name + "@" + str(self.version)
        print >>releaseFile, "Installation Date:", datetime.datetime.today()
        print >>releaseFile, "C Compiler:", os.getenv("SPACK_CC")
        print >>releaseFile, "C++ Compiler:", os.getenv("SPACK_CXX")
        print >>releaseFile, "F90 (fc) Compiler:", os.getenv("SPACK_FC")
        print >>releaseFile, "F77 Compiler:", os.getenv("SPACK_F77")
        # Setup compiler executables so that everything uses the right
        # compiler.  This overrides the system default, and links to
        # the compiler that SPACK chose for this installation.
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
# implementation of a metapackage.  And by "metapackage", I mean that
# it's disabled most of the features of a real package so that it just
# installs stuff without there being any real source.

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

