# Presentation

This is the instructions to generate scalar and pseudoscalar massive Higgs signal and create corresponding LHE files.

# Madgraph installation

## Setup the environment

First of all, you have to setup the enviroment:

```bash
myWorkingArea> source setup_env.sh
```

## LHAPDF installation

- Download and install LHAPDF:

Then you need to install the last version of LHAPDF.

**WARNING!** Depending on the version of SysCalc Madgraph tool (see later) you will have to adapt the version of LHAPDF (version 5 or 6).


```bash
myWorkingArea> curl -O -L https://www.hepforge.org/archive/lhapdf/LHAPDF-6.1.6.tar.gz
myWorkingArea> cd LHAPDF-6.1.6
LHAPDF-6.1.6> ./configure --prefix=$PWD/..
LHAPDF-6.1.6> make -j20
LHAPDF-6.1.6> make install
LHAPDF-6.1.6> cd ..
```

- Get LHAPDF set:

You may want to install different PDF sets. For example, to get CT10nlo PDF set, proceed as follow:

```bash
myWorkingArea> cd share/LHAPDF/
LHAPDF> curl -O -L https://www.hepforge.org/archive/lhapdf/pdfsets/6.1.6/CT10nlo.tar.gz
LHAPDF> tar xf CT10nlo.tar.gz
LHAPDF> rm CT10nlo.tar.gz
LHAPDF> cd ../../
```

In our case, a script is installing automatically the different PDF sets needed for PDF and scale weight computation by SysCalc tool used in the [official CMS gridpack production](https://github.com/cms-sw/genproductions/blob/master/bin/MadGraph5_aMCatNLO/runcmsgrid_LO.sh#L60):

```bash
myWorkingArea> ./install_PDF_set.sh 
```

## Madgraph installation

You can find usefull informations on [Madgraph wiki](https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki).

- Download Madgraph:

```bash
myWorkingArea> curl -O -L https://launchpad.net/mg5amcnlo/2.0/2.3.0/+download/MG5_aMC_v2.3.3.tar.gz
myWorkingArea> tar xf MG5_aMC_v2.3.3.tar.gz
myWorkingArea> rm MG5_aMC_v2.3.3.tar.gz
```

- Configure Madgraph to use our LHAPDF:
```bash
myWorkingArea> cd MG5_aMC_v2_3_3/input
```

Edit `mg5_configuration.txt`:
```
lhapdf = <path_to_lhapdf-config> (something like /path/to/myWorkingArea/bin/lhapdf-config)
```

## SysCalc installation

SysCalc is a Madgraph module to produce the systematic uncertainty band by reweighting method. You'll find usefull information on [Madgraph wiki](https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki/SysCalc).

To install it, you can dowload it via:
```bash
myWorkingArea> curl -O -L http://madgraph.hep.uiuc.edu/Downloads/SysCalc_V1.1.6.tar.gz
```

Or use Madgraph prompt directly:
```bash
myWorkingArea> cd MG5_aMC_v2_3_3/
MG5_aMC_v2_3_3> ./bin/mg5_aMC
MG5_aMC> install SysCalc
```

This last command should install everything for you automatically, but it is possible that the compilation failes. In particular it can complain on LHAPDF location.
You will have to check the compilation error and run make manually.

Modify the Makefile to tell SysCalc the path to lhapdf-config (the same than the one you gave to Madgraph previously):
```bash
MG5_aMC_v2_3_3> cd SysCalc/src
src> vi Makefile
```

The first lines of the Makefile should look like:
```
COPTS = -O -DDROP_CGAL
INCLUDES = -I../include -I$(shell  /path/to/myWorkingArea/bin/lhapdf-config --incdir)
OBJECTS = SysCalc.o tinyxml2.o alfas_functions.o
LIBS = $(shell  /path/to/myWorkingArea/bin/lhapdf-config --ldflags)
```

Then recompile:
```bash
src> make
```

Madgraph is now ready to run!



