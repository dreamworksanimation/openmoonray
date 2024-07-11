Building MoonRay on macOS Sonoma (macOS 14)

Base requirements:
- macOS Sonoma (macOS 14)
- Install Xcode
- Download and install CMake 3.26.5
    https://github.com/Kitware/CMake/releases/download/v3.26.5/cmake-3.26.5-macos-universal.dmg
    sudo "/Applications/CMake.app/Contents/bin/cmake-gui" --install

Create a clean root folder for moonray.  Attempting to build atop a previous installation may cause issues.

1. Create the folders
    ```
    mkdir -p /Applications/MoonRay/{installs,build,build-deps,source}
    mkdir -p /Applications/MoonRay/installs/{bin,lib,include}
    ```

2. Check out the OpenMoonRay source - alongside `installs/`
    ```
    cd /Applications/MoonRay/source
    git clone --recurse-submodules <repository>
    cd ..
    ln -s source/openmoonray/building .
    ln -s source/openmoonray .
    ```

3. Build the dependencies - alongside `source/` and `installs/`
    ```
    cd /Applications/MoonRay/build-deps
    cmake ../building/macOS
    cmake --build .
    ```

4. Build MoonRay
    ```
    cd /Applications/MoonRay/openmoonray
    cmake --preset container-macOS
    cmake --build --preset container-macOS

5. Run / test
    ```
    source /Applications/MoonRay/installs/openmoonray/scripts/setup.sh
    cd /Applications/MoonRay/openmoonray/testdata
    moonray_gui -exec_mode xpu -info -in curves.rdla
    ```

7. Cleanup
    ```
    rm -rf /Applications/MoonRay/{build,build-deps,openmoonray/release}
    ```
