/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD+Patents license found in the
 * LICENSE file in the root directory of this source tree.
 */

// -*- C++ -*-

// This file describes the C++-Java bridge. There is 1 preprocessor macro of
// interest:
// GPU_WRAPPER: also compile interfaces for GPU

#ifdef GPU_WRAPPER
%module swigfaiss_gpu;
#else
%module swigfaiss;
#endif

// fbode SWIG fails on warnings, so make them non-fatal
#pragma SWIG nowarn=321
#pragma SWIG nowarn=403
#pragma SWIG nowarn=325
#pragma SWIG nowarn=389


#define __restrict

/******************************************************************************
 * Copied verbatim to the wrapper. Contains the C++-visible includes
 ******************************************************************************/

%{

#include <stdint.h>
#include <omp.h>
#include <iostream>

#include "Index.h"
#include "IndexFlat.h"
#include "VectorTransform.h"
#include "IndexLSH.h"

%}


%include <stdint.i>
typedef uint64_t size_t;
typedef long idx_t;


%include <std_except.i>


/******************************************************************************
 * Remap functions not supported by Java
 ******************************************************************************/

%rename(opFunctor) operator();


/******************************************************************************
 * Generate proper Java enums
 ******************************************************************************/

%include "enums.swg"
%javaconst(1);


/******************************************************************************
 * Begin vector support
 ******************************************************************************/

%include <typemaps.i>
%include <std_vector.i>

using namespace std;
%ignore std::vector<float>::vector(size_type);
%ignore std::vector<float>::resize;
%template(FloatVector) std::vector<float>;
%ignore std::vector<long>::vector(size_type);
%ignore std::vector<long>::resize;
%template(LongVector) std::vector<long>;
%ignore std::vector<double>::vector(size_type);
%ignore std::vector<double>::resize;
%template(DoubleVector) std::vector<double>;

/*
%template(DoubleVector) std::vector<double>;
%template(ByteVector) std::vector<uint8_t>;
%template(CharVector) std::vector<char>;
// NOTE(hoss): Using unsigned long instead of uint64_t because OSX defines
//   uint64_t as unsigned long long, which SWIG is not aware of.
%template(Uint64Vector) std::vector<uint64_t>;
%template(IntVector) std::vector<int>;
%template(VectorTransformVector) std::vector<faiss::VectorTransform*>;
%template(OperatingPointVector) std::vector<faiss::OperatingPoint>;
%template(FloatVectorVector) std::vector<std::vector<float> >;
%template(ByteVectorVector) std::vector<std::vector<unsigned char> >;
%template(LongVectorVector) std::vector<std::vector<long> >;

#ifdef GPU_WRAPPER
%template(GpuResourcesVector) std::vector<faiss::gpu::GpuResources*>;
#endif
}
*/

/******************************************************************************
 * End vector support
 ******************************************************************************/



%include "Index.h";
%include "IndexFlat.h";
%include "VectorTransform.h";
%include "IndexLSH.h";



/******************************************************************************
 * Overload desired native methods to work more easily with Java code
 ******************************************************************************/

%extend faiss::Index {
    void train(int n, std::vector<float> *pFloatVector) {
        $self->train(n, pFloatVector->data());
    }

    void add(int n, std::vector<float> *pFloatVector) {
        $self->add(n, pFloatVector->data());
    }

    void search(long n, std::vector<float> *pSearchQueries, long k, std::vector<float> *pDistances, std::vector<long> *pLabels) {
        $self->search(n, pSearchQueries->data(), k, pDistances->data(), pLabels->data());
    }

    void reconstruct(long n, std::vector<float> *pReconstructedVector) {
        $self->reconstruct(n, pReconstructedVector->data());
    }
}


/*******************************************************************
 * Link the library
 ********************************************************************/

/*
%pragma(java) jniclasscode=%{
  static {
    try {
      System.loadLibrary("swigfaiss");
    } catch (UnsatisfiedLinkError e) {
      System.err.println("Native code library failed to load. \n" + e);
      System.exit(1);
    }
  }
%}
*/


/*******************************************************************
 * Expose a few basic functions
 *******************************************************************/

void omp_set_num_threads (int num_threads);
int omp_get_max_threads ();
void *memcpy(void *dest, const void *src, size_t n);

