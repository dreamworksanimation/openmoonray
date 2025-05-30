Building MoonRay on Rocky Linux 9

Requires CMake 3.23.1 (or greater)

If you want to include MoonRay GPU support, you will also need to download the NVIDIA Optix headers
(from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy)), which require an EULA.
Be sure to download version 7.3, as MoonRay is not yet compatible with their more recent releases.
Once you have extracted the download contents, note the location of the header files (under *include*): these will be copied to */usr/local/include* in step 3 below.

---
## Step 1. Create the folders
---
    Create a clean root folder for moonray.  Attempting to build atop a previous installation may cause issues.
    These can be created in the location of your choosing, but these instruction, the provided CMake presets,
    and several of the scripts mentioned in these instructions assume this location/structure.
    ```
    mkdir -p /opt/MoonRay/{installs,build,build-deps,source}
    mkdir -p /opt/MoonRay/installs/{bin,lib,include}
    ```
## Base Requirements
* CMake 3.23.1 (or greater)

* If you want to include MoonRay GPU support (XPU mode), you will also need to download the NVIDIA Optix headers
    (from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy)), which require an EULA.
    Be sure to download version 7.6, as MoonRay is not yet compatible with their more recent releases.
    Once you have extracted the downloaded contents, note the location of the header files (under *include*): these will be copied to */usr/local/include* in step 3 below.

---
## Step 2. Clone the OpenMoonRay source
---
    ```
    cd /opt/MoonRay/source
    git clone --recurse-submodules https://github.com/dreamworksanimation/openmoonray.git
    cd ..

    Note: If building for Houdini, you'll potentially need to make the following changes before proceeding:
    * Edit source/openmoonray/CMakeLinuxPresets.json to update HOUDINI_INSTALL_DIR
    * Edit source/openmoonray/scripts/Rocky9/setupHoudini.sh to update HOUDINI_PATH
    * Edit source/openmoonray/building/Rocky9/pxr-houdini/pxrTargets.cmake to update HPYTHONLIB, HPYTHONINC if needed
    ```

---
### Step 2. Clone the OpenMoonRay source
```bash
sudo dnf install -y git git-lfs
cd /opt/MoonRay/source
git clone --recurse-submodules https://github.com/dreamworksanimation/openmoonray.git
```

    ```bash
    cp -r /tmp/optix/include/* /usr/local/include
    ```

---
<<<<<<< HEAD
## Step 4. Build the remaining dependencies from source
---
    Note: If building for Houdini you'll need to build moonray against Houdini's USD libraries.
    You'll want to skip building USD during this step by adding -DNOUSD=1 to the first cmake
    command below: `cmake -DNO_USD=1 ../source/openmoonray/building/Rocky9`.  You should clean
    the build-deps/ and installs/ directory if you have previously installed the dependencies
    without passing -DNOUSD=1, to remove any USD related files or step 5 may fail to link to
    Houdini's USD libs.
    ```
    cd build-deps
    cmake ../source/openmoonray/building/Rocky9
    cmake --build . -- -j $(nproc)
    ```
||||||| parent of 8819681 (Fix typo in rocky9_build.md (#156))
### Step 3. Install some of the dependencies via script/package manager
```bash
sudo source/openmoonray/building/Rocky9/install_packages.sh
sudo dnf install -y cuda-toolkit
```
You can add arguments `--nocuda` and `--noqt` to skip GPU and GUI support respectively.
If you are building with GPU support, copy the Optix headers that you downloaded and extracted into */usr/local*
=======
### Step 3. Install some of the dependencies via script/package manager
```bash
sudo source openmoonray/building/Rocky9/install_packages.sh
sudo dnf install -y cuda-toolkit
```
You can add arguments `--nocuda` and `--noqt` to skip GPU and GUI support respectively.
If you are building with GPU support, copy the Optix headers that you downloaded and extracted into */usr/local*
>>>>>>> 8819681 (Fix typo in rocky9_build.md (#156))


---
## Step 5. Build MoonRay
---
    Note: If building for Houdini, replace macos-release presets below with rocky9-houdini-release
    ```
    cd /opt/MoonRay/source/openmoonray
    cmake --preset rocky9-release
    cmake --build --preset rocky9-release -- -j $(nproc)
    ```

---
## Step 6. Run/Test
---
    ```
    source /opt/MoonRay/installs/openmoonray/scripts/setup.sh
    cd /opt/MoonRay/source/openmoonray/testdata
    moonray_gui -exec_mode xpu -info -in curves.rdla
    ```

    HOUDINI:
    Open a terminal and run:
    ```
    cd /opt/hfs20.0  # location of houdini install
    source houdini_setup
    source /opt/MoonRay/source/openmoonray/scripts/Rocky9/setupHoudini.sh
    houdini
    ```

    In the Main menu bar at top select Desktop->Solaris
    In the Scene View tab on the main window, change from "obj" to "stage".
    Click in the Solaris network editor, hit tab, type "sphere" and hit enter to place a sphere on the stage.
    In the viewport menu, click on "Persp" and select "Moonray", this should trigger rendering.

---
## Step 8. Post-build/install Cleanup
---
    ```
    rm -rf /opt/MoonRay/{build,build-deps}
    ```

