//
//  EasingFunctions.m
//  Tiles
//
//  Created by Rakesh on 07/02/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "EasingFunctions.h"

#define PI 3.414

#define BoundsCheck(t, start, end) \
if (t <= 0.f) return start;        \
else if (t >= 1.f) return end;

CGFloat getLinear(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    return start + diff * ratio;
}

CGFloat getEaseInQuad(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    return start + diff * ratio *ratio;
}

CGFloat getEaseOutQuad(CGFloat start,CGFloat end,CGFloat ratio)
{
        BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    return start - diff * (ratio) * (ratio - 2.0);
}

CGFloat getEaseInOutQuad(CGFloat start,CGFloat end,CGFloat ratio)
{
    CGFloat t = ratio * 2;
    CGFloat c = end - start;
	if (t < 1) return c/2*t*t + start;
	t--;
	return -c/2 * (t*(t-2) - 1) + start;
}

CGFloat getEaseInCubic(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    return start + diff * ratio *ratio *ratio;
}

CGFloat getEaseOutCubic(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    ratio--;
    return start + diff * (ratio * ratio * ratio + 1);
}

CGFloat getEaseInOutCubic(CGFloat start,CGFloat end,CGFloat ratio)
{
    CGFloat t = 2 * ratio;
    CGFloat c = end - start;
	if (t < 1) return c/2*t*t*t + start;
	t -= 2;
	return c/2*(t*t*t + 2) + start;
}



CGFloat getEaseInQuartic(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    return start + diff * ratio *ratio * ratio*ratio;
}

CGFloat getEaseOutQuartic(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    ratio--;
    return start - diff * (ratio * ratio * ratio * ratio + 1);
}

CGFloat getEaseInOutQuartic(CGFloat start,CGFloat end,CGFloat ratio)
{
    CGFloat t = ratio * 2;
    CGFloat c = end - start;
	if (t < 1) return c/2*t*t*t*t + start;
	t -= 2;
	return -c/2 * (t*t*t*t - 2) + start;
}

CGFloat getEaseInQuintic(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    return start + diff * ratio *ratio *ratio * ratio * ratio;
}

CGFloat getEaseOutQuintic(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat diff = (end - start);
    ratio--;
    return start + diff * (ratio * ratio * ratio * ratio * ratio + 1);
}

CGFloat getEaseInOutQuintic(CGFloat start,CGFloat end,CGFloat ratio)
{
    CGFloat t = ratio * 2;
    CGFloat c = (end - start);
    if (t < 1) return (c/2)*t*t*t*t*t + start;
	t -= 2;
    return (c/2)*(t*t*t*t*t + 2) + start;
}



CGFloat getSineEaseOut(CGFloat start,CGFloat ratio,CGFloat maxAmplitude,CGFloat damping,CGFloat frequency)
{
    if (ratio >= 1.0 || ratio <=0.0)
        return start;
    CGFloat s = powf(2,-damping*ratio) * sinf(2*PI*frequency*ratio);
    return  start + maxAmplitude * s;
}

CGFloat getEaseOutBack(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat s = 1.70158;
    CGFloat diff = end - start;
    CGFloat invRatio = ratio -1;
    
    return (powf(invRatio, 2) * ((s + 1.0)*invRatio + s) + 1.0)*diff + start;

}

CGFloat getEaseInBack(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat s = 1.70158;
    CGFloat diff = end - start;
    return (powf(ratio, 2.0) * ((s + 1.0) * ratio - s))*diff + start;
    
}


CGFloat getEaseOutBackInternal(CGFloat ratio)
{
    if (ratio >= 1.0)
        return 1;
    CGFloat s = 1.70158;
    CGFloat invRatio = ratio -1;
    return (powf(invRatio, 2) * ((s + 1.0)*invRatio + s) + 1.0);
    
}

CGFloat getEaseInBackInternal(CGFloat ratio)
{
    
    if (ratio >= 1.0)
        return 1;
    CGFloat s = 1.70158;
    return (powf(ratio, 2.0) * ((s + 1.0) * ratio - s));
    
}


CGFloat getEaseInOutBack(CGFloat start,CGFloat end,CGFloat ratio)
{
    BoundsCheck(ratio, start, end)
    CGFloat val = 0;
    CGFloat diff = end - start;
    
    if (ratio < 0.5)
        val = 0.5 * getEaseInBackInternal(ratio*2.0);
    else
        val = 0.5 * getEaseOutBackInternal((ratio-0.5)*2.0) + 0.5;
    
    return val * diff + start;
}

CGFloat getEaseOutElastic(CGFloat start,CGFloat end,CGFloat ratio,CGFloat duration)
{
    BoundsCheck(ratio, start, end)
    
    CGFloat c = end - start;
    CGFloat p = 0.3 * duration;
    CGFloat a = 0;
    CGFloat s = 0;
    
    if (!a || a < fabs(c))
    {
        a = c/2;
        s = p /20;
    }
    else
    {
        s = p / (2 * PI) * asinf(c / a);
    }
    
    return a * powf(2, -10 * ratio) * sinf((ratio * duration - s) * (2 * PI) / p) + c + start;
}

