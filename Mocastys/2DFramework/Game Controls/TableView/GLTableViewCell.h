//
//  GLTableViewCell.h
//  KBC
//
//  Created by Rakesh on 05/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"



@interface GLTableViewCell : GLElement
{
    VertexColorData *overlayFrameData;
    
    BOOL fading;
    BOOL highlighted;
    Color4B highLightColor;
}

-(void)setHighlightColor:(Color4B)color;
-(void)animate;

@property (nonatomic) BOOL wasInsertedInTable;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL hasBorder;
@property (nonatomic) int rowIndex;
@property (nonatomic) int animationOffset;

@end
