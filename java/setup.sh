#!/bin/bash

# Make a top-level directory for the java compiled classes and a sub-directory for the native library
mkdir -p ./out/resources

# Compile the java classes
javac -d ./out/ $(find ./src/ -name "*.java");

# Copy the native library to the output folder
#TODO: Reference to library file should be platform specific (i.e., .so for Linux; .dylib for Mac)
cp "libswigfaiss.dylib" ./out/resources/;

# Package the compiled java and native library into a jar
jar cvf ./dist/swigfaiss.jar -C ./out/ .;
