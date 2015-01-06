//
//  GLNode.m
//  GameDemo
//
//  Created by Rakesh on 11/11/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import "GLElement.h"
#import "GLScene.h"
#import "GLTableViewCell.h"
#import "CheckMark.h"
#import "AppDelegate.h"



@interface GLElement (Private)
-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event;
-(void)touchMovedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event;
-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event;

-(void)reindexSubElements;
-(void)draw;
@end

@implementation GLElement

@synthesize touchesInElement,originInsideElement,scaleInsideElement,subElements,originOfElement,scaleOfElement;

@synthesize frame,numberOfLayers,tag,parent,frameBackgroundColor,clipToBounds,requiresMipMap;

-(AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super init])
    {
        self.enabled = YES;
        self.frame = _frame;
        self.parent = nil;
        scaleInsideElement = CGPointMake(1.0, 1.0);
        originInsideElement = CGPointMake(0, 0);
        scaleOfElement = CGPointMake(1.0, 1.0);
        originOfElement = CGPointMake(0, 0);
        self.acceptsTouches = YES;
        director = [GLDirector sharedDirector];
        animator = [Animator sharedAnimator];
        textureManager = [TextureManager sharedTextureManager];
        mvpMatrixManager = [MVPMatrixManager sharedMVPMatrixManager];
        shaderManager = [GLShaderManager sharedGLShaderManager];
        rendererManager = [GLRendererManager sharedGLRendererManager];
        touchesInElement = [[NSMutableArray alloc]init];
        [self setUpBackgroundColorData];
        self.frameBackgroundColor = (Color4B){0,0,0,0};
    }
    return self;
}

-(NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

-(void)setFrame:(CGRect)_frame
{
    frame = _frame;
    
    [self setUpBackgroundColorData];
}

-(void)setUpBackgroundColorData
{
    if (elementColorRenderer == nil)
    {
        elementColorRenderer = [rendererManager getRendererWithVertexShaderName:@"ColorShader" andFragmentShaderName:@"ColorShader"];

        frameColorData = malloc(sizeof(VertexColorData) * 6);
    }
   
    frameColorData[0].vertex = (Vertex3D){.x = 0, .y = 0, .z = 0};
    frameColorData[1].vertex = (Vertex3D){.x = self.frame.size.width, .y = 0, .z = 0};
    frameColorData[2].vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height, .z = 0};
    frameColorData[3].vertex = (Vertex3D){.x = 0, .y = 0, .z = 0};
    frameColorData[4].vertex = (Vertex3D){.x = 0, .y = self.frame.size.height, .z = 0};
    frameColorData[5].vertex = (Vertex3D){.x = self.frame.size.width, .y = self.frame.size.height, .z = 0};

    
}

-(id)init
{
    if (self = [super init])
    {
        self.enabled = YES;
        self.parent = nil;
        scaleInsideElement = CGPointMake(1.0, 1.0);
        originInsideElement = CGPointMake(0, 0);
        scaleOfElement = CGPointMake(1.0, 1.0);
        originOfElement = CGPointMake(0, 0);
        self.acceptsTouches = YES;
        director = [GLDirector sharedDirector];
        animator = [Animator sharedAnimator];
        textureManager = [TextureManager sharedTextureManager];
        touchesInElement = [[NSMutableArray alloc]init];
        mvpMatrixManager = [MVPMatrixManager sharedMVPMatrixManager];
        shaderManager = [GLShaderManager sharedGLShaderManager];
        rendererManager = [GLRendererManager sharedGLRendererManager];
        [self setUpBackgroundColorData];
        self.frameBackgroundColor = (Color4B){0,0,0,0};
        
    }
    return self;
}

-(BOOL)drawable
{
    return YES;
}


-(CGPoint)absoluteScale
{
    CGPoint _absoluteScale = CGPointMake(1.0,1.0);
    GLElement *cparent = self.parent;
    GLElement *current = self;
    while (cparent != nil)
    {
        _absoluteScale = CGPointMake(cparent.scaleInsideElement.x * _absoluteScale.x * current.scaleOfElement.x,
                                    cparent.scaleInsideElement.y * _absoluteScale.y * current.scaleOfElement.y);
        current = cparent;
        cparent = cparent.parent;
    }
    return _absoluteScale;
}


-(CGRect)absoluteFrame
{
    if (self.parent == nil)
        return self.frame;
    
    
    CGPoint absoluteScale = CGPointMake(1.0,1.0);
    CGPoint absoluteOrigin = self.frame.origin;
    GLElement *cparent = self.parent;
    GLElement *current = self;
    
    CGPoint elementScale = current.scaleOfElement;
    CGRect elementFrame = current.frame;
    
    absoluteScale = elementScale;
    
    CGPoint elementMidPoint = CGPointMake(elementFrame.origin.x + elementFrame.size.width/2,
                                          elementFrame.origin.y + elementFrame.size.height/2);
    
    absoluteOrigin = CGPointMake(elementMidPoint.x -
                                 (elementScale.x *  (elementFrame.size.width/2)),
                                 (elementMidPoint.y -
                                 (elementScale.y * (elementFrame.size.height/2))));
    
    absoluteOrigin = CGPointMake(self.originOfElement.x + absoluteOrigin.x , self.originOfElement.y + absoluteOrigin.y);
    
    while (cparent != nil)
    {
        CGRect parentFrame = cparent.frame;
        CGPoint scaleOfParent = cparent.scaleOfElement;
        CGPoint originOfParent = cparent.originOfElement;
        CGPoint scaleInsideParent = cparent.scaleInsideElement;
        CGPoint originInsideParent = cparent.originInsideElement;
        
        absoluteScale = CGPointMake(scaleInsideParent.x * absoluteScale.x * scaleOfParent.x,
                                    scaleInsideParent.y * absoluteScale.y * scaleOfParent.y);
       
        
        absoluteOrigin = CGPointMake((parentFrame.size.width/2) +
                                  (scaleInsideParent.x * scaleOfParent.x * (absoluteOrigin.x - parentFrame.size.width/2)),
                                     (parentFrame.size.height/2) +
                                   (scaleInsideParent.y * scaleOfParent.y * (absoluteOrigin.y - parentFrame.size.height/2)));
        
        absoluteOrigin = CGPointMake(absoluteOrigin.x + parentFrame.origin.x + originInsideParent.x + originOfParent.x,
                                     absoluteOrigin.y + parentFrame.origin.y + originInsideParent.y + originOfParent.y);
        
        current = cparent;
        cparent = cparent.parent;
    }
    
    return CGRectMake(absoluteOrigin.x, absoluteOrigin.y,
                      self.frame.size.width * absoluteScale.x,
                      self.frame.size.height * absoluteScale.y);
}


-(CGRect)relativeFrameOfSubElement:(GLElement *)element
{
    if (element.parent == nil)
        return CGRectZero;
    
    
    CGPoint absoluteScale = CGPointMake(1.0,1.0);
    CGPoint absoluteOrigin = element.frame.origin;
    GLElement *cparent = element.parent;
    GLElement *current = element;
    
    CGPoint elementScale = current.scaleOfElement;
    CGRect elementFrame = current.frame;
    
    absoluteScale = elementScale;
    
    CGPoint elementMidPoint = CGPointMake(elementFrame.origin.x + elementFrame.size.width/2,
                                          elementFrame.origin.y + elementFrame.size.height/2);
    
    absoluteOrigin = CGPointMake(elementMidPoint.x -
                                 (elementScale.x *  (elementFrame.size.width/2)),
                                 (elementMidPoint.y -
                                  (elementScale.y * (elementFrame.size.height/2))));
    
    absoluteOrigin = CGPointMake(self.originOfElement.x + absoluteOrigin.x , self.originOfElement.y + absoluteOrigin.y);
    
    while (cparent != self)
    {
        if (cparent == nil)
            return CGRectZero;
        
        CGRect parentFrame = cparent.frame;
        CGPoint scaleOfParent = cparent.scaleOfElement;
        CGPoint originOfParent = cparent.originOfElement;
        CGPoint scaleInsideParent = cparent.scaleInsideElement;
        CGPoint originInsideParent = cparent.originInsideElement;
        
        absoluteScale = CGPointMake(scaleInsideParent.x * absoluteScale.x * scaleOfParent.x,
                                    scaleInsideParent.y * absoluteScale.y * scaleOfParent.y);
        
        
        absoluteOrigin = CGPointMake((parentFrame.size.width/2) +
                                     (scaleInsideParent.x * scaleOfParent.x * (absoluteOrigin.x - parentFrame.size.width/2)),
                                     (parentFrame.size.height/2) +
                                     (scaleInsideParent.y * scaleOfParent.y * (absoluteOrigin.y - parentFrame.size.height/2)));
        
        absoluteOrigin = CGPointMake(absoluteOrigin.x + parentFrame.origin.x + originInsideParent.x + originOfParent.x,
                                     absoluteOrigin.y + parentFrame.origin.y + originInsideParent.y + originOfParent.y);
        
        current = cparent;
        cparent = cparent.parent;
    }
    
    return CGRectMake(absoluteOrigin.x, absoluteOrigin.y,
                      self.frame.size.width * absoluteScale.x,
                      self.frame.size.height * absoluteScale.y);

}


-(int)numberOfLayers
{
    return 1;
}

-(BOOL)isDrawable
{
    return YES;
}

-(void)draw{
    
    
}

-(void)drawSubElements
{
    
}

//To be accessed only by OpenGLViewController;
static CGFloat ZAxisCoordinate;

-(void)resetZCoordinate
{
    ZAxisCoordinate = 0;
    [mvpMatrixManager resetModelViewMatrixStack];
}

-(void)drawElement
{
    [self update];

    CGRect previousClippingRect = [GLDirector sharedDirector].clippingRect;
    
    if (clipToBounds)
    {
        CGRect mainScreenBounds = [GLDirector sharedDirector].clippingRect;
        CGRect absFrame = self.absoluteFrame;
        CGRect bounds = CGRectIntersection(mainScreenBounds, absFrame);
        glScissor(bounds.origin.x * [[UIScreen mainScreen]scale] , bounds.origin.y * [[UIScreen mainScreen]scale], bounds.size.width * [[UIScreen mainScreen]scale], bounds.size.height* [[UIScreen mainScreen]scale]);
        [GLDirector sharedDirector].clippingRect = bounds;
    }
    
    [mvpMatrixManager pushModelViewMatrix];
    
    [mvpMatrixManager translateInX:self.frame.origin.x Y:self.frame.origin.y Z:ZAxisCoordinate];
    
    [mvpMatrixManager translateInX:self.frame.size.width/2+self.originOfElement.x
                                 Y:self.frame.size.height/2+self.originOfElement.y Z:0];
    
    
    [mvpMatrixManager scaleByXScale:self.scaleOfElement.x  YScale:self.scaleOfElement.y ZScale:1];
    
    [mvpMatrixManager translateInX:(-self.frame.size.width/2)
                                 Y:(-self.frame.size.height/2)
                                 Z:0];
    
    if ([self isDrawable] && !self.hidden)
    {
        if (frameBackgroundColor.alpha > 0)
        {
            ZAxisCoordinate+=1;
            [mvpMatrixManager translateInX:0 Y:0 Z:1];
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            [elementColorRenderer drawWithArray:frameColorData andCount:6];
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
         }
        [self draw];
        
    }
    ZAxisCoordinate += self.numberOfLayers;
    
    [mvpMatrixManager translateInX:self.frame.size.width/2+self.originInsideElement.x
                                 Y:self.frame.size.height/2+self.originInsideElement.y Z:0];

    
    [mvpMatrixManager scaleByXScale:self.scaleInsideElement.x  YScale:self.scaleInsideElement.y ZScale:1];
    
    [mvpMatrixManager translateInX:(-self.frame.size.width/2)
                                 Y:(-self.frame.size.height/2)
                                 Z:0];
  
    [mvpMatrixManager translateInX:0 Y:0 Z:-mvpMatrixManager.zCoordinate];
    

    for (GLElement *element in subElements)
    {
        if (!element.hidden)
            [element drawElement];
    }
    
    ZAxisCoordinate += 1;
    [mvpMatrixManager translateInX:0 Y:0 Z:ZAxisCoordinate];

    [self drawSubElements];

    [mvpMatrixManager popModelViewMatrix];
    
    [GLDirector sharedDirector].clippingRect = previousClippingRect;
    if (clipToBounds)
    {
        CGRect bounds =  [GLDirector sharedDirector].clippingRect;
        glScissor(bounds.origin.x * [[UIScreen mainScreen]scale] , bounds.origin.y * [[UIScreen mainScreen]scale], bounds.size.width * [[UIScreen mainScreen]scale], bounds.size.height* [[UIScreen mainScreen]scale]);
        
    }
}

-(void)update
{
    
}

-(void)setFrameBackgroundColor:(Color4B)_backgroundColor
{
    frameBackgroundColor = _backgroundColor;
    for (int i = 0;i<6;i++)
    { 
        frameColorData[i].color = frameBackgroundColor;
    }
}

-(void)setOpenGLView:(OpenGLES2DView *)openGLView
{
    _openGLView = openGLView;
    for (GLElement *element in subElements)
        element.openGLView = openGLView;
}


-(void)addElement:(GLElement *)e
{
    if (e.parent != nil)
        [e.parent removeElement:e];
    if (subElements == nil)
        subElements = [[NSMutableArray alloc]init];
    e.indexOfElement = subElements.count;
    e.parent = self;
    e.openGLView = self.openGLView;
    [subElements addObject:e];
    [e addedToParent];
}

-(void)moveElementToFront:(GLElement *)e
{
    [e retain];
    [subElements removeObject:e];
    [subElements addObject:e];
    [e release];
    [self reindexSubElements];
}

-(void)moveElementToBack:(GLElement *)e
{
    [e retain];
    [subElements removeObject:e];
    [subElements insertObject:e atIndex:0];
    [e release];
    
    [self reindexSubElements];
}

-(void)moveElement:(GLElement *)e toIndex:(int)index
{
    [e retain];
    [subElements removeObject:e];
    [subElements insertObject:e atIndex:index];
    [e release];
    
    [self reindexSubElements];
}

-(void)removeElement:(GLElement *)e
{
    [e willRemoveFromParent];
    [subElements removeObject:e];
    [self reindexSubElements];
}

-(void)removeAllElements
{
    [subElements removeAllObjects];
}

-(void)moveToFront
{
    [self.parent moveElementToFront:self];
}
-(void)moveToBack
{
    [self.parent moveElementToBack:self];
}
-(void)moveToIndex:(int)index
{
    [self.parent moveElement:self toIndex:index];
}

-(void)removeFromParent
{
    [self.parent removeElement:self];
}

-(void)reindexSubElements
{
    int index = 0;
    for (GLElement *element in subElements)
    {
        element.indexOfElement = index;
        index++;
    }
}

-(void)addedToParent
{
    
}

-(void)willRemoveFromParent
{
    
}


-(void)addGestureRecognizer:(GLElement *)gestureRecognizer
{
    if (gestureRecognizers == nil)
        gestureRecognizers = [[NSMutableArray alloc]init];
    gestureRecognizer.parent = self;
    [gestureRecognizers addObject:gestureRecognizer];
}

-(void)removeGestureRecognizer:(GLElement *)gestureRecognizer
{
    [gestureRecognizers removeObject:gestureRecognizer];
}

-(void)removeAllGestureRecognizers
{
    [gestureRecognizers removeAllObjects];
}



-(GLElement *)getElementByTag:(int)etag
{
    for (GLElement *e in subElements)
    {
        if (e.tag == etag)
            return e;
    }
    return nil;
}

-(BOOL)isTouchInside:(UITouch *)touch
{
    CGPoint l = [touch locationInGLElement:self];
    CGRect absframe = self.absoluteFrame;
    if (l.x >= 0 && l.y >=0 && l.x <=absframe.size.width && l.y<=absframe.size.height)
    {
        return YES;
    }
    return NO;
}

-(BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.enabled)
        return NO;
    CGPoint l = [touch locationInGLElement:self];
    CGRect absframe = self.absoluteFrame;
    if (l.x >= 0 && l.y >=0 && l.x <=absframe.size.width && l.y<=absframe.size.height)
    {
        for (GLElement *element in gestureRecognizers)
        {
            ([element touchBegan:touch withEvent:event]);
        }
        
        for (GLElement *element in subElements.reverseObjectEnumerator)
        {
            if ([element touchBegan:touch withEvent:event])
                return YES;
        }
        
        if (!self.acceptsTouches)
            return NO;
        
        [touchesInElement addObject:touch];
        [self touchBeganInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        return YES;
    }
    
    return NO;
}
-(BOOL)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.enabled)
        return NO;
    for (GLElement *element in gestureRecognizers)
    {
        ([element touchMoved:touch withEvent:event]);
    }
    
    for (GLElement *element in subElements.reverseObjectEnumerator)
    {
        if ([element touchMoved:touch withEvent:event])
            return YES;
    }
    
    
    if (!self.acceptsTouches)
        return NO;
    
    if ([touchesInElement containsObject:touch])
    {
        [self touchMovedInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        return YES;
    }
    return NO;
}
-(BOOL)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!self.enabled)
        return NO;
    for (GLElement *element in gestureRecognizers)
    {
        ([element touchEnded:touch withEvent:event]);
    }
    
    for (GLElement *element in subElements.reverseObjectEnumerator)
    {
        if ([element touchEnded:touch withEvent:event])
            return YES;
    }
    
    if (!self.acceptsTouches)
        return NO;
    
    
    if ([touchesInElement containsObject:touch])
    {
        CGPoint touchPoint = [touch locationInGLElement:self];
        CGRect absframe = self.absoluteFrame;
        if (touchPoint.x >= 0 && touchPoint.y >= 0 &&
            touchPoint.x <= absframe.size.width && touchPoint.y <=absframe.size.height)
                [self touchEndedInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        else
                [self touchCancelledInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:event];
        [touchesInElement removeObject:touch];
        return YES;
    }
    return NO;
}

-(void)cancelTouchesInElement
{
    for (UITouch *touch in touchesInElement)
    {
        [self touchCancelledInElement:touch withIndex:[touchesInElement indexOfObject:touch] withEvent:
                                                                                                nil];
    }
    [touchesInElement removeAllObjects];
}

-(void)cancelTouchesInSubElements
{
    for (GLElement *element in subElements)
    {
        [element cancelTouchesInElement];
        [element cancelTouchesInSubElements];
    }
}

-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
	
}
-(void)touchMovedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
	
}
-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
	
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    
}

-(void)elementDidAppear
{
    for (GLElement *element in subElements)
        [element elementDidAppear];
}
-(void)elementWillAppear
{
    for (GLElement *element in subElements)
        [element elementWillAppear];
}
-(void)elementDidDisappear
{
    for (GLElement *element in subElements)
        [element elementDidDisappear];
}
-(void)elementWillDisappear
{
    for (GLElement *element in subElements)
        [element elementWillDisappear];
}

//Animations

-(void)setScaleOfElement:(CGPoint)_scaleOfElement
{
    scaleOfElement = _scaleOfElement;
}

-(Animation *)scaleFrom:(CGPoint)startScale To:(CGPoint)endScale withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setDataType:AnimationDataTypeCGPoint];
    [anim setStartValue:&startScale];
    [anim setEndValue:&endScale];
        anim.delegate = self;
    anim.identifier = ANIMATION_ELEMENT_SCALE;
    anim.animationUpdateBlock = ^(Animation *anim)
    {
        self.scaleOfElement = [anim getCurrentValueForCGPoint];
        return NO;
    };
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}

-(Animation *)scaleInsideFrom:(CGPoint)startScale To:(CGPoint)endScale withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setDataType:AnimationDataTypeCGPoint];
    [anim setStartValue:&startScale];
    [anim setEndValue:&endScale];
    anim.delegate = self;
    anim.identifier = ANIMATION_ELEMENT_SCALE_INSIDE;
    anim.animationUpdateBlock = ^(Animation *anim)
    {
        self.scaleInsideElement = [anim getCurrentValueForCGPoint];
        return NO;
    };
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}
-(Animation *)changeFrame:(CGRect)startRect To:(CGRect)endRect withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setDataType:AnimationDataTypeCGRect];
    [anim setStartValue:&startRect];
    [anim setEndValue:&endRect];
        anim.delegate = self;
    anim.identifier = ANIMATION_ELEMENT_CHANGE_RECT;
    anim.animationUpdateBlock = ^(Animation *anim)
    {
        self.frame = [anim getCurrentValueForCGRect];
        return NO;
    };
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}

-(Animation *)moveFrom:(CGPoint)startPoint To:(CGPoint)endPoint withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setDataType:AnimationDataTypeCustom];
    [anim setStartValue:&startPoint OfSize:sizeof(CGPoint)];
    [anim setEndValue:&endPoint OfSize:sizeof(CGPoint)];
        anim.delegate = self;
    anim.identifier = ANIMATION_ELEMENT_CHANGE_RECT;
    anim.animationUpdateBlock = ^(Animation *anim)
    {
        CGPoint *startPoint = (CGPoint *)[anim getStartValue];
        CGPoint *endPoint = (CGPoint *)[anim getEndValue];
        
        CGFloat x = [anim getValue:startPoint->x :endPoint->x];
        CGFloat y = [anim getValue:startPoint->y :endPoint->y];
        self.frame = CGRectIntegral(CGRectMake(x, y, self.frame.size.width, self.frame.size.height));
        return NO;
    };
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}

-(Animation *)moveOriginFrom:(CGPoint)startPoint To:(CGPoint)endPoint withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setDataType:AnimationDataTypeCGPoint];
    [anim setStartValue:&startPoint];
    [anim setEndValue:&endPoint];
        anim.delegate = self;
    anim.identifier = ANIMATION_ELEMENT_MOVE_ORIGIN;
    anim.animationUpdateBlock = ^(Animation *anim)
    {
        originOfElement = [anim getCurrentValueForCGPoint];
        originOfElement = CGPointMake(floorf(originOfElement.x*10)/10, floorf(originOfElement.y*10)/10);
        return NO;
    };
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}

-(Animation *)moveOriginInsideFrom:(CGPoint)startPoint To:(CGPoint)endPoint withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setDataType:AnimationDataTypeCGPoint];
    [anim setStartValue:&startPoint];
    [anim setEndValue:&endPoint];
    anim.delegate = self;
    anim.identifier = ANIMATION_ELEMENT_MOVE_ORIGIN_INSIDE;
    anim.animationUpdateBlock =  ^(Animation *animation)
    {
        originInsideElement = [animation getCurrentValueForCGPoint];
        originInsideElement = CGPointMake(floorf(originInsideElement.x*10)/10, floorf(originInsideElement.y*10)/10);
        return NO;
    };
    
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}


-(BOOL)isPointInside:(CGPoint)point
{
    BOOL pointInside = NO;
    
    for (GLElement *element in subElements)
    {
        pointInside = [element isPointInside:point];
        if (pointInside)
            return YES;
    }
    
   
    CGPoint l = [self locationOfPointInElement:point];
    CGRect absframe = self.absoluteFrame;
    if (!self.acceptsTouches)
        return NO;
    int x2 = absframe.origin.x + absframe.size.width;
    int y2 = absframe.origin.y + absframe.size.height;
    
    if (l.x >= absframe.origin.x && l.y >=absframe.origin.y && l.x <= x2 && l.y<=  y2)
    {
        return YES;
    }
    return NO;
}


-(CGPoint)locationOfPointInElement:(CGPoint)point
{
    CGPoint locationInView = point;
    CGPoint locationInOpenGLView = CGPointMake(locationInView.x,
                                               self.openGLView.frame.size.height - locationInView.y);
   /* CGRect absframe = self.absoluteFrame;
    
    CGPoint loc = CGPointMake(locationInOpenGLView.x - absframe.origin.x,
                              locationInOpenGLView.y - absframe.origin.y);*/
    
    return locationInOpenGLView;
}

-(Animation *)getAnimationForColorChangeFrom:(Color4B)startColor To:(Color4B)endColor withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType
{
    if (curveType == EasingSine)
        return nil;
    Animation *anim = [animator getAnimationOfType:curveType];
    [anim setStartValue:&startColor OfSize:sizeof(Color4B)];
    [anim setEndValue:&endColor OfSize:sizeof(Color4B)];
        anim.delegate = self;
    anim.identifier = ANIMATION_ELEMENT_COLOR_CHANGE;
    anim.duration = duration;
    anim.delay = delay;
    [animator addAnimation:anim];
    return anim;
}


-(void)dealloc
{
    free(frameColorData);
    [gestureRecognizers release];
    [subElements release];
    self.parent = nil;
    self.touchesInElement = nil;
    [super dealloc];
}
@end
