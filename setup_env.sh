#! /bin/bash

echo "Sourcing root"
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/lcg/root/5.34.17-cms/bin/thisroot.sh

source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/libjpg/8b/etc/profile.d/init.sh
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/libpng/1.6.0-cms/etc/profile.d/init.sh

echo "Sourcing gcc / gdb"
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/gcc/4.8.1/etc/profile.d/init.sh;
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/gdb/7.7/etc/profile.d/init.sh;

echo "Sourcing python"
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/python/2.7.3-cms/etc/profile.d/init.sh

echo "Sourcing liblzma"
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/xz/5.0.3__5.1.2alpha-cms5/etc/profile.d/init.sh

echo "Sourcing boost"
source /cvmfs/cms.cern.ch/slc6_amd64_gcc481/external/boost/1.51.0-cms/etc/profile.d/init.sh

export BOOST_ROOT=$BOOST_ROOT

