/*
 NEON math library for the iPhone / iPod touch

 Copyright (c) 2009 Justin Saunders

 This software is provided 'as-is', without any express or implied warranty.
 In no event will the authors be held liable for any damages arising
 from the use of this software.
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it freely,
 subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must
 not claim that you wrote the original software. If you use this
 software in a product, an acknowledgment in the product documentation
 would be appreciated but is not required.

 2. Altered source versions must be plainly marked as such, and must
 not be misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.
*/

#include "NEONMatrix.h"

#if defined(__ARM_NEON__)
#define __MATH_NEON
#endif


//matrix matrix multipication. d = m0 * m1;
void
matmul4_c(float m0[16], float m1[16], float d[16])
{
	d[0] = m0[0]*m1[0] + m0[4]*m1[1] + m0[8]*m1[2] + m0[12]*m1[3];
	d[1] = m0[1]*m1[0] + m0[5]*m1[1] + m0[9]*m1[2] + m0[13]*m1[3];
	d[2] = m0[2]*m1[0] + m0[6]*m1[1] + m0[10]*m1[2] + m0[14]*m1[3];
	d[3] = m0[3]*m1[0] + m0[7]*m1[1] + m0[11]*m1[2] + m0[15]*m1[3];
	d[4] = m0[0]*m1[4] + m0[4]*m1[5] + m0[8]*m1[6] + m0[12]*m1[7];
	d[5] = m0[1]*m1[4] + m0[5]*m1[5] + m0[9]*m1[6] + m0[13]*m1[7];
	d[6] = m0[2]*m1[4] + m0[6]*m1[5] + m0[10]*m1[6] + m0[14]*m1[7];
	d[7] = m0[3]*m1[4] + m0[7]*m1[5] + m0[11]*m1[6] + m0[15]*m1[7];
    d[8] = m0[0]*m1[8] + m0[4]*m1[9] + m0[8]*m1[10] + m0[12]*m1[11];
    d[9] = m0[1]*m1[8] + m0[5]*m1[9] + m0[9]*m1[10] + m0[13]*m1[11];
	d[10] = m0[2]*m1[8] + m0[6]*m1[9] + m0[10]*m1[10] + m0[14]*m1[11];
	d[11] = m0[3]*m1[8] + m0[7]*m1[9] + m0[11]*m1[10] + m0[15]*m1[11];
	d[12] = m0[0]*m1[12] + m0[4]*m1[13] + m0[8]*m1[14] + m0[12]*m1[15];
	d[13] = m0[1]*m1[12] + m0[5]*m1[13] + m0[9]*m1[14] + m0[13]*m1[15];
	d[14] = m0[2]*m1[12] + m0[6]*m1[13] + m0[10]*m1[14] + m0[14]*m1[15];
	d[15] = m0[3]*m1[12] + m0[7]*m1[13] + m0[11]*m1[14] + m0[15]*m1[15];
}


void Matrix3DMultiply(float m0[16], float m1[16], float d[16])
{
#ifdef __MATH_NEON
	asm volatile (
                  "vld1.32 		{d0, d1}, [%1]!			\n\t"	//q0 = m1
                  "vld1.32 		{d2, d3}, [%1]!			\n\t"	//q1 = m1+4
                  "vld1.32 		{d4, d5}, [%1]!			\n\t"	//q2 = m1+8
                  "vld1.32 		{d6, d7}, [%1]			\n\t"	//q3 = m1+12
                  "vld1.32 		{d16, d17}, [%0]!		\n\t"	//q8 = m0
                  "vld1.32 		{d18, d19}, [%0]!		\n\t"	//q9 = m0+4
                  "vld1.32 		{d20, d21}, [%0]!		\n\t"	//q10 = m0+8
                  "vld1.32 		{d22, d23}, [%0]		\n\t"	//q11 = m0+12
                  
                  "vmul.f32 		q12, q8, d0[0] 			\n\t"	//q12 = q8 * d0[0]
                  "vmul.f32 		q13, q8, d2[0] 			\n\t"	//q13 = q8 * d2[0]
                  "vmul.f32 		q14, q8, d4[0] 			\n\t"	//q14 = q8 * d4[0]
                  "vmul.f32 		q15, q8, d6[0]	 		\n\t"	//q15 = q8 * d6[0]
                  "vmla.f32 		q12, q9, d0[1] 			\n\t"	//q12 = q9 * d0[1]
                  "vmla.f32 		q13, q9, d2[1] 			\n\t"	//q13 = q9 * d2[1]
                  "vmla.f32 		q14, q9, d4[1] 			\n\t"	//q14 = q9 * d4[1]
                  "vmla.f32 		q15, q9, d6[1] 			\n\t"	//q15 = q9 * d6[1]
                  "vmla.f32 		q12, q10, d1[0] 		\n\t"	//q12 = q10 * d0[0]
                  "vmla.f32 		q13, q10, d3[0] 		\n\t"	//q13 = q10 * d2[0]
                  "vmla.f32 		q14, q10, d5[0] 		\n\t"	//q14 = q10 * d4[0]
                  "vmla.f32 		q15, q10, d7[0] 		\n\t"	//q15 = q10 * d6[0]
                  "vmla.f32 		q12, q11, d1[1] 		\n\t"	//q12 = q11 * d0[1]
                  "vmla.f32 		q13, q11, d3[1] 		\n\t"	//q13 = q11 * d2[1]
                  "vmla.f32 		q14, q11, d5[1] 		\n\t"	//q14 = q11 * d4[1]
                  "vmla.f32 		q15, q11, d7[1]	 		\n\t"	//q15 = q11 * d6[1]
                  
                  "vst1.32 		{d24, d25}, [%2]! 		\n\t"	//d = q12
                  "vst1.32 		{d26, d27}, [%2]!		\n\t"	//d+4 = q13
                  "vst1.32 		{d28, d29}, [%2]! 		\n\t"	//d+8 = q14
                  "vst1.32 		{d30, d31}, [%2]	 	\n\t"	//d+12 = q15
                  
                  : "+r"(m0), "+r"(m1), "+r"(d) :
                  : "q0", "q1", "q2", "q3", "q8", "q9", "q10", "q11", "q12", "q13", "q14", "q15",
                  "memory"
                  );
#else
	matmul4_c(m0, m1, d);
#endif
}


//matrix vector multiplication. d = m * v
void
matvec4_c(float m[16], Vertex3D *v, Vertex3D *d)
{
	d->x = m[0]*v->x + m[4]*v->y + m[8]*v->z + m[12]*v->t;
	d->y = m[1]*v->x + m[5]*v->y + m[9]*v->z + m[13]*v->t;
	d->z = m[2]*v->x + m[6]*v->y + m[10]*v->z + m[14]*v->t;
	d->t = m[3]*v->x + m[7]*v->y + m[11]*v->z + m[15]*v->t;
}

void MatrixVectorMultiply(float m[16], Vertex3D *v, Vertex3D *d)
{
#ifdef __MATH_NEON
	asm volatile (
                  "vld1.32 		{d0, d1}, [%1]			\n\t"	//Q0 = v
                  "vld1.32 		{d18, d19}, [%0]!		\n\t"	//Q1 = m
                  "vld1.32 		{d20, d21}, [%0]!		\n\t"	//Q2 = m+4
                  "vld1.32 		{d22, d23}, [%0]!		\n\t"	//Q3 = m+8
                  "vld1.32 		{d24, d25}, [%0]!		\n\t"	//Q4 = m+12	
                  
                  "vmul.f32 		q13, q9, d0[0]			\n\t"	//Q5 = Q1*Q0[0]
                  "vmla.f32 		q13, q10, d0[1]			\n\t"	//Q5 += Q1*Q0[1] 
                  "vmla.f32 		q13, q11, d1[0]			\n\t"	//Q5 += Q2*Q0[2] 
                  "vmla.f32 		q13, q12, d1[1]			\n\t"	//Q5 += Q3*Q0[3]
                  
                  "vst1.32 		{d26, d27}, [%2] 		\n\t"	//Q4 = m+12	
                  : 
                  : "r"(m), "r"(v), "r"(d) 
                  : "q0", "q9", "q10","q11", "q12", "q13", "memory"
                  );	
#else
	matvec4_c(m, v, d);
#endif
}
