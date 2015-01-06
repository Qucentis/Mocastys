//
//  MatrixStack.m
//  OpenGLES2.0
//
//  Created by Rakesh on 05/03/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "MVPMatrixManager.h"
#import "SynthesizeSingleton.h"

@implementation MVPMatrixManager

@synthesize zCoordinate;

SYNTHESIZE_SINGLETON_FOR_CLASS(MVPMatrixManager);

-(id)init
{
    if (self = [super init])
    {
        zCoordinate = 0;
        currentModelViewMatrixIndex = 0;
        currentProjectionMatrixIndex = 0;
        Matrix3DSetIdentity(modelViewStack[currentModelViewMatrixIndex]);
        Matrix3DSetIdentity(projectionMatrixStack[currentProjectionMatrixIndex]);
    }
    return  self;
}

-(void)pushModelViewMatrix
{
    currentModelViewMatrixIndex++;
    if (currentModelViewMatrixIndex>=100)
    {
        NSLog(@"Model View Matrix Stack Full");
        return;
    }
   
    for (int j = 0;j<16;j++)
    {
        modelViewStack[currentModelViewMatrixIndex][j]=modelViewStack[currentModelViewMatrixIndex-1][j];
    }
    zCoordinateStack[currentModelViewMatrixIndex] = zCoordinate;
}

static int Zcoord = 0;

-(void)popModelViewMatrix
{
    currentModelViewMatrixIndex--;
    
    zCoordinate = zCoordinateStack[currentModelViewMatrixIndex];
}


-(void)pushProjectionMatrix
{
    currentProjectionMatrixIndex++;
    if (currentProjectionMatrixIndex>=10)
    {
        NSLog(@"Projection Matrix Stack Full");
        return;
    }
    for (int j = 0;j<16;j++)
    {
        projectionMatrixStack[currentProjectionMatrixIndex][j]=
        projectionMatrixStack[currentProjectionMatrixIndex-1][j];
    }
    
}

-(void)popProjectionMatrix
{
    currentProjectionMatrixIndex--;
}

-(void)setOrthoProjection: (GLfloat) left :(GLfloat) right :(GLfloat) bottom
                           :(GLfloat) top :(GLfloat) near :(GLfloat) far
{
    Matrix3DSetOrthoProjection(projectionMatrixStack[currentProjectionMatrixIndex],
                                 left, right, bottom, top, near, far);
}

-(void)setFrustumProjection: (GLfloat) left :(GLfloat) right :(GLfloat) bottom
                           :(GLfloat) top :(GLfloat) zNear :(GLfloat) zFar
{
    Matrix3DSetFrustumProjection(projectionMatrixStack[currentProjectionMatrixIndex],
                                 left, right, bottom, top, zNear, zFar);
}

-(void)setPerspectiveProjection:(GLfloat) fieldOfVision :(GLfloat) near :(GLfloat) far :(GLfloat) aspectRatio
{
    Matrix3DSetPerspectiveProjectionWithFieldOfView(projectionMatrixStack[currentProjectionMatrixIndex], fieldOfVision, near, far, aspectRatio);
}

-(void)rotateByAngleInDegrees:(CGFloat)degrees InX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z
{
    Vector3D vector;
    vector.x = x;
    vector.y = y;
    vector.z = z;
    Matrix3D rotationMatrix;
    Matrix3D resultMatrix;
    
    Matrix3DSetRotationByDegrees(rotationMatrix, degrees, vector);
    Matrix3DMultiply(modelViewStack[currentModelViewMatrixIndex],rotationMatrix, resultMatrix);
    Matrix3DCopyS(resultMatrix, modelViewStack[currentModelViewMatrixIndex]);
}

-(void)translateInX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z
{
    Matrix3D translationMatrix;
    Matrix3D resultMatrix;
    
    Matrix3DSetTranslation(translationMatrix,x,y,z);
    Matrix3DMultiply(modelViewStack[currentModelViewMatrixIndex],translationMatrix, resultMatrix);
    Matrix3DCopyS(resultMatrix, modelViewStack[currentModelViewMatrixIndex]);
    zCoordinate += z;
}



-(void)resetModelViewMatrixStack
{
    currentModelViewMatrixIndex = 0;
    Matrix3DSetIdentity(modelViewStack[currentModelViewMatrixIndex]);
    zCoordinate = 0;
}

-(void)setIdentity
{
    Matrix3DSetIdentity(modelViewStack[currentModelViewMatrixIndex]);
    Zcoord = 0;
}

-(void)scaleByXScale:(CGFloat)xScale YScale:(CGFloat)yScale ZScale:(CGFloat)zScale
{
    Matrix3D scaleMatrix;
    Matrix3D resultMatrix;
    
    Matrix3DSetScaling(scaleMatrix,xScale,yScale,zScale);
    Matrix3DMultiply(modelViewStack[currentModelViewMatrixIndex],scaleMatrix, resultMatrix);
    Matrix3DCopyS(resultMatrix,  modelViewStack[currentModelViewMatrixIndex]);
}

-(void)getMVPMatrix:(Matrix3D)mvpMatrix
{
    Matrix3DMultiply(projectionMatrixStack[currentProjectionMatrixIndex],
                     modelViewStack[currentModelViewMatrixIndex], mvpMatrix);
}




@end