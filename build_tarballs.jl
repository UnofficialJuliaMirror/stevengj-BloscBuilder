using BinaryBuilder

# Collection of sources required to build Blosc
sources = [
    "https://github.com/Blosc/c-blosc.git" =>
    "88864b5fb759d12a0b32c47ad9f0436d00adea88", # v1.14.3
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/c-blosc

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_TESTS=Off -DBUILD_BENCHMARKS=Off ..
make && make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms() # build on all supported platforms

# FreeBSD doesn't work yet: BinaryBuilder.jl#232
platforms = filter!(p -> !(p isa FreeBSD), platforms)

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libblosc", :libblosc),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "Blosc", sources, script, platforms, products, dependencies)

println("Contents of ", pwd(), " = ", readdir("."))
if isdir("products")
    println("PRODUCTS = ", readdir("products"))
else
    println("products/ directory not found")
end
