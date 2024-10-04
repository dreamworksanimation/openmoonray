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

    Note: If building for Houdini, you'll potentially need to make the following changes before proceeding:
    * Edit source/openmoonray/CMakeMacOSPresets.json to update HOUDINI_INSTALL_DIR
    * Edit source/openmoonray/scripts/macOS/setupHoudini.sh to update HOUDINI_PATH
    * Edit source/openmoonray/building/macOS/pxr-houdini/pxrTargets.cmake to update HPYTHONLIB, HPYTHONINC and INTERFACE_INCLUDE_DIRECTORIES
    ```

3. Build the dependencies - alongside `source/` and `installs/`
    Note: If building for Houdini you'll need to build moonray against Houdini's USD libraries.
    You'll want to skip building USD during this step by adding -DNOUSD=1 to the first cmake
    command below: `cmake -DNO_USD=1 ../building/macOS`
    ```
    cd /Applications/MoonRay/build-deps
    cmake ../building/macOS
    cmake --build .
    ```

4. Build MoonRay
    Note: If building for Houdini, replace macos-release presets below with macos-houdini-release
    ```
    cd /Applications/MoonRay/openmoonray
    cmake --preset macos-release
    cmake --build --preset macos-release
    ```

5. Run / test
    ```
    source /Applications/MoonRay/installs/openmoonray/scripts/setup.sh
    cd /Applications/MoonRay/openmoonray/testdata
    moonray_gui -exec_mode xpu -info -in curves.rdla
    ```

    HOUDINI:
    Open "Houdini Terminal" in Applications and run:
    ```
    source /Applications/MoonRay/openmoonray/scripts/macOS/setupHoudini.sh
    houdini
    ```

    In the Main menu bar at top select Desktop->Solaris
    In the Scene View tab on the main window, change from "obj" to "stage".
    Click in the Solaris network editor, hit tab, type "sphere" and hit enter to place a sphere on the stage.
    In the viewport menu, click on "Persp" and select "Moonray", this should trigger rendering.

7. Cleanup
    ```
    rm -rf /Applications/MoonRay/{build,build-deps,openmoonray/release}
    ```
