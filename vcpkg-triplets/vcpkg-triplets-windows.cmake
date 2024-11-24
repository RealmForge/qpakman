
# lib-png port doesn't work with static linking :/
set(VCPKG_TARGET_TRIPLET x64-windows)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)