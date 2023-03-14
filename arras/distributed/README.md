# Arras distributed

This folder contains components used to run Arras in distributed mode.

**arras4_node** is a C++ service that runs on every Arras pool host. It has several jobs:

- register the available CPUs and memory available on this host with the Arras Coordinator.
- receive requests to start computations on this machine, and spawn the computation processes
- notify Coordinator when the computation processes report themselves ready to start
- tell the computations to begin running on receiving the start signal from Coordinator
- relay messages between local computations and nodes running on other machines
- monitor computations for unexpected termination, and stop them on request from Coordinator.

**Coordinator** is a central service that handles allocation of hosts to a distributed session and coordinated startup/shutdown of the session. It is not involved in normal message transmission between computations once the session is running. This directory contains a very simple Python implementation of Coordinator called **minicoord**. The coordinator used in production at DWA is a Java service not included here.