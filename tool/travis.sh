#!/bin/bash

# Fast fail the script on failures.
set -e

# Install global tools.
pub global activate tuneup

pub global activate grinder

# Verify that the libraries are error free.
pub global run tuneup check

# Run the tests.
pub run test

grind testdartfmt
