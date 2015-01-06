//
//  UIImage+UIImage_RoundedMask.h
//  KBC
//
//  Created by Rakesh on 04/10/13.
//  Copyright (c) 2013 Rakesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_RoundedMask)
-(UIImage *)getRoundedImageWithRect:(CGRect)rect;
-(UIImage *)createThumbnailOfSize:(CGSize)destinationSize;
@end
