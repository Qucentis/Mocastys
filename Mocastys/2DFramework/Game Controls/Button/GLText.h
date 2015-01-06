//
//  GLText.h
//  KBC
//
//  Created by Rakesh on 12/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"

@interface GLText : GLElement
{
    GLRenderer *textureRenderer;
    FontSpriteSheet *fontSpriteSheet;
    TextureVertexColorData *textureVertexColorData;
    
    int fontSpriteSheetType;
}
@end
