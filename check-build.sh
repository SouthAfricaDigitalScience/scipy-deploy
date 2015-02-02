module load ci
module load python
module add gcc/4.8.2
module add lapack
module add fftw3/3.3.4
module add numpy

echo $LD_LIBRARY_PATH
echo ""
cd $WORKSPACE/$NAME-$VERSION
python setup.py check

echo $?
if [ $? != 0 ] ; then
  exit 1
fi

python setup.py install --prefix=$SOFT_DIR

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       SCIPY_VERSION       $VERSION
setenv       SCIPY_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(SCIPY_DIR)/lib64
prepend-path PYTHONPATH   $::env(SCIPY_DIR)/lib64/python2.6/site-packages
MODULE_FILE
) > modules/$VERSION

mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME
