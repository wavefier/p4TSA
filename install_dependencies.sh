#!/bin/bash

if [ -z "$ENV_ROOT" ]; then
    export ENV_ROOT=`realpath ..`/root
fi
if [ ! -d "$ENV_ROOT" ]; then
    mkdir -p $ENV_ROOT
fi
if [ -z "$ENV_TMP" ]; then
    export ENV_TMP=`realpath ..`/tmp
fi
if [ ! -d "$ENV_TMP" ]; then
    mkdir -p $ENV_TMP
fi
rm -rf $ENV_TMP/*


 

pip install -U pip
pip install numpy
pip install -r requirements.txt
pip install pybind11

pushd $ENV_TMP
git clone https://github.com/pybind/pybind11.git
pushd  pybind11
python setup.py install
cp -fr ./include/pybind11/ ${ENV_ROOT}/include/
popd
popd 

# ----------------------------------------------------------
#
# cmake installation
#

pushd $ENV_TMP
wget https://cmake.org/files/v3.8/cmake-3.8.0-rc1.tar.gz
tar xfz cmake-3.8.0-rc1.tar.gz
pushd cmake-3.8.0-rc1
./configure --prefix=${ENV_ROOT}
make VERBOSE=0 && make install
popd
popd
export PATH=${ENV_ROOT}/bin:{PATH}
export ENV_ROOT=$ENV_ROOT
export CMAKE_ROOT=${ENV_ROOT}/share/cmake-3.8

# ----------------------------------------------------------
#
# Installing basic environment
#
shopt -s nullglob

#################gsl
pushd $ENV_TMP

wget ftp://ftp.gnu.org/gnu/gsl/gsl-2.3.tar.gz
tar xzf gsl-2.3.tar.gz
cd gsl-2.3
./configure --prefix=${ENV_ROOT}
make -j7
make install

#########Frame
pushd $ENV_TMP
wget http://lappweb.in2p3.fr/virgo/FrameL/libframe-8.30.tar.gz
tar xfz libframe-8.30.tar.gz
cd libframe-8.30
./configure --prefix=${ENV_ROOT}
make VERBOSE=0
make install
cp -fr ./src/Fr*.h ${ENV_ROOT}/include 
export PATH=${ENV_ROOT}/bin:${ENV_ROOT}/include:{PATH}
export LD_LIBRARY_PATH=${ENV_ROOT}/lib:${LD_LIBRARY_PATH}        

