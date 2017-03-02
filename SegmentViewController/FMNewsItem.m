//
//  FMNewsItem.m
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 15/11/11.
//  Copyright © 2015年 Formax. All rights reserved.
//

#import "FMNewsItem.h"
#import "LTSegmentedViewItemProtocol.h"

@interface FMNewsItem ()
@property (nonatomic, assign) CGFloat percent;
@end

@implementation FMNewsItem
- (void) awakeFromNib{
    
    self.fmState = UIControlStateNormal;
    self.minimumScale = 0.7f;
    self.maximumScale = 1.f;
    
    self.bubbleLabel.hidden = YES;
    self.bubbleLabel.backgroundColor = [UIColor redColor];
    [super awakeFromNib];
}

#pragma mark LTSegmentedViewItemProtocol
- (void) segmentedView:(UIView*) segmentedView willSelectItem:(UIView<LTSegmentedViewItemProtocol>*) item percent:(CGFloat) percent{
    
    self.percent = percent;
}

- (void) segmentedView:(UIView*) segmentedView didSelectItem:(UIView<LTSegmentedViewItemProtocol>*) item{
    
    if (!(ABS(self.minimumScale - self.maximumScale) < (CGFLOAT_IS_DOUBLE ? DBL_EPSILON : FLT_EPSILON) && ABS(self.percent - 1.f) < (CGFLOAT_IS_DOUBLE ? DBL_EPSILON : FLT_EPSILON))) {
        
        [UIView animateWithDuration:0.3 delay:0.f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.fmState = UIControlStateSelected;
        } completion:nil];
    }else{
        
        self.fmState = UIControlStateSelected;
    }
}

- (void) segmentedView:(UIView*) segmentedView willDeselectItem:(UIView<LTSegmentedViewItemProtocol>*) item percent:(CGFloat) percent{
    
    self.percent = percent;
}

- (void) segmentedView:(UIView*) segmentedView didDeselectItem:(UIView<LTSegmentedViewItemProtocol>*) item{
    
    if (!(ABS(self.minimumScale - self.maximumScale) < (CGFLOAT_IS_DOUBLE ? DBL_EPSILON : FLT_EPSILON) && ABS(self.percent) < (CGFLOAT_IS_DOUBLE ? DBL_EPSILON : FLT_EPSILON))) {
        
        [UIView animateWithDuration:0.3 delay:0.f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.fmState = UIControlStateNormal;
        } completion:nil];
    }else{
        
        self.fmState = UIControlStateNormal;
    }
}

- (CGFloat)segmentedView:(UIView*) segmentedView underLineWidthForItem:(UIView<LTUnderLineSegmentedViewProtocol>*) item{
    
    return self.textLabel.intrinsicContentSize.width + self.contentInsets.width;
}

#pragma mark -Accessor
- (void) setFmState:(UIControlState)fmState{
    
    _fmState = fmState;
    self.percent = (fmState == UIControlStateNormal ? 0 : 1);
}

- (void)setPercent:(CGFloat)percent{
    
    CGFloat scale = self.minimumScale + (self.maximumScale - self.minimumScale) * percent;
    self.textLabel.layer.affineTransform = CGAffineTransformMakeScale(scale, scale);
    self.textLabel.textColor = LTColorToUIColor(LTGradualColor(self.titleNormalColor, self.titleSelectedColor, percent));
}

- (void)setBubbleText:(NSString *)bubbleText{
    
    _bubbleText = bubbleText;
    if (!bubbleText || bubbleText.length == 0) {
        
        self.bubbleLabel.hidden = YES;
    }else{
        
        self.bubbleLabel.hidden = NO;
        self.bubbleLabel.text = bubbleText;
    }
}
@end
