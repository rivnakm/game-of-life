all: gcc
gcc:
	meson setup build_gcc
	meson setup --reconfigure build_gcc
	meson configure -Dbuildtype=release build_gcc
	ninja -C build_gcc

clang:
	CXX=clang++ meson setup build_clang
	CXX=clang++ meson setup --reconfigure build_clang
	CXX=clang++ meson configure -Dbuildtype=release build_clang
	CXX=clang++ ninja -C build_clang

clean:
	ninja -C build_clang clean
	ninja -C build_gcc clean