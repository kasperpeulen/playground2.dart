#!/bin/bash

# Fast fail the script on failures.
set -e

# Install global tools.
pub global activate tuneup

# Verify that the libraries are error free.
pub global run tuneup check

# Run the tests.
pub run test

dart tool/grind.dart analyze

dart tool/grind.dart testdartfmt
