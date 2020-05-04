#!/usr/bin/env bash
set -ex

export PATH="/app/bin:/app/R/lib/R/bin:$PATH"
export R_PROFILE=/app/R/etc/Rprofile.site
export LD_LIBRARY_PATH=/app/R/lib/R/lib

DIR="$(dirname "$(readlink -f "$BASH_SOURCE")")"

R --version
Rscript -e 'sessionInfo()'

# List R devel dependencies
gcc --version
g++ --version
gfortran --version

# List shared library dependencies (e.g. BLAS/LAPACK)
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(R RHOME)/lib ldd $(R RHOME)/lib/libR.so

# Install a package with C/C++ and Fortran code, which links against libR, BLAS, LAPACK
R CMD INSTALL $DIR/testpkg --clean
Rscript $DIR/testpkg/tests/test.R

# R tests
Rscript $DIR/test.R
