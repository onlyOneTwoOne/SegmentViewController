//
//  LTUnderLineSegmentedView.m
//  LTSegmentedViewController
//
//  Created by hsw on 15/10/11.
//  Copyright © 2015年 hsw. All rights reserved.
//

#import "LTUnderLineSegmentedView.h"
#import "LTSegmentedViewItemProtocol.h"
#import "LTSegmentedView+private.h"

@interface LTUnderLineSegmentedView ()
@property (nonatomic, strong) UIView *underLineView;
@end

@implementation LTUnderLineSegmentedView
#pragma mark -Life Cycle
- (instancetype)initWithItems:(NSArray<__kindof UIView *> *)items {

    self = [super initWithItems:items];
    if (self) {

        _underLineColor = [UIColor colorWithRed:0.f green:(160.f / 255.f) blue:(255.f / 255.f) alpha:1.f];
        _underLineheight = 2;
        _underLineBottomSpace = 1;

        UIView *underLineView = self.underLineView;
        [self.contentView addSubview:underLineView];
        [self adjustUnderLinePositionWithAnimation:NO];
    }
    return self;
}

#pragma mark -Public Methods
- (void)reloadItems {

    [super reloadItems];

    [self adjustUnderLinePositionWithAnimation:NO];
}

#pragma mark -Private Methods
- (void)adjustUnderLinePositionWithAnimation:(BOOL)isAnimation {

    if (isAnimation) {

        [UIView animateWithDuration:0.3
                              delay:0.f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{

                             self.underLineView.frame = [self getUnderLineFrameAtIndex:self.selectedIndex];
                         }
                         completion:nil];
    } else {

        self.underLineView.frame = [self getUnderLineFrameAtIndex:self.selectedIndex];
        ;
    }
}

- (CGRect)getUnderLineFrameAtIndex:(NSInteger)index {

    if (![self isValidIndex:index]) {

        return self.underLineView.frame;
    }

    CGFloat originX = 0;
    CGFloat originY = CGRectGetHeight(self.frame) - self.underLineBottomSpace - self.underLineheight;
    CGFloat underLineW = [self getUnderLineWidthAtIndex:index];

    UIView *item = [self itemOfIndex:index];
    if (self.underLineWidthFlexible && [item respondsToSelector:@selector(segmentedView:underLineOriginXInItem:)]) {

        CGFloat x = [(UIView<LTUnderLineSegmentedViewProtocol> *) item segmentedView:self underLineOriginXInItem:(UIView<LTUnderLineSegmentedViewProtocol> *) item];
        CGRect frame = CGRectMake(x, 0, 0, 0);
        frame = [self convertRect:frame fromView:item];

        originX = frame.origin.x;
    } else {

        CGFloat underLineCenterX = [self itemOriginXInContentViewAtIndex:index] + [self itemWidthAtIndex:index] * 0.5f;
        originX = underLineCenterX - underLineW / 2.f;
    }

    return CGRectMake(originX, originY, underLineW, self.underLineheight);
}

- (CGFloat)getUnderLineWidthAtIndex:(NSInteger)index {

    CGFloat underLineW = CGRectGetWidth(self.underLineView.frame);
    if (![self isValidIndex:index]) {

        return underLineW;
    }

    UIView *item = [self itemOfIndex:index];
    if (!self.underLineWidthFlexible || (![item respondsToSelector:@selector(segmentedView:underLineWidthForItem:)])) {

        underLineW = [self itemWidthAtIndex:index] - self.underLineWidthOffset;
    } else {

        CGFloat width = 0;
        if ([item respondsToSelector:@selector(segmentedView:underLineWidthForItem:)]) {

            width = [(UIView<LTUnderLineSegmentedViewProtocol> *) item segmentedView:self underLineWidthForItem:(UIView<LTUnderLineSegmentedViewProtocol> *) item];
        }

        if (width > 0) {

            underLineW = width;
        } else {

            underLineW = [self itemWidthAtIndex:index] - self.underLineWidthOffset;
        }
    }
    return underLineW;
}

#pragma mark -Protocol
#pragma mark LTSegmentedViewProtocol <NSObject>
- (void)segmentedView:(UIView<LTSegmentedViewProtocol> *)segmentedView didSelectedItemAtIndex:(NSInteger)index {

    [super segmentedView:segmentedView didSelectedItemAtIndex:index];

    [self adjustUnderLinePositionWithAnimation:YES];
}

- (void)segmentedView:(UIView<LTSegmentedViewProtocol> *)segmentedView willScrollToItemAtIndex:(NSInteger)index percent:(CGFloat)percent {

    [super segmentedView:segmentedView willScrollToItemAtIndex:index percent:percent];

    if (index != self.selectedIndex && [self isValidIndex:index]) {

        CGRect willSelectedFrame = [self getUnderLineFrameAtIndex:index];
        CGRect selectedFrame = [self getUnderLineFrameAtIndex:self.selectedIndex];
        CGFloat acturalPercent = (self.selectedIndex > index ? (1 - percent) : percent);

        CGFloat x = (CGRectGetMinX(willSelectedFrame) - CGRectGetMinX(selectedFrame)) * acturalPercent + CGRectGetMinX(selectedFrame);
        CGFloat y = (CGRectGetMinY(willSelectedFrame) - CGRectGetMinY(selectedFrame)) * acturalPercent + CGRectGetMinY(selectedFrame);
        CGFloat w = (CGRectGetWidth(willSelectedFrame) - CGRectGetWidth(selectedFrame)) * acturalPercent + CGRectGetWidth(selectedFrame);
        CGFloat h = (CGRectGetHeight(willSelectedFrame) - CGRectGetHeight(selectedFrame)) * acturalPercent + CGRectGetHeight(selectedFrame);

        self.underLineView.frame = CGRectMake(x, y, w, h);
    } else {

        self.underLineView.frame = [self getUnderLineFrameAtIndex:self.selectedIndex];
    }
}

#pragma mark -Accessor
- (UIView *)underLineView {

    if (!_underLineView) {

        _underLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _underLineView.backgroundColor = self.underLineColor;
    }

    return _underLineView;
}

- (void)setUnderLineheight:(CGFloat)underLineheight {

    _underLineheight = underLineheight;
    [self adjustUnderLinePositionWithAnimation:NO];
}

- (void)setUnderLineColor:(UIColor *)underLineColor {

    if (_underLineColor != underLineColor) {

        self.underLineView.backgroundColor = underLineColor;
        _underLineColor = underLineColor;
    }
}

- (void)setUnderLineBottomSpace:(CGFloat)underLineBottomSpace {

    _underLineBottomSpace = underLineBottomSpace;
    [self adjustUnderLinePositionWithAnimation:NO];
}

- (void)setUnderLineWidthFlexible:(BOOL)underLineWidthFlexible {

    _underLineWidthFlexible = underLineWidthFlexible;
    [self adjustUnderLinePositionWithAnimation:NO];
}

- (void)setUnderLineWidthOffset:(CGFloat)underLineWidthOffset {

    _underLineWidthOffset = underLineWidthOffset;
    [self adjustUnderLinePositionWithAnimation:NO];
}

- (void)setSpacing:(CGFloat)spacing {

    [super setSpacing:spacing];

    [self adjustUnderLinePositionWithAnimation:NO];
}

- (void)setDistribution:(LTSegmentedViewDistribution)distribution {

    [super setDistribution:distribution];

    [self adjustUnderLinePositionWithAnimation:NO];
}
@end
