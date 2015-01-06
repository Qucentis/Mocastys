
#ifdef __arm__
#include "arm/arch.h"
#endif


typedef struct
{
    float x;
    float y;
    float z;
    float t;
} Vertex3D;


void Matrix3DMultiply(float m0[16], float m1[16], float d[16]);

void MatrixVectorMultiply(float m0[16], Vertex3D *v, Vertex3D *d);
