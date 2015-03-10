//
//  UIView+AverageRange.h
//  WeTime
//
//  Created by Aevitx on 14/11/29.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//
//  from http://adad184.com/2014/09/28/use-masonry-to-quick-solve-autolayout/

#import <UIKit/UIKit.h>

@interface UIView (AverageRange)

/**
 *  水平方向，平均分布views
 *
 *  @param views 所有子views
 */
- (void)distributeSpacingHorizontallyWith:(NSArray*)views;


/**
 *  竖直方向，平均分布views
 *
 *  @param views 所有子views
 */
- (void)distributeSpacingVerticallyWith:(NSArray*)views;

@end
