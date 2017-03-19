from spack import *

class Gegede(Package):
    """
    From the README: The General Geometry Description (GGD) is a
    software system to generate a description of a constructive solid
    geometry specifically as used by Geant4 or ROOT applications are
    as represented in GDML files. It is implemented as a pure Python
    module gegede.
    """
    homepage = "https://github.com/brettviren/gegede/"
    url      = "https://github.com/brettviren/gegede/"

    version('master', git='https://github.com/brettviren/gegede.git')

    extends('python')

    depends_on("root")
    depends_on("libxslt")
    depends_on("py-setuptools")

    def install(self, spec, prefix):
        python('setup.py', 'install', '--prefix=%s' % prefix)

