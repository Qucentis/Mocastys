//
//  GLTableView.h
//  KBC
//
//  Created by Rakesh on 05/09/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import "GLElement.h"
#import "GLTableViewCell.h"
#import "SwipeGestureRecognizer.h"

#define TOUCHSTATE_VERTICALSCROLL 1
#define TOUCHSTATE_HORIZONTALSCROLL 2


@protocol GLTableViewDataSource
-(GLTableViewCell *)cellForRowAtIndex:(int)index;
-(int)numberOfRows;
@optional
-(void)deleteRowsFromDataSource:(NSMutableIndexSet *)rowIndices;
-(CGFloat)heightOfRow;
@end

@protocol GLTableViewDelegate
@optional
-(void)cellSelected:(GLTableViewCell *)cell;
@end

@interface GLTableView : GLElement
{
    NSMutableArray *outofBoundsCells;
    NSMutableArray *cellsInTable;
    
    NSMutableArray *touchesInsideTable;
    
    NSArray *queuedEventArray;
    
    CGPoint touchStartPoint;
    int numberOfRows;
    CGFloat rowHeight;
    double speed;
    double touchStartTime;
    double delay;
    double distY;
    BOOL isReloading;
    CGFloat headerSize;
    
    NSMutableArray *insertedCells;
    NSMutableArray *deletedCells;
    
    NSMutableArray *cellFrames;
    Animation *updateAnimation;
    
    int touchState;
    int touchDistance;
    
    SwipeGestureRecognizer *verticalSwipeRecognizer;
}

@property (nonatomic,retain) NSObject<GLTableViewDataSource> *dataSource;
@property (nonatomic,retain) NSObject<GLTableViewDelegate> *delegate;
@property (nonatomic) BOOL isReloading;
@property (nonatomic,readonly) int numberOfRows;
@property (nonatomic,readonly) CGFloat rowHeight;
@property (nonatomic) BOOL isReindexing;

-(void)reloadData:(BOOL)animated;
-(GLTableViewCell *)dequeueCell;
-(GLTableViewCell *)cellAtRow:(int)row;
-(void)insertCellAtIndex:(int)index;
-(void)deleteCellAtIndex:(int)index;
-(BOOL)isRowVisible:(int)index;
-(BOOL)beginUpdates;
-(void)endUpdates;
-(void)animate;
-(void)refreshData;
-(void)clearData;
@end
