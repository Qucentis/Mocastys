//
//  GLNode.h
//  GameDemo
//
//  Created by Rakesh on 11/11/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animator.h"
#import "TextureManager.h"
#import "MVPMatrixManager.h"
#import "OpenGLES2DView.h"
#import "GLDirector.h"
#import "SpriteSheet.h"
#import "FontSpriteSheet.h"
#import "UITouch+GLElement.h"
#import "GLShaderManager.h"
#import "GLRendererManager.h"
#import "EasingFunctions.h"

#define ANIMATION_ELEMENT_SCALE 1
#define ANIMATION_ELEMENT_SCALE_INSIDE 2
#define ANIMATION_ELEMENT_MOVE 3
#define ANIMATION_ELEMENT_MOVE_ORIGIN 4
#define ANIMATION_ELEMENT_MOVE_ORIGIN_INSIDE 5
#define ANIMATION_ELEMENT_COLOR_CHANGE 6
#define ANIMATION_ELEMENT_CHANGE_RECT 7


@class AppDelegate;

@interface GLElement : NSObject
{
    CGRect frame;
    GLElement *parent;
    
    int tag;
    int numberOfLayers;
    
    NSMutableArray *touchesInElement;
    NSMutableArray *subElements;
    NSMutableArray *gestureRecognizers;
    
    GLDirector *director;
    Animator *animator;
    TextureManager *textureManager;
    MVPMatrixManager *mvpMatrixManager;
    GLShaderManager *shaderManager;
    GLRendererManager *rendererManager;
    
    CGPoint scaleInsideElement;
    CGPoint originInsideElement;
    
    CGPoint scaleOfElement;
    CGPoint originOfElement;
    
    VertexColorData *frameColorData;
    GLRenderer *elementColorRenderer;
    
    Color4B frameBackgroundColor;
    
    BOOL clipToBounds;
    BOOL requiresMipMap;
}

@property (nonatomic,readonly) AppDelegate *appDelegate;
@property (nonatomic) BOOL hidden;
@property (nonatomic) BOOL clipToBounds;
@property (nonatomic) int tag;
@property (nonatomic) int indexOfElement;

@property (nonatomic) CGRect frame;
@property (nonatomic) CGPoint scaleInsideElement;
@property (nonatomic) CGPoint originInsideElement;

@property (nonatomic) CGPoint scaleOfElement;
@property (nonatomic) CGPoint originOfElement;


@property (nonatomic,readonly) CGPoint absoluteScale;
@property (nonatomic,readonly) CGRect absoluteFrame;
@property (nonatomic,readonly) int numberOfLayers;
@property (nonatomic,assign) BOOL acceptsTouches;
@property (nonatomic,readonly)     NSMutableArray *subElements;

@property (nonatomic,assign) GLElement *parent;
@property (nonatomic,retain) OpenGLES2DView *openGLView;
@property (nonatomic,retain) NSMutableArray *touchesInElement;
@property (nonatomic) Color4B frameBackgroundColor;
@property (nonatomic) BOOL requiresMipMap;
@property (nonatomic) BOOL enabled;

-(void)drawElement;
-(BOOL)isTouchInside:(UITouch *)touch;
-(BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(BOOL)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
-(BOOL)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)update;
-(void)draw;

-(id)initWithFrame:(CGRect)_frame;
-(void)addElement:(GLElement *)e;
-(void)moveElementToFront:(GLElement *)e;
-(void)moveElementToBack:(GLElement *)e;
-(void)moveElement:(GLElement *)e toIndex:(int)index;
-(void)removeElement:(GLElement *)e;
-(void)removeAllElements;
-(void)moveToFront;
-(void)moveToBack;
-(void)moveToIndex:(int)index;
-(GLElement *)getElementByTag:(int)etag;
-(void)addGestureRecognizer:(GLElement *)gestureRecognizer;
-(void)removeGestureRecognizer:(GLElement *)gestureRecognizer;
-(void)removeAllGestureRecognizers;
-(void)cancelTouchesInElement;
-(void)cancelTouchesInSubElements;

-(void)addedToParent;
-(void)willRemoveFromParent;

-(void)elementDidAppear;
-(void)elementWillAppear;
-(void)elementDidDisappear;
-(void)elementWillDisappear;

-(CGRect)relativeFrameOfSubElement:(GLElement *)element;

//To be accessed only by OpenGLViewController;
-(void)resetZCoordinate;

-(BOOL)isPointInside:(CGPoint)point;

//Animation Functions
-(Animation *)scaleFrom:(CGPoint)startScale To:(CGPoint)endScale withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;
-(Animation *)scaleInsideFrom:(CGPoint)startScale To:(CGPoint)endScale withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;
-(Animation *)changeFrame:(CGRect)startRect To:(CGRect)endRect withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;
-(Animation *)moveFrom:(CGPoint)startPoint To:(CGPoint)endPoint withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;
-(Animation *)moveOriginFrom:(CGPoint)startPoint To:(CGPoint)endPoint withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;
-(Animation *)moveOriginInsideFrom:(CGPoint)startPoint To:(CGPoint)endPoint withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;
-(Animation *)getAnimationForColorChangeFrom:(Color4B)startColor To:(Color4B)endColor withDuration:(CGFloat)duration afterDelay:(CGFloat)delay usingCurve:(EasingCurveType)curveType;

@end
