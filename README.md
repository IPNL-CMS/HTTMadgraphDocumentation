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

Modify the Makefile to specify to SysCalc the path to lhapdf-config (the same than the one you gave to Madgraph previously):
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


# How to use and run Madgraph

## Import model

First you need to copy `Massive_Higgs_UFO` model into `MG5_aMC_v2_3_3/models` directory.

## Generate template

You can now generate your template using Madgraph. Let try to generate a scalar Higgs with a mass of 500 GeV, a width of 50 GeV and a coupling to ttbar of 1.  Here are the different syntax to generate signal and interference separately.

```bash
myWorkingArea> cd MG5_aMC_v2_3_3/
MG5_aMC_v2_3_3> ./bin/mg5_aMC
```

- Generate signal only
```bash
MG5_aMC> import model Massive_Higgs_UFO
MG5_aMC> generate p p > h0 > t t~
MG5_aMC > output template_pp_h0_tt_S
```

- Generate interference only
```bash
MG5_aMC> import model Massive_Higgs_UFO
MG5_aMC> generate p p > t t~ / a0 HIG=2 HIG^2==2
MG5_aMC > output template_pp_h0_tt_i
```

**WARNING!** Using this last squared order syntax, it is not possible to then decay the particles, neither in Madgraph nor in MadSpin, as reported in [Madgraph launchpad](https://bugs.launchpad.net/mg5amcnlo/+bug/1511378). As you can see in the bug report, there is no "elegant" solution to this problem, and we have found dirty hacks to get around this problem which is the following:
Generate Signal+Interferene template using `generate g g > t t~ / a0 HIG=2` syntax, and we then remove signal part from matrix element calculation by modifying the code by hand. This is equivalent to copying matrix element computation code `matrix1.f` generated when we use squared order syntax:

```bash
MG5_aMC_v2_3_3> cp template_pp_h0_tt_i/SubProcesses/P1_gg_ttx/matrix1.f template_gg_h0_tt_S_i//SubProcesses/P1_gg_ttx/.
```

## Generate events

Now you have to edit the run, param and process cards which can be found in `myTemplate/Cards`.
Use `param_card.dat` and `run_card.dat` which are provided here.

- Some words about the `param_card`:

Edit the `param_card` to specify the type (scalar/pseudoscalar), the mass and the width of the particle you want to generate. For example, in the case you want to generate a scalar Higgs  with a mass of 500 GeV, a width of 50 GeV and a coupling to ttbar of 1, set H0 mass to 500 GeV, its width to 50 GeV and make sure that the coupling of A0 to ttbar is set to 0. Finally, your `param_card` should look like:

```
Block a0params 
    1 0.000000e+00 # gA0tt 

Block frblock 
    1 5.000000e+01 # H0Width 

Block h0params 
    1 1.000000e+00 # gH0tt 

Block mass 
  6000045 5.000000e+02 # MH0 
```

- Some words about the `run_card`:
Here are some comments about the values set in the `run_card`:
⋅⋅* `nevents`: Specify the number of unweighted events you want to generate
⋅⋅* `ebeam1(2)`: Set total energy for beam 1 (2) (6500 GeV each for sqrt(s) = 13 TeV)
..* `lhaid`: LHAPDF ID, which can be found [here](https://www.hepforge.org/archive/lhapdf/pdfsets/6.1.6/pdfsets.index) or in `myWorkingArea/share/LHAPDF/pdfsets.index`
..* `dynamical_scale_choice`: has to be set to 2 to have the sum of signal (S) cross-section and interference (i) cross-section equal to (S+i) cross-section, i.e  (S+i) = (S)+(i). See [bug report](https://bugs.launchpad.net/mg5amcnlo/+bug/1449395) for more details.
..* `maxjetflavor`: if set to 5, then b mass has to be set to 0 (see [here]( https://twiki.cern.ch/twiki/bin/viewauth/CMS/QuickGuideMadGraph5aMCatNLO)). These values, as well as the one for `xqcut`, has an impact in case you want to generate extra jets.
..* `use_syst`: has to be set to `True` to enable systematics studies with SystCalc

- Running Madevent

You can now generate your events using Madevent. Enable Madspin to perform the decay of your particles.
```bash
MG5_aMC_v2_3_3> cd myTemplate
myTemplate> ./bin/madevent
myTemplate> launch
> madspin=ON 
```

*Remark:* By default, Madspin will decay your particles inclusively. You can specify the decay mode of your particle by adding a `madspin_card.dat` to your template cards directory. See [this example](https://github.com/cms-sw/genproductions/blob/master/bin/MadGraph5_aMCatNLO/cards/examples/wplustest_4f_NLO/wplustest_4f_NLO_madspin_card.dat) of `madspin_card`.

Your LHE file (`unweighted_events.lhe`) has been created in a directory called for example `myTemplate/Events/run_01_decayed_1`

- Running SysCalc

You can now run SysCalc on the LHE you have just created.

SysCalc usage is:
```
./sys_calc inputfile configfile outfile
```

where:
1. `inputfile` is a valid input file (typically a lhe file generated be MG5_aMC with the option use_syst=T
2. `configfile` is a file as described below
3. `outputfile` is the place where to write the output file. 

An example of configuration file can be found on [SysCalc documentation](https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki/SysCalc).

You can use the configuration file provided here (`syscalc_config.dat`), which is taken from the [official CMS gridpack production](https://github.com/cms-sw/genproductions/blob/master/bin/MadGraph5_aMCatNLO/runcmsgrid_LO.sh#L60).

Run SysCalc:
```bash
MG5_aMC_v2_3_3> ./SysCalc/sys_calc myTemplate/Events/run_01_decayed_1/unweighted_events.lhe syscalc_config.dat myTemplate/Events/run_01_decayed_1/final.lhe
```

- Quick check of LHE content

You can use `lhe_reader_non_decayed.c` script to quickly check what is in your LHE file.

Compilation:
```
g++ lhe_reader_non_decayed.c -o lhe_reader -I`root-config --incdir` `root-config --libs`
```

Usage:
```
./lhe_reader_non_decayed unweighted_events (LHE file name without .lhe)
```



