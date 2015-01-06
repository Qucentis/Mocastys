//
//  OpenGLViewController.m
//  GameDemo
//
//  Created by Rakesh on 12/11/09.
//  Copyright 2009 Qucentis. All rights reserved.
//

#import "OpenGLViewController.h"
#import "GLDirector.h"
#import "RootOpenGLView.h"
#import "OverlayOpenGLView.h"


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation OpenGLViewController

@synthesize interfaceOrientation,rootOpenGLView,overlayOpenGLView;

-(id)initWithInterfaceOrientation:(UIInterfaceOrientation)_interfaceOrientation
{

	if (self = [super init])
	{
        CGFloat screen_width = [UIScreen mainScreen].bounds.size.width ;
        CGFloat screen_height = [UIScreen mainScreen].bounds.size.height - 20;
       
        CGFloat navBar_height = screen_height;
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width ,  [UIScreen mainScreen].bounds.size.height);
            
            self.view.backgroundColor = [UIColor blackColor];
            
            interfaceOrientation = _interfaceOrientation;
            switch (interfaceOrientation){
                case UIInterfaceOrientationLandscapeLeft:
                    NSLog(@"Setting Landscape");
                    rootOpenGLView = [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_height, screen_width)];
                    overlayOpenGLView = [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_height, screen_width)];
                    
                    break;
                case UIInterfaceOrientationPortrait:
                    NSLog(@"Setting Portrait");
                    rootOpenGLView= [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
                    overlayOpenGLView= [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_width, navBar_height)];
                    
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    NSLog(@"Setting Landscape");
                    rootOpenGLView = [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_height, screen_width)];
                    overlayOpenGLView = [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_height, screen_width)];
                    
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    NSLog(@"Setting Portrait");
                    rootOpenGLView = [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
                    overlayOpenGLView = [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
                    break;
            }

        }
        else
        {
        
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width ,  [UIScreen mainScreen].bounds.size.height);
        
        self.view.backgroundColor = [UIColor blackColor];
        
		interfaceOrientation = _interfaceOrientation;
		switch (interfaceOrientation){
			case UIInterfaceOrientationLandscapeLeft:
				NSLog(@"Setting Landscape");
				rootOpenGLView = [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_height, screen_width)];
                overlayOpenGLView = [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_height, screen_width)];

				break;
			case UIInterfaceOrientationPortrait:
				NSLog(@"Setting Portrait");
				rootOpenGLView= [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_width, screen_height)];
                overlayOpenGLView= [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_width, screen_height)];

				break;
			case UIInterfaceOrientationLandscapeRight:
				NSLog(@"Setting Landscape");
				rootOpenGLView = [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_height, screen_width)];
                overlayOpenGLView = [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_height, screen_width)];
             
				break;
			case UIInterfaceOrientationPortraitUpsideDown:
				NSLog(@"Setting Portrait");
				rootOpenGLView = [[RootOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_width, screen_height)];
                overlayOpenGLView = [[OverlayOpenGLView alloc]initWithFrame:CGRectMake(0, 20, screen_width, screen_height)];
				break;
		}
        }
        [self.view addSubview:rootOpenGLView];
        [self.view addSubview:overlayOpenGLView];
        
	}
	return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)_interfaceOrientation {
    return (_interfaceOrientation == interfaceOrientation);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        // User was shaking the device. Post a notification named "shake."
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
