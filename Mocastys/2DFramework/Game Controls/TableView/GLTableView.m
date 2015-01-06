//
//  GLTableView.m
//  KBC
//
//  Created by Rakesh on 05/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLTableView.h"

#define delayForTouch 0.05

#define maximumBounceBackDistance 70

#define ANIMATION_BOUNCEBACK 1
#define ANIMATION_UPDATE 2

@interface GLTableViewCellFrame : NSObject
@property (nonatomic) int destinationIndex;
@property (nonatomic) int currentIndex;
@property (nonatomic,assign) GLTableViewCell *tableViewCell;
@end

@implementation GLTableViewCellFrame

@end

@implementation GLTableView

@synthesize isReloading,numberOfRows,rowHeight;

-(id)initWithFrame:(CGRect)_frame
{
    if (self = [super initWithFrame:_frame])
    {
        if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            headerSize = 70;
        else
            headerSize = 100;

        
        _isReindexing = YES;
        touchesInsideTable = [[NSMutableArray alloc]init];
        insertedCells = [[NSMutableArray alloc]init];
        deletedCells = [[NSMutableArray alloc]init];
        
        verticalSwipeRecognizer = [[SwipeGestureRecognizer alloc]init];
        [self addGestureRecognizer:verticalSwipeRecognizer];
        [verticalSwipeRecognizer setGestures:GESTURE_VERTICALSWIPE];
        [verticalSwipeRecognizer addTarget:self andSelector:@selector(scrollDetected:)];
        [verticalSwipeRecognizer release];
    }
    return self;
}

-(void)scrollDetected:(NSArray *)eventArgs
{
    [self cancelTouchesInSubElements];
    [self.touchesInElement addObject:eventArgs[0]];
    [self touchBeganInElement:eventArgs[0] withIndex:[self.touchesInElement indexOfObject:eventArgs[0]]
                                                                                withEvent:nil];
}


-(BOOL)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint l = [touch locationInGLElement:self];
    CGRect absframe = self.absoluteFrame;
    if (l.x >= 0 && l.y >=0 && l.x <=absframe.size.width && l.y<=absframe.size.height)
    {
        [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
        [animator removeRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
        speed = 0;
        
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



-(void)touchBeganInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
	touchStartPoint = [touch locationInGLElement:self];
    distY = 0;
    touchStartTime = CFAbsoluteTimeGetCurrent();
    [animator removeQueuedAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
    [animator removeRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK];
}
-(void)touchMovedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
	CGPoint touchPoint = [touch locationInGLElement:self];
    
    CGPoint newOrgin = CGPointMake(originInsideElement.x,originInsideElement.y+touchPoint.y - touchStartPoint.y);
    
    CGFloat diffHeight = numberOfRows * rowHeight - self.frame.size.height + headerSize;
    if (diffHeight < 0)
        diffHeight = 0;
    
    if (newOrgin.y <= -maximumBounceBackDistance)
    {
        newOrgin = CGPointMake(0, -maximumBounceBackDistance);
    }
    else if  (newOrgin.y >= diffHeight + maximumBounceBackDistance)
    {
        newOrgin = CGPointMake(0, diffHeight + maximumBounceBackDistance);
    }
    self.originInsideElement = newOrgin;
    
    CGFloat cDist = distY;
    distY += (touchStartPoint.y - touchPoint.y);
    if (fabs(distY)< fabs(cDist))
    {
        distY = 0;
        touchStartTime = CFAbsoluteTimeGetCurrent();
    }
    touchStartPoint = touchPoint;
    
    
}
-(void)touchEndedInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    delay = CFAbsoluteTimeGetCurrent() - touchStartTime;
    speed =  distY/delay;
    speed = roundf(speed)/30;
    
}

-(void)touchCancelledInElement:(UITouch *)touch withIndex:(int)index withEvent:(UIEvent *)event
{
    
}

-(void)update
{
    if (fabs(speed) < 1)
        speed = 0;
    else
        speed/=1.05;
    
    
    
    CGPoint newOrgin = CGPointMake(originInsideElement.x,originInsideElement.y-roundf(speed));
    CGFloat diffHeight = numberOfRows * rowHeight - self.frame.size.height + headerSize;
    if (diffHeight < 0)
        diffHeight = 0;
    
    if (newOrgin.y < 0 || newOrgin.y > diffHeight)
        speed /=2;
    
    
    if (newOrgin.y < -maximumBounceBackDistance)
    {
        speed = 0;
    }
    else if  (newOrgin.y >= diffHeight + maximumBounceBackDistance)
    {
        speed = 0;
    }
    if (self.touchesInElement.count == 0 && speed == 0)
    {
        if (newOrgin.y < 0)
        {
            speed = 0;
            if ([animator getCountOfRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK] == 0)
            {
                EasingAnimation *animation = (EasingAnimation *)[animator addAnimationOfType:EasingOrdered];
                                    animation.easingType = EaseOut;
                CGFloat startValue = newOrgin.y;
                CGFloat endval = 0;
                [animation setStartValue:&startValue OfSize:sizeof(CGFloat)];
                [animation setEndValue:&endval OfSize:sizeof(CGFloat)];
                animation.identifier = ANIMATION_BOUNCEBACK;
                animation.delegate = self;
                animation.duration = 0.3;
                animation.animationUpdateBlock = ^(Animation *anim)
                {
                    self.originInsideElement = CGPointMake(0, [anim getCurrentValueForCGFloat]);
                    return NO;
                };
                
            }
        }
        else if (newOrgin.y > diffHeight)
            {
                speed = 0;
                if ([animator getCountOfRunningAnimationsForObject:self ofType:ANIMATION_BOUNCEBACK] == 0)
                {
                    EasingAnimation *animation = (EasingAnimation *)[animator addAnimationOfType:EasingOrdered];
                    animation.easingType = EaseOut;
                    CGFloat startValue = newOrgin.y;
                    CGFloat endval = diffHeight;
             
                    [animation setStartValue:&startValue OfSize:sizeof(CGFloat)];
                    [animation setEndValue:&endval OfSize:sizeof(CGFloat)];
                    animation.identifier = ANIMATION_BOUNCEBACK;
                    animation.delegate = self;
                    animation.duration = 0.3;
                    animation.animationUpdateBlock = ^(Animation *anim)
                    {
                        self.originInsideElement = CGPointMake(0, [anim getCurrentValueForCGFloat]);
                        return NO;
                    };
                    
                }
            }
    }
    self.originInsideElement = newOrgin;
    
//    if (!_isReindexing)
  //      return;
    
    [self queueOutOfBoundsCells];
    [self checkCellInBounds];
    
}

-(void)queueOutOfBoundsCells
{
    for (int i = 0;i<cellsInTable.count;i++)
    {
        GLTableViewCell *cell = cellsInTable[i];
        if (cell.isVisible)
        {
            CGRect newFrame = CGRectOffset(cell.frame, self.originInsideElement.x, self.originInsideElement.y);
            if ((newFrame.origin.y > self.frame.origin.y + 2 * self.frame.size.height)||
                (newFrame.origin.y  + 2 * newFrame.size.height < 0))
            {
                cell.isVisible = NO;
                cell.hidden = YES;
                cell.animationOffset = 0;
                cell.rowIndex = -1;
                [outofBoundsCells addObject:cell];
                [self removeElement:cell];
            }
        }
    }
}

-(GLTableViewCell *)dequeueCell
{
    if (outofBoundsCells.count <= 0)
        return nil;
    GLTableViewCell *cell = outofBoundsCells[0];
    cell.isVisible = YES;
    cell.hidden = NO;
    cell.animationOffset = 0;
    [cell retain];
    [outofBoundsCells removeObject:cell];
    
    return cell;
}

-(int)numberOfLayers
{
    return cellsInTable.count * 2;
}

-(BOOL)isRowVisible:(int)index
{
    for (GLTableViewCell *cell in cellsInTable)
    {
        if (cell.rowIndex == index)
            return YES;
    }
    return NO;
}

-(void)checkCellInBounds
{
    int numberOfVisibleCells = (int)ceilf(self.frame.size.height/rowHeight)+2;
    int indexOfStartCell = (int)floorf(self.originInsideElement.y/rowHeight)-2;
    int endIndexOfCell = indexOfStartCell + numberOfVisibleCells;
    
    for (int i = 0;i<numberOfVisibleCells;i++)
    {
        int r = indexOfStartCell + i;
        if (r >= numberOfRows || r < 0)
            continue;
        if (![self isRowVisible:r])
        {
            GLTableViewCell *cell = [self.dataSource cellForRowAtIndex:r];
            cell.rowIndex = r;
            cell.isVisible = YES;
            cell.hidden = NO;
            
        //    CGFloat offset = 0;
            
            CGFloat bottomY = self.frame.size.height - headerSize -
            (rowHeight * (r+1));
            
            if (updateAnimation != nil)
            {
             //   CGFloat animationRatio = [updateAnimation getAnimatedRatio];
                
                
            }
            
            cell.frame = CGRectMake(0, bottomY, self.frame.size.width, rowHeight);
            [self checkCellAndAdd:cell];
            [self addElement:cell];
        }
    }
}

-(void)checkCellAndAdd:(GLTableViewCell *)cell
{
    if (!cell.wasInsertedInTable)
    {
        cell.wasInsertedInTable = YES;
        [cellsInTable addObject:cell];
    }
}

-(void)animate
{
    for (GLTableViewCell *cell in cellsInTable)
    {
        [cell animate];
    }
}

-(BOOL)beginUpdates
{
    if (insertedCells.count == 0 && deletedCells.count == 0)
        return YES;
    return NO;
}

-(void)insertCellAtIndex:(int)index
{
    GLTableViewCellFrame *cellFrame = [[GLTableViewCellFrame alloc]init];
    cellFrame.currentIndex = cellFrame.destinationIndex = index;
    [cellFrames insertObject:cellFrame atIndex:index];
    [cellFrame release];
    
    for (int i = index+1;i<cellFrames.count;i++)
    {
        GLTableViewCellFrame *cellFrame = cellFrames[i];
        cellFrame.destinationIndex = cellFrame.currentIndex + 1;
    }
}

-(void)deleteCellAtIndex:(int)index
{
    if ([self.dataSource respondsToSelector:@selector(deleteRowsFromDataSource:)])
    {
        for (int i = index+1;i<cellFrames.count;i++)
        {
            GLTableViewCellFrame *cellFrame = cellFrames[i];
            cellFrame.destinationIndex = cellFrame.currentIndex - 1;
        }
    }
}



-(void)endUpdates
{

    if ((insertedCells.count != 0 || deletedCells.count != 0) && updateAnimation == nil)
    {

    }
}

-(void)enableTouch
{
    self.acceptsTouches = YES;
}

-(GLTableViewCell *)cellAtRow:(int)row
{
    for (int i = 0;i<cellsInTable.count;i++)
    {
        GLTableViewCell *cell = cellsInTable[i];
        if (cell.rowIndex == row && cell.isVisible)
        {
            return cell;
        }
    }
    return nil;
}

-(void)reloadData:(BOOL)animated
{
    isReloading = YES;
    int count = [self.dataSource numberOfRows];
    CGFloat height = [self.dataSource heightOfRow];
    
    if (cellsInTable != nil)
    {
        [self.subElements removeObjectsInArray:cellsInTable];
        [cellsInTable removeAllObjects];
        [outofBoundsCells removeAllObjects];
        [cellFrames removeAllObjects];
        [insertedCells removeAllObjects];
        [deletedCells removeAllObjects];
    }
    else
    {
        cellsInTable = [[NSMutableArray alloc]init];
        outofBoundsCells = [[NSMutableArray alloc]init];
        cellFrames = [[NSMutableArray alloc]init];
    }
    
    for (int i = 0;i<count;i++)
    {
        GLTableViewCellFrame *cellFrame = [[GLTableViewCellFrame alloc]init];
        cellFrame.currentIndex = cellFrame.destinationIndex = i;
        [cellFrames addObject:cellFrame];
        [cellFrame release];
    }
    
    CGFloat totalHeight = self.frame.size.height;
    int numberOfCells = ceilf(totalHeight/height)+2;
    if (numberOfCells > count)
        numberOfCells = count;
    
    numberOfRows = count;
    rowHeight = height;
    
    
    for (int i = 0;i<numberOfCells;i++)
    {
        GLTableViewCellFrame *cellFrame = cellFrames[i];
        GLTableViewCell *cell = [self.dataSource cellForRowAtIndex:i];
        cell.rowIndex = i;
        cell.isVisible = YES;
        cell.hidden = NO;
        CGFloat bottomY = self.frame.size.height -headerSize - (height * (i+1));
        cell.frame = CGRectMake(0, bottomY, self.frame.size.width, height);
        cellFrame.tableViewCell = cell;
        if (!cell.wasInsertedInTable)
        {
            cell.wasInsertedInTable = YES;
            [self addElement:cell];
            [cellsInTable addObject:cell];
        }
        [cell release];
    }
    if (animated)
    {
        for (GLTableViewCell *cell in cellsInTable)
        {
            [cell animate];
        }
    }
    
    isReloading = NO;
}

-(void)clearData
{
    for (GLTableViewCell *cell in cellsInTable)
    {
        [outofBoundsCells addObject:cell];
        [self removeElement:cell];
        cell.wasInsertedInTable = YES;
    }
}

-(void)refreshData
{
    int count = [self.dataSource numberOfRows];
    CGFloat height = [self.dataSource heightOfRow];

    CGFloat totalHeight = self.frame.size.height;
    int numberOfCells = ceilf(totalHeight/height)+2;
    if (numberOfCells > count)
        numberOfCells = count;
    
    numberOfRows = count;
    rowHeight = height;
    
    for (GLTableViewCell *cell in cellsInTable)
    {
        [outofBoundsCells addObject:cell];
        [self removeElement:cell];
        cell.wasInsertedInTable = YES;
    }
    
    for (int i = 0;i<numberOfCells;i++)
    {
        GLTableViewCellFrame *cellFrame = cellFrames[i];
        GLTableViewCell *cell = [self.dataSource cellForRowAtIndex:i];
        cell.rowIndex = i;
        cell.isVisible = YES;
        cell.hidden = NO;
        CGFloat bottomY = self.frame.size.height -headerSize - (height * (i+1));
        cell.frame = CGRectMake(0, bottomY, self.frame.size.width, height);
        cellFrame.tableViewCell = cell;
        [self addElement:cell];
        [cell release];
    }
}

@end
