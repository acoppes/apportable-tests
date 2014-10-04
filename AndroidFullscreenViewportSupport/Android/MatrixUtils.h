//
//  MatrixUtils.h
//  ViewportSupport
//
//  Created by Ironhide Games on 8/26/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

struct _Matrix4
{
//    struct
//    {
//        float m00, m01, m02, m03;
//        float m10, m11, m12, m13;
//        float m20, m21, m22, m23;
//        float m30, m31, m32, m33;
//    };
    float m[16];
};

typedef struct _Matrix4 Matrix4;

void matrix4ToIdentity(float *matrix);

void matrix4ToOrtho(float *matrix, float left, float right, float bottom, float top, float near, float far);

void matrix4Copy(float *source, float *destination);

BOOL matrix4Invert(float *matrix);

CGPoint matrix4ProjectCGPoint (float *matrix, CGPoint p);