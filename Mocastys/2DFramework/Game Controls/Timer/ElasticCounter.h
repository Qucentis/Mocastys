//
//  ElasticCounter.h
//  Dabble
//
//  Created by Rakesh on 04/07/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"

@interface ElasticCounter : GLElement
{
      
    NSMutableArray *sequence;
    
    long long currentValue;
    long double verticalOffset;
    long double previousVerticalOffset;
    
    InstancedTextureVertexColorData *vertexData;
    int vertexDataCount;
    
    Vertex3D *maskedVertices;
    TextureCoord *maskedTextureCoords;
    
    
    long long loopCount;
    CGFloat maxAngle;
    CGFloat wiggleDistance;
    CGFloat loopRatio;
    CGFloat alpha;
    
    BOOL visible;
    
    CGFloat uiScale;
}

@property  (nonatomic) BOOL visible;
@property (nonatomic,readonly) long long currentValue;
@property (nonatomic,readonly) NSArray *sequence;
@property (nonatomic) InstancedTextureVertexColorData *vertexData;
@property (nonatomic,readonly) int vertexDataCount;
@property (nonatomic,retain) SpriteSheet *fontSpriteSheet;
@property (nonatomic) Color4B textColor;
@property (nonatomic) CGFloat alpha;

-(void)setStringValueToCount:(NSString *)str inDuration:(CGFloat)duration;
-(void)setValueCountUp:(CGFloat)value withDuration:(CGFloat)duration;
-(void)setValueCountDown:(CGFloat)value withDuration:(CGFloat)duration;
-(void)setSequence:(NSArray *)sequence;
-(void)stop;
-(void)showInDuration:(CGFloat)t;
-(void)hideInDuration:(CGFloat)t;

@end
