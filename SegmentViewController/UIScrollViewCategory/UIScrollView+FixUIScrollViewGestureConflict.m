//
//  UIScrollView+FixUIScrollViewGestureConflict.m
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 16/3/9.
//  Copyright © 2016年 Formax. All rights reserved.
//

#import "UIScrollView+FixUIScrollViewGestureConflict.h"

@implementation UIScrollView (FixUIScrollViewGestureConflict)
- (void)fm_fixScrollGestureConflictWith:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if (!otherGestureRecognizer || ![otherGestureRecognizer isKindOfClass:[UIGestureRecognizer class]]) return;
    
    [self.panGestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
}
@end
