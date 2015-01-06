//
//  AppTheme.h
//  KBC
//
//  Created by Rakesh on 17/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#ifndef KBC_AppTheme_h
#define KBC_AppTheme_h

#define GET_BYTE(X,Y) (((0xff)<<Y)&X)>>Y
#define COLOR4B_FROM_HEX(X) (Color4B){GET_BYTE(X,24),GET_BYTE(X,16),GET_BYTE(X,8),GET_BYTE(X,0)}

//Include alpha value at the end along with RGB

#import "GLCommon.h"

static const Color4B backgroundColorTop = COLOR4B_FROM_HEX(0x8E44ADff);
static const Color4B backgroundColorBottom = COLOR4B_FROM_HEX(0x2880B9ff);

static const Color4B  greenNavigationBarButtonColor = COLOR4B_FROM_HEX(0x329f83bb);


#endif
