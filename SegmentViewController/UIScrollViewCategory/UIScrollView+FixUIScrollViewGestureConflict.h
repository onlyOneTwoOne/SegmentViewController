//
//  UIScrollView+FixUIScrollViewGestureConflict.h
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 16/3/9.
//  Copyright © 2016年 Formax. All rights reserved.
//  处理UIScrollView滑动滑动手势与其他手势的冲突(eg.UINavigationController的右滑返回的手势:http://stackoverflow.com/questions/23267929/combine-uipageviewcontroller-swipes-with-ios-7-uinavigationcontroller-back-swipe)

#import <UIKit/UIKit.h>

@interface UIScrollView (FixUIScrollViewGestureConflict)
- (void)fm_fixScrollGestureConflictWith:(UIGestureRecognizer *)otherGestureRecognizer;
@end
