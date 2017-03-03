from spack import *
import sys

class Release(Package):
    """A package to release the entire shebang."""

    # FIXME: Add a proper url for your package's homepage here.
    homepage = "http://www.example.com"
    url      = "http://www.example.com"

    version('master', url='http://www.example.com')

    # FIXME: Add dependencies if required.
    depends_on("geant4")
    depends_on("root")
    
    def do_fetch(self, mirror_only=False):
        pass

    def do_stage(self, mirror_only=False):
        pass

    def do_patch(self):
        pass

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

        # First, install dependencies recursively.
        if install_deps:
            for dep in self.spec.dependencies():
                dep.package.do_install(
                    keep_prefix=keep_prefix,
                    keep_stage=keep_stage,
                    install_deps=install_deps,
                    fake=fake,
                    skip_patch=skip_patch,
                    verbose=verbose,
                    make_jobs=make_jobs,
                    run_tests=run_tests,
                    dirty=dirty,
                    **kwargs
                )


    def do_uninstall(self, force=False):
        pass

    def configure_args(self):
        return []
    
