#!/bin/bash

# ------------------------------------------------------------------------------
# File        : clean.sh
#
# Description : Cleans the Buildroot build environment by removing all generated
#               build artifacts and restoring the source tree to a clean state.
#
# Purpose     : Used to reset Buildroot configuration and outputs before a fresh
#               build.
#
# Author      : Rajkumar Saravanakumar
# ------------------------------------------------------------------------------

# Navigate to the Buildroot directory (relative to script location)
cd $(dirname "$0")/buildroot

# Run full Buildroot cleanup (removes build artifacts, config, and outputs)
make distclean

echo "Buildroot has been cleaned."