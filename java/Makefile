# Copyright (c) 2015-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD+Patents license found in the
# LICENSE file in the root directory of this source tree.

-include ../makefile.inc

HEADERS = $(wildcard ../*.h)

all: cpu build

#############################
# CPU

cpu: libswigfaiss.$(SHAREDEXT)

# Also silently generates swigfaissJNI.java.
swigfaiss_wrap.cpp: swigfaiss.swig $(HEADERS)
	$(SWIG4) -java $(JAVASWIGFLAGS) -c++ -Doverride= -I../ -o $@ $<

swigfaiss_wrap.o: swigfaiss_wrap.cpp
	$(CXX) $(CXXFLAGS) $(CPUFLAGS) $(JAVACFLAGS) -I../ -c $< -o $@

libswigfaiss.$(SHAREDEXT): swigfaiss_wrap.o ../libfaiss.a
	$(CXX) $(SHAREDFLAGS) $(LDFLAGS) -o $@ $^  $(LIBS)


##############################
## GPU - TODO: Untested
#
#gpu: libswigfaiss_gpu.$(SHAREDEXT)
#
## Also silently generates swigfaissJNI.java.
#swigfaiss_gpu_wrap.cpp: swigfaiss.swig
#	$(SWIG4) -java -c++ -noproxy -Doverride= -I../ -DGPU_WRAPPER -o $@ $<
#
#swigfaiss_gpu_wrap.o: swigfaiss_gpu_wrap.cpp
#	$(NVCC) $(NVCCFLAGS) $(JAVACFLAGS) -I../ -c $< -o $@
#
#libswigfaiss_gpu.$(SHAREDEXT): swigfaiss_gpu_wrap.o ../gpu/libgpufaiss.a ../libfaiss.a
#	$(CXX) $(SHAREDFLAGS) $(NVCCLDFLAGS) $(LDFLAGS) -o $@ $^ $(NVCCLIBS) $(LIBS)

build: cpu
	./setup.sh

# TODO: Improve or remove this target - currently an alias for 'build' target
install: build

clean:
	rm -f swigfaiss_wrap.cpp swigfaiss_gpu_wrap.cpp
	rm -f swigfaiss_wrap.o swigfaiss_gpu_wrap.o
	rm -f libswigfaiss.$(SHAREDEXT)
	rm -rf ./src/com/github/facebookresearch/faiss/*
	rm -rf ./out/*
	rm -rf ./dist/*

#.PHONY: all build clean cpu gpu install
.PHONY: all build clean cpu install
