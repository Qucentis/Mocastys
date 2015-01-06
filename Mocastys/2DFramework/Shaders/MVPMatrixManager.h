//
//  MatrixStack.h
//  OpenGLES2.0
//
//  Created by Rakesh on 05/03/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLCommon.h"
@interface MVPMatrixManager : NSObject
{
    Matrix3D modelViewStack[100];
    Matrix3D projectionMatrixStack[10];

    int currentModelViewMatrixIndex;
    int currentProjectionMatrixIndex;
    
    CGFloat zCoordinate;
    CGFloat zCoordinateStack[100];
}

@property (nonatomic) CGFloat zCoordinate;
+(id)sharedMVPMatrixManager;
-(void)pushModelViewMatrix;
-(void)popModelViewMatrix;
-(void)pushProjectionMatrix;
-(void)popProjectionMatrix;
-(void)setOrthoProjection: (GLfloat) left :(GLfloat) right :(GLfloat) bottom
                         :(GLfloat) top :(GLfloat) near :(GLfloat) far;
-(void)setFrustumProjection: (GLfloat) left :(GLfloat) right :(GLfloat) bottom
                           :(GLfloat) top :(GLfloat) zNear :(GLfloat) zFar;
-(void)setPerspectiveProjection:(GLfloat) fieldOfVision :(GLfloat) near :(GLfloat) far :(GLfloat) aspectRatio;
-(void)rotateByAngleInDegrees:(CGFloat)degrees InX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(void)scaleByXScale:(CGFloat)xScale YScale:(CGFloat)yScale ZScale:(CGFloat)zScale;
-(void)translateInX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(void)getMVPMatrix:(Matrix3D)mvpMatrix;
-(void)resetModelViewMatrixStack;
-(void)setIdentity;
@end
