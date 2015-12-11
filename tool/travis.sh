#!/bin/bash

# Fast fail the script on failures.
set -e

# Install global tools.
pub global activate tuneup

# Verify that the libraries are error free.
pub global run tuneup check

# Run the tests.
pub run test

# Verify that the generated grind script analyzes well.
dart tool/grind.dart analyze