//
//  ScenePager.h
//  KBC
//
//  Created by Rakesh on 13/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLScene.h"
#import "NavigationBar.h"

@interface ScenePager : GLScene
{
    NSMutableArray *elements;
    
    int previousPage;
    int currentPage;
 
    NavigationBar *navigationBar;
    NSMutableArray *origins;
}

-(void)addElement:(GLElement *)element atOrigin:(CGPoint)origin;
-(void)setPage:(int)page animated:(BOOL)animated;
@end
