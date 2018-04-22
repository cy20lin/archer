#!/bin/bash
prefix="${1-/usr/local}"
cp "./bin" "${prefix}" -R
cp "./lib" "${prefix}" -R
