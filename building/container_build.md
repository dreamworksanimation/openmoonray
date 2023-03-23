# Building MoonRay in a Docker container

You will need Docker and a copy of the MoonRay source. The instructions assume that the source is in */source/openmoonray*

NVIDIA Optix headers need to be downloaded manually from [here](https://developer.nvidia.com/designworks/optix/downloads/legacy), since they require a EULA.
Be sure to download version 7.3, as MoonRay is not yet compatible with their more recent releases.  The Optix installer must be renamed `optix.sh` and placed in the top level of the checkout.

---
## Step 1. build docker
---

Build using the `Dockerfile` in the top level of the MoonRay source.  The build requires `optix.sh` to be present, and the correct version.  Download the installer from the link above, and rename it to `optix.sh`.  By default, the build uses 64 compile jobs, this may be adjusted using `--build-arg BUILD_JOBS=8`.

```bash
docker build --tag openmoonray/moonray .
# docker build --build-arg BUILD_JOBS=8 --tag openmoonray/moonray .
```

If using [podman](https://podman.io/), the `--format docker` flag is required

```bash
docker build --format docker --tag openmoonray/moonray .
```

To execute `moonray` on an input file, the host filesystem must be mounted in the Docker image using `/project` as the default.  `openmoonray` is the entrypoint in the Docker image.  To render `testdata/rectangle.rdla`, mount the top level of the MoonRay source to `/project` with relative arguments.  The `testdata/rectangle.rdla` will be mapped to `/project/testdata/rectangle.rdla` within the Docker container.  Because the working directory is `/project` the same relative paths will be used.

```bash
docker run --rm -v $(pwd):/project openmoonray/moonray -info -in testdata/rectangle.rdla -out testdata/rectangle.exr 
```

---
## Step 2. build gui docker
---

The `gui` directory contains a `Dockerfile` for building on the `openmoonray/moonray` image in the previous step.  It uses [`noVNC`](https://github.com/novnc/noVNC) and [`easy-novnc`](https://github.com/pgaskin/easy-novnc) to host the gui in a web browser.  If building under `podman`, the `SHELL` command warning may be ignored, or suppressed using the `--format docker` flag.

```bash
docker build --tag openmoonray/moonray-gui ./gui
```

To run the `moonray_gui` launch the docker, then open `http://localhost:8080` to interact with the desktop.  The VNC password is `moonray`.

```bash
docker run -it --rm -v $(pwd):/project -p 8080:8080 openmoonray/moonray-gui
```

Click "Use default config" when the  `xfce` window manager asks for the initial setup, and the "XFCE PolicyKit Agent" error can be ignored. Click the terminal icon in the bottom tray to open a terminal then run the `moonray_gui` application.

```bash
# in GUI terminal window
moonray_gui -in testdata/rectangle.rdla
```

![screenshot](moonray_gui_screenshot.png)
