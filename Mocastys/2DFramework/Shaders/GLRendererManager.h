//
//  GLRendererManager.h
//  Dabble
//
//  Created by Rakesh on 07/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "GLRenderer.h"

@interface GLRendererManager : NSObject
{
    NSMutableDictionary *sharedData;
}
+(id)sharedGLRendererManager;
-(GLRenderer *)getRendererWithVertexShaderName:(NSString *)vertexShaderName
                         andFragmentShaderName:(NSString *)fragmentShaderName;
@end
