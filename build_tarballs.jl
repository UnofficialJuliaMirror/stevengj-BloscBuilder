using BinaryBuilder

# Collection of sources required to build MbedTLS
sources = [
    "https://github.com/Blosc/c-blosc.git" =>
    "917e0a5906da0a70423f2307cd2685e8683bc1ff", # v1.14.2
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd c-blosc
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_STATIC=Off -DBUILD_TESTS=Off -DBUILD_BENCHMARKS=Off ..
make && make install
if [ $target == "x86_64-w64-mingw32" ]; then
    cp $prefix/lib/*.dll $prefix/bin/.
elif [ $target == "i686-w64-mingw32" ]; then
    cp $prefix/lib/*.dll $prefix/bin/.
else
    cd $prefix/lib; for f in $(find . -name '*.so'); do strip $f ; done
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),
    Windows(:x86_64),
    Windows(:i686),
    MacOS()
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libblosc", :libblosc),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "ZMQ", sources, script, platforms, products, dependencies)
