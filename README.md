# Buildroot-Based Embedded Linux Distribution with Socket Server and Character Driver

## Author

Rajkumar Saravanakumar

Developed as part of the Advanced Embedded Linux Development specialization from the University of Colorado Boulder.

---

## Overview

This repository contains a custom Buildroot external tree used to build a bootable ARM64 embedded Linux distribution for QEMU, integrating custom applications, kernel modules, and supporting services.

Implemented using **Buildroot, GNU Make, and Bash scripting**.

The image integrates previously developed user-space applications, kernel modules, and scripts into a fully functional embedded Linux system, providing:

* AESD socket server - A multithreaded TCP Socket Server
* AESD character device driver - A circular buffer based device driver
* SCULL character driver
* misc-modules - Additional example kernel modules
* Automatic service initialization using SysV init scripts
* Bootable ARM64 Linux image generation for QEMU

The build process produces a complete embedded Linux image containing custom applications, kernel modules, and supporting services.

Automated validation and functional testing were performed both locally and through a GitHub Actions-based Continuous Integration (CI) pipeline.

---

## Core Repository Structure

```text
.
├── build.sh                              # Build helper script
├── runqemu.sh                            # Launch QEMU image
├── clean.sh                              # Remove build artifacts
├── save-config.sh                        # Save Buildroot configuration
├── shared.sh                             # Shared build configuration
├── full-test.sh                          # Automated image validation
├── assignment-autotest/                  # Test framework
├── buildroot/                            # Buildroot source tree
└── base_external/                        # Custom Buildroot external tree
    ├── Config.in                         # Package configuration registration
    ├── external.mk                       # Package makefile registration
    │
    ├── configs/
    │   └── aesd_qemu_defconfig           # Custom Buildroot configuration
    │
    ├── package/
    │   ├── aesd-assignments/
    │   │   ├── Config.in
    │   │   └── aesd-assignments.mk       # Server and char driver package
    │   │
    │   └── ldd/
    │       ├── Config.in
    │       └── ldd.mk                    # SCULL and misc-modules package
    │
    └── rootfs_overlay/
        └── etc/
            └── init.d/
                └── S98lddmodules         # Kernel module initialization script
```

---

## Features

* Custom ARM64 embedded Linux image generation for QEMU
* AESD multithreaded TCP socket server
* AESD circular-buffer character device driver
* LDD3 kernel modules (`hello`, `faulty`, and `scull`)
* Custom Buildroot external tree (`base_external`)
* Automated image build using Buildroot
* Integration of previously developed user-space applications, kernel modules, and scripts
* Packaging of components from external repositories through custom Buildroot packages
* Automatic service startup and shutdown using SysV init scripts
* Automatic loading and unloading of kernel modules during boot and shutdown
* Automatic device node creation and cleanup
* OpenSSH support for remote access
* Root filesystem customization
* Root account configuration
* Modular package organization through Buildroot packages
* Automated QEMU startup, image validation, and functional testing

---

## Components

### `build.sh`

Helper script used to automate image generation.

The script initializes Buildroot, applies the custom external tree configuration, and builds the complete embedded Linux image.

### `buildroot/`

Buildroot framework providing:

* Cross-compilation toolchains
* Linux kernel integration
* Root filesystem generation
* Package build infrastructure

### `base_external/Config.in`

Registers custom package configuration entries provided by the external Buildroot tree.

### `base_external/external.mk`

Discovers and registers all custom Buildroot package definitions (`.mk` files) contained within the external tree, making them available to the Buildroot build system.

### `base_external/configs/aesd_qemu_defconfig`

Custom Buildroot configuration used to generate the target image.

The file is generated after selecting required packages in menuconfig and executing `save-config.sh`

Defines:

* Target architecture
* Toolchain settings
* Linux kernel configuration
* Root filesystem options
* Package selections

### `base_external/package/aesd-assignments/aesd-assignments.mk`

Builds and installs components from the repository containing programs for custom device driver and socket server.

Components include:

* aesdsocket - A multithreaded TCP Socket Server
* aesdchar - A circular buffer based character device driver
* Character device management scripts
* Socket server management scripts

The generated image automatically starts the socket server and loads the char driver during boot, and stops the server and unloads the driver during shutdown.

### `base_external/package/ldd/ldd.mk`

Builds and installs example kernel modules from the LDD3 repository.

Components include:

* `scull`        - A RAM-based character device driver demonstrating device registration, file operations, and character driver implementation.
                   Multiple Scull devices are created and verified. 

* `misc-modules` - A collection of example kernel modules including `hello` and `faulty`, used to demonstrate kernel logging, module loading/unloading, and kernel debugging concepts.
                   Many modules under misc-modules are built, only `hello` and `faulty` are installed and tested.

### `base_external/rootfs_overlay/etc/init.d/S98lddmodules`

SysV initialization script responsible for:

* Loading the example kernel modules during startup
* Creating device nodes
* Removing device nodes during shutdown
* Unloading kernel modules during shutdown

### `run-qemu.sh`

Helper script used to launch the generated image in a QEMU ARM64 virtual machine with networking and port forwarding support.

### `save_config.sh`

Utility script used to save Buildroot and Linux kernel configuration changes into the external tree.

### `clean.sh`

Utility script used to remove Buildroot build artifacts and restore a clean build environment.

### `full-test.sh`

Automates image validation by:

* Building the image
* Booting the generated system in QEMU
* Monitoring serial output
* Verifying successful execution through the autograder framework from `assignment-autotest/`

### `assignment-autotest/`

Contains the automated validation framework used to test the image and verify all components inside the emulated target environment.

---

## Build

Build the image:

```sh
./build.sh
```

The script:

1. Initializes and updates submodules.
2. Applies the custom Buildroot configuration.
3. Registers the external Buildroot tree.
4. Builds the complete target image.

Generated artifacts include:

```text
buildroot/output/images/Image
buildroot/output/images/rootfs.ext4
```

The generated image contains the configured embedded Linux system along with the AESD socket server, AESD character device driver, and the LDD3 example kernel modules (SCULL and misc-modules).

---

## Usage

Launch the generated image:

```sh
./run-qemu.sh
```

The script:

1. Starts the QEMU ARM64 virtual machine in headless (`nographic`) mode.
2. Loads the generated Linux kernel image.
3. Mounts the generated root filesystem.
4. Configures user-mode networking with port forwarding.

Exposed services include:

* Host port `10022` → Guest SSH service (`22`)
* Host port `9000` → Guest AESD socket server (`9000`)

With a successfully built image, system initialization is handled automatically during boot:

* The AESD socket server is started automatically.
* The AESD character driver is loaded automatically.
* The SCULL driver and miscellaneous kernel modules are loaded.
* Required device nodes are created.

Once the system has booted, the drivers and socket server can be interacted with normally from within the target system or remotely through the forwarded ports.

During system shutdown, SysV scripts ensure that:

* The socket server is stopped gracefully.
* Kernel modules are unloaded.
* Associated device nodes are removed automatically.

---

## Cleaning

Remove build artifacts:

```sh
./clean.sh
```

The script executes:

```sh
make distclean
```

to restore a clean Buildroot environment.

---

## Testing

Automated testing was performed both locally and through a GitHub Actions-based Continuous Integration (CI) pipeline.

Buildroot is used to build the complete target image from scratch, including:

* Root filesystem components
* AESD socket server
* AESD character driver
* SCULL driver
* Miscellaneous kernel modules
* Associated SysV startup and shutdown scripts

Automated validation is performed using `full-test.sh`, which leverages the `assignment-autotest` framework.

The test suite verifies:

* Successful build and boot of the generated image in a QEMU ARM64 virtual machine
* Correct root filesystem contents and package installation
* Proper placement of binaries, kernel modules, and init scripts
* Automatic startup and shutdown of the socket server through SysV runlevels
* Automatic loading and unloading of kernel modules during boot and shutdown
* Device node creation and cleanup performed by initialization scripts

Functional testing includes:

* Standalone validation of the socket server
* Standalone validation of the AESD character driver
* Standalone validation of the SCULL driver
* Standalone validation of the miscellaneous kernel modules
* Integration testing of the socket server using the AESD character driver as its backend

These tests ensure that the complete embedded Linux system, including user-space applications, kernel modules, initialization scripts, and supporting services, operates correctly within the target environment.

---

## Technologies

* Buildroot
* QEMU ARM64
* Bash Scripting
* SysV Init
* Linux Kernel Modules
* OpenSSH
* Git and Git Submodules
* GitHub Actions (CI)
