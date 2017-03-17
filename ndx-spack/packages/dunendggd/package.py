from spack import *

class Dunendggd(Package):
    """
    This is a tool to build proposal geometries for DUNE near detector.
    """
    homepage = "https://github.com/gyang9/dunendggd/"
    url      = "https://github.com/gyang9/dunendggd/"

    version('master', git='https://github.com/gyang9/dunendggd.git')

    extends('python')

    depends_on("gegede")
    depends_on("py-setuptools")

    def install(self, spec, prefix):
        python('setup.py', 'install', '--prefix=%s' % prefix)

