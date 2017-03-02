//
//  LTSegmentedViewItemProtocol.h
//  LTSegmentedViewController
//
//  Created by hsw on 15/10/24.
//  Copyright © 2015年 hsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LTSegmentedViewItemProtocol <NSObject>
@optional//item selected event
- (void)segmentedView:(UIView*) segmentedView willSelectItem:(UIView<LTSegmentedViewItemProtocol>*) item percent:(CGFloat) percent;
- (void)segmentedView:(UIView*) segmentedView didSelectItem:(UIView<LTSegmentedViewItemProtocol>*) item;
- (void)segmentedView:(UIView*) segmentedView willDeselectItem:(UIView<LTSegmentedViewItemProtocol>*) item percent:(CGFloat) percent;
- (void)segmentedView:(UIView*) segmentedView didDeselectItem:(UIView<LTSegmentedViewItemProtocol>*) item;

@optional//item size
- (CGFloat)segmentedView:(UIView*) segmentedView itemWidthForItem:(UIView<LTSegmentedViewItemProtocol>*) item;
@end

@protocol LTUnderLineSegmentedViewProtocol <LTSegmentedViewItemProtocol>

@optional
- (CGFloat)segmentedView:(UIView*) segmentedView underLineOriginXInItem:(UIView<LTUnderLineSegmentedViewProtocol>*) item;
- (CGFloat)segmentedView:(UIView*) segmentedView underLineWidthForItem:(UIView<LTUnderLineSegmentedViewProtocol>*) item;
@end
