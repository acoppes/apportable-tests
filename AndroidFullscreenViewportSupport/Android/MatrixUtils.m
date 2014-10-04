//
//  MatrixUtils.m
//  ViewportSupport
//
//  Created by Ironhide Games on 8/26/13.
//
//

#import "MatrixUtils.h"

static int M00 = 0;
static int M01 = 4;
static int M02 = 8;
static int M03 = 12;
static int M10 = 1;
static int M11 = 5;
static int M12 = 9;
static int M13 = 13;
static int M20 = 2;
static int M21 = 6;
static int M22 = 10;
static int M23 = 14;
static int M30 = 3;
static int M31 = 7;
static int M32 = 11;
static int M33 = 15;

inline void matrix4ToIdentity(float *matrix)
{
    matrix[M00] = 1;
    matrix[M01] = 0;
    matrix[M02] = 0;
    matrix[M03] = 0;
    matrix[M10] = 0;
    matrix[M11] = 1;
    matrix[M12] = 0;
    matrix[M13] = 0;
    matrix[M20] = 0;
    matrix[M21] = 0;
    matrix[M22] = 1;
    matrix[M23] = 0;
    matrix[M30] = 0;
    matrix[M31] = 0;
    matrix[M32] = 0;
    matrix[M33] = 1;
}

inline void matrix4ToOrtho(float *matrix, float left, float right, float bottom, float top, float near, float far)
{
    matrix4ToIdentity(matrix);
    float x_orth = 2 / (right - left);
    float y_orth = 2 / (top - bottom);
    float z_orth = -2 / (far - near);
    
    float tx = -(right + left) / (right - left);
    float ty = -(top + bottom) / (top - bottom);
    float tz = -(far + near) / (far - near);
    
    matrix[M00] = x_orth;
    matrix[M10] = 0;
    matrix[M20] = 0;
    matrix[M30] = 0;
    matrix[M01] = 0;
    matrix[M11] = y_orth;
    matrix[M21] = 0;
    matrix[M31] = 0;
    matrix[M02] = 0;
    matrix[M12] = 0;
    matrix[M22] = z_orth;
    matrix[M32] = 0;
    matrix[M03] = tx;
    matrix[M13] = ty;
    matrix[M23] = tz;
    matrix[M33] = 1;
}

BOOL matrix4Invert(float *matrix) {
    float tmp[16];
    float l_det = matrix[M30] * matrix[M21] * matrix[M12] * matrix[M03] - matrix[M20] * matrix[M31] * matrix[M12] * matrix[M03] - matrix[M30] * matrix[M11]
    * matrix[M22] * matrix[M03] + matrix[M10] * matrix[M31] * matrix[M22] * matrix[M03] + matrix[M20] * matrix[M11] * matrix[M32] * matrix[M03] - matrix[M10]
    * matrix[M21] * matrix[M32] * matrix[M03] - matrix[M30] * matrix[M21] * matrix[M02] * matrix[M13] + matrix[M20] * matrix[M31] * matrix[M02] * matrix[M13]
    + matrix[M30] * matrix[M01] * matrix[M22] * matrix[M13] - matrix[M00] * matrix[M31] * matrix[M22] * matrix[M13] - matrix[M20] * matrix[M01] * matrix[M32]
    * matrix[M13] + matrix[M00] * matrix[M21] * matrix[M32] * matrix[M13] + matrix[M30] * matrix[M11] * matrix[M02] * matrix[M23] - matrix[M10] * matrix[M31]
    * matrix[M02] * matrix[M23] - matrix[M30] * matrix[M01] * matrix[M12] * matrix[M23] + matrix[M00] * matrix[M31] * matrix[M12] * matrix[M23] + matrix[M10]
    * matrix[M01] * matrix[M32] * matrix[M23] - matrix[M00] * matrix[M11] * matrix[M32] * matrix[M23] - matrix[M20] * matrix[M11] * matrix[M02] * matrix[M33]
    + matrix[M10] * matrix[M21] * matrix[M02] * matrix[M33] + matrix[M20] * matrix[M01] * matrix[M12] * matrix[M33] - matrix[M00] * matrix[M21] * matrix[M12]
    * matrix[M33] - matrix[M10] * matrix[M01] * matrix[M22] * matrix[M33] + matrix[M00] * matrix[M11] * matrix[M22] * matrix[M33];
    if (l_det == 0.0f) return false;
    float inv_det = 1.0f / l_det;
    tmp[M00] = matrix[M12] * matrix[M23] * matrix[M31] - matrix[M13] * matrix[M22] * matrix[M31] + matrix[M13] * matrix[M21] * matrix[M32] - matrix[M11]
    * matrix[M23] * matrix[M32] - matrix[M12] * matrix[M21] * matrix[M33] + matrix[M11] * matrix[M22] * matrix[M33];
    tmp[M01] = matrix[M03] * matrix[M22] * matrix[M31] - matrix[M02] * matrix[M23] * matrix[M31] - matrix[M03] * matrix[M21] * matrix[M32] + matrix[M01]
    * matrix[M23] * matrix[M32] + matrix[M02] * matrix[M21] * matrix[M33] - matrix[M01] * matrix[M22] * matrix[M33];
    tmp[M02] = matrix[M02] * matrix[M13] * matrix[M31] - matrix[M03] * matrix[M12] * matrix[M31] + matrix[M03] * matrix[M11] * matrix[M32] - matrix[M01]
    * matrix[M13] * matrix[M32] - matrix[M02] * matrix[M11] * matrix[M33] + matrix[M01] * matrix[M12] * matrix[M33];
    tmp[M03] = matrix[M03] * matrix[M12] * matrix[M21] - matrix[M02] * matrix[M13] * matrix[M21] - matrix[M03] * matrix[M11] * matrix[M22] + matrix[M01]
    * matrix[M13] * matrix[M22] + matrix[M02] * matrix[M11] * matrix[M23] - matrix[M01] * matrix[M12] * matrix[M23];
    tmp[M10] = matrix[M13] * matrix[M22] * matrix[M30] - matrix[M12] * matrix[M23] * matrix[M30] - matrix[M13] * matrix[M20] * matrix[M32] + matrix[M10]
    * matrix[M23] * matrix[M32] + matrix[M12] * matrix[M20] * matrix[M33] - matrix[M10] * matrix[M22] * matrix[M33];
    tmp[M11] = matrix[M02] * matrix[M23] * matrix[M30] - matrix[M03] * matrix[M22] * matrix[M30] + matrix[M03] * matrix[M20] * matrix[M32] - matrix[M00]
    * matrix[M23] * matrix[M32] - matrix[M02] * matrix[M20] * matrix[M33] + matrix[M00] * matrix[M22] * matrix[M33];
    tmp[M12] = matrix[M03] * matrix[M12] * matrix[M30] - matrix[M02] * matrix[M13] * matrix[M30] - matrix[M03] * matrix[M10] * matrix[M32] + matrix[M00]
    * matrix[M13] * matrix[M32] + matrix[M02] * matrix[M10] * matrix[M33] - matrix[M00] * matrix[M12] * matrix[M33];
    tmp[M13] = matrix[M02] * matrix[M13] * matrix[M20] - matrix[M03] * matrix[M12] * matrix[M20] + matrix[M03] * matrix[M10] * matrix[M22] - matrix[M00]
    * matrix[M13] * matrix[M22] - matrix[M02] * matrix[M10] * matrix[M23] + matrix[M00] * matrix[M12] * matrix[M23];
    tmp[M20] = matrix[M11] * matrix[M23] * matrix[M30] - matrix[M13] * matrix[M21] * matrix[M30] + matrix[M13] * matrix[M20] * matrix[M31] - matrix[M10]
    * matrix[M23] * matrix[M31] - matrix[M11] * matrix[M20] * matrix[M33] + matrix[M10] * matrix[M21] * matrix[M33];
    tmp[M21] = matrix[M03] * matrix[M21] * matrix[M30] - matrix[M01] * matrix[M23] * matrix[M30] - matrix[M03] * matrix[M20] * matrix[M31] + matrix[M00]
    * matrix[M23] * matrix[M31] + matrix[M01] * matrix[M20] * matrix[M33] - matrix[M00] * matrix[M21] * matrix[M33];
    tmp[M22] = matrix[M01] * matrix[M13] * matrix[M30] - matrix[M03] * matrix[M11] * matrix[M30] + matrix[M03] * matrix[M10] * matrix[M31] - matrix[M00]
    * matrix[M13] * matrix[M31] - matrix[M01] * matrix[M10] * matrix[M33] + matrix[M00] * matrix[M11] * matrix[M33];
    tmp[M23] = matrix[M03] * matrix[M11] * matrix[M20] - matrix[M01] * matrix[M13] * matrix[M20] - matrix[M03] * matrix[M10] * matrix[M21] + matrix[M00]
    * matrix[M13] * matrix[M21] + matrix[M01] * matrix[M10] * matrix[M23] - matrix[M00] * matrix[M11] * matrix[M23];
    tmp[M30] = matrix[M12] * matrix[M21] * matrix[M30] - matrix[M11] * matrix[M22] * matrix[M30] - matrix[M12] * matrix[M20] * matrix[M31] + matrix[M10]
    * matrix[M22] * matrix[M31] + matrix[M11] * matrix[M20] * matrix[M32] - matrix[M10] * matrix[M21] * matrix[M32];
    tmp[M31] = matrix[M01] * matrix[M22] * matrix[M30] - matrix[M02] * matrix[M21] * matrix[M30] + matrix[M02] * matrix[M20] * matrix[M31] - matrix[M00]
    * matrix[M22] * matrix[M31] - matrix[M01] * matrix[M20] * matrix[M32] + matrix[M00] * matrix[M21] * matrix[M32];
    tmp[M32] = matrix[M02] * matrix[M11] * matrix[M30] - matrix[M01] * matrix[M12] * matrix[M30] - matrix[M02] * matrix[M10] * matrix[M31] + matrix[M00]
    * matrix[M12] * matrix[M31] + matrix[M01] * matrix[M10] * matrix[M32] - matrix[M00] * matrix[M11] * matrix[M32];
    tmp[M33] = matrix[M01] * matrix[M12] * matrix[M20] - matrix[M02] * matrix[M11] * matrix[M20] + matrix[M02] * matrix[M10] * matrix[M21] - matrix[M00]
    * matrix[M12] * matrix[M21] - matrix[M01] * matrix[M10] * matrix[M22] + matrix[M00] * matrix[M11] * matrix[M22];
    matrix[M00] = tmp[M00] * inv_det;
    matrix[M01] = tmp[M01] * inv_det;
    matrix[M02] = tmp[M02] * inv_det;
    matrix[M03] = tmp[M03] * inv_det;
    matrix[M10] = tmp[M10] * inv_det;
    matrix[M11] = tmp[M11] * inv_det;
    matrix[M12] = tmp[M12] * inv_det;
    matrix[M13] = tmp[M13] * inv_det;
    matrix[M20] = tmp[M20] * inv_det;
    matrix[M21] = tmp[M21] * inv_det;
    matrix[M22] = tmp[M22] * inv_det;
    matrix[M23] = tmp[M23] * inv_det;
    matrix[M30] = tmp[M30] * inv_det;
    matrix[M31] = tmp[M31] * inv_det;
    matrix[M32] = tmp[M32] * inv_det;
    matrix[M33] = tmp[M33] * inv_det;
    return true;
}

void matrix4Copy(float *source, float *destination)
{
    memcpy(destination, source, 16 * sizeof(float));
}

CGPoint matrix4ProjectCGPoint (float *matrix, CGPoint p)
{
    float x = p.x;
    float y = p.y;
    float z = 0;
    float l_w = 1.0f / (x * matrix[M30] + y * matrix[M31] + z * matrix[M32] + matrix[M33]);
    return ccp((x * matrix[M00] + y * matrix[M01] + z * matrix[M02] + matrix[M03]) * l_w, (x * matrix[M10] + y * matrix[M11] + z * matrix[M12] + matrix[M13]) * l_w);
}

