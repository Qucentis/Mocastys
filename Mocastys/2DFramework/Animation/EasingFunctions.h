//
//  EasingFunctions.h
//  Tiles
//
//  Created by Rakesh on 07/02/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*#define EASINGTYPE_EASEIN 1
#define EASINGTYPE_EASEOUT 2
#define EASINGTYPE_EASEINEASEOUT 3
#define EASINGTYPE_EASEOUTBACK 5
#define EASINGTYPE_EASEINOUTBACK 6

#define EASINGTYPE_SINEEASEOUT 8
#define EASINGTYPE_EASEOUTELASTIC 9
*/


CGFloat getLinear(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseInQuad(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseOutQuad(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseInOutQuad(CGFloat start,CGFloat end,CGFloat ratio);

CGFloat getEaseInCubic(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseOutCubic(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseInOutCubic(CGFloat start,CGFloat end,CGFloat ratio);

CGFloat getEaseInQuartic(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseOutQuartic(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseInOutQuartic(CGFloat start,CGFloat end,CGFloat ratio);

CGFloat getEaseInQuintic(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseOutQuintic(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseInOutQuintic(CGFloat start,CGFloat end,CGFloat ratio);

CGFloat getEaseInBack(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseOutBack(CGFloat start,CGFloat end,CGFloat ratio);
CGFloat getEaseInOutBack(CGFloat start,CGFloat end,CGFloat ratio);

CGFloat getEaseOutElastic(CGFloat start,CGFloat end,CGFloat ratio,CGFloat duration);

CGFloat getSineEaseOut(CGFloat start,CGFloat ratio,CGFloat maxAmplitude,CGFloat damping,CGFloat frequency);
