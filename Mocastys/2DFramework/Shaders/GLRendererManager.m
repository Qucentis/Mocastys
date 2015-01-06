//
//  GLRendererManager.m
//  Dabble
//
//  Created by Rakesh on 07/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLRendererManager.h"

@implementation GLRendererManager

SYNTHESIZE_SINGLETON_FOR_CLASS(GLRendererManager)

-(id)init
{
    if (self = [super init])
    {
        sharedData = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(GLRenderer *)getRendererWithVertexShaderName:(NSString *)vertexShaderName
                andFragmentShaderName:(NSString *)fragmentShaderName
{
    NSString *key = [NSString stringWithFormat:@"%@%@",vertexShaderName,fragmentShaderName];
    
    GLRenderer *renderer = sharedData[key];
    if (renderer == nil)
    {
        renderer = [[GLRenderer alloc]initWithVertexShader:vertexShaderName
                                         andFragmentShader:fragmentShaderName];
    }
    return renderer;
}

@end
