//
//  LTSegmentedView+private.h
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 16/4/27.
//  Copyright © 2016年 Formax. All rights reserved.
//

#import "LTSegmentedView.h"

@interface LTSegmentedView (private)
- (UIView*) selectedItem;
- (UIView*) itemOfIndex:(NSInteger) index;

- (CGFloat) itemWidthAtIndex:(NSInteger) index;
- (CGFloat) itemOriginXInContentViewAtIndex:(NSInteger) index;
- (CGFloat) itemMinXInContentViewAtIndex:(NSInteger) index;
- (CGFloat) itemMaxXInContentViewAtIndex:(NSInteger) index;

- (NSInteger) minimumIndex;
- (NSInteger) maximumIndex;

- (NSInteger) validIndexAt:(NSInteger) index;
- (BOOL) isValidIndex:(NSInteger) index;

- (NSInteger) frontIndex:(NSInteger) theIndex another:(NSInteger) otherIndex;
- (NSInteger) backIndex:(NSInteger) theIndex another:(NSInteger) otherIndex;


- (CGFloat) minimunOffset;
- (CGFloat) maximumOffset;
- (CGFloat) validOffsetAt:(CGFloat) offSet;
@end
