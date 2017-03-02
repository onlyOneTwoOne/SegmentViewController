//
//  LTSegmentedView+private.m
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 16/4/27.
//  Copyright © 2016年 Formax. All rights reserved.
//

#import "LTSegmentedView+private.h"
#import "LTSegmentedViewItemProtocol.h"

@implementation LTSegmentedView (private)
- (UIView*) selectedItem{
    
    if ([self isValidIndex:self.selectedIndex]) {
        
        return self.items[self.selectedIndex];
    }
    
    return nil;
}

- (UIView*) itemOfIndex:(NSInteger) index{
    
    if ([self isValidIndex:index]) {
        
        return self.items[index];
    }
    
    return nil;
}

- (CGFloat) itemWidthAtIndex:(NSInteger)index{
    
    switch (self.distribution) {
        case LTSegmentedViewDistributionFillEqually:
        {
            if (self.numberOfItemsPerScreen == 0) {
                
                return CGRectGetWidth(self.contentView.frame);
            }else{
                
                return (CGRectGetWidth(self.contentView.frame) / self.numberOfItemsPerScreen);
            }
        }
            break;
            
        case LTSegmentedViewDistributionEqualSpacing:
        {
            UIView *item = [self itemOfIndex:index];
            
            CGFloat width = CGRectGetWidth(self.contentView.frame);
            if (item) {
                
                if ([(UIView<LTSegmentedViewItemProtocol>*)item respondsToSelector:@selector(segmentedView:itemWidthForItem:)]) {
                    
                    width = [(UIView<LTSegmentedViewItemProtocol>*)item segmentedView:self itemWidthForItem:(UIView<LTSegmentedViewItemProtocol>*)item];
                }else if (item.intrinsicContentSize.width != UIViewNoIntrinsicMetric){
                    
                    width = item.intrinsicContentSize.width;
                }
            }
            return width;
        }
            break;
    }
}

- (CGFloat) itemOriginXInContentViewAtIndex:(NSInteger)index{
    
    if (index < self.minimumIndex) {
        
        return [self itemOriginXInContentViewAtIndex:self.minimumIndex];
    }else if (index > self.maximumIndex) {
        
        return [self itemOriginXInContentViewAtIndex:self.maximumIndex];
    }else{
        
        switch (self.distribution) {
            case LTSegmentedViewDistributionFillEqually:
            {
                return index * [self itemWidthAtIndex:index];
            }
                break;
                
            case LTSegmentedViewDistributionEqualSpacing:
            {
                CGFloat spacing = self.spacing * (index + 1);
                CGFloat itemWidth = 0;
                for (NSInteger i = self.minimumIndex; i < index; i++) {
                    
                    itemWidth += [self itemWidthAtIndex:i];
                }
                
                return itemWidth + spacing;
            }
                break;
        }
    }
}

- (CGFloat) itemMinXInContentViewAtIndex:(NSInteger) index{
    
    if (index < self.minimumIndex) {
        
        return [self itemMinXInContentViewAtIndex:self.minimumIndex];
    }else if (index > self.maximumIndex) {
        
        return [self itemMinXInContentViewAtIndex:self.maximumIndex];
    }else{
        
        switch (self.distribution) {
            case LTSegmentedViewDistributionFillEqually:
            {
                return index * [self itemWidthAtIndex:index];
            }
                break;
                
            case LTSegmentedViewDistributionEqualSpacing:
            {
                CGFloat spacing = self.spacing * index;
                CGFloat itemWidth = 0;
                for (NSInteger i = self.minimumIndex; i < index; i++) {
                    
                    itemWidth += [self itemWidthAtIndex:i];
                }
                
                return itemWidth + spacing;
            }
                break;
        }
    }
}

- (CGFloat) itemMaxXInContentViewAtIndex:(NSInteger) index{
    
    if (index < self.minimumIndex) {
        
        return [self itemMaxXInContentViewAtIndex:self.minimumIndex];
    }else if (index > self.maximumIndex) {
        
        return [self itemMaxXInContentViewAtIndex:self.maximumIndex];
    }else{
        
        switch (self.distribution) {
            case LTSegmentedViewDistributionFillEqually:
            {
                return (index + 1) * [self itemWidthAtIndex:index];
            }
                break;
                
            case LTSegmentedViewDistributionEqualSpacing:
            {
                CGFloat spacing = self.spacing * (index + 2);
                CGFloat itemWidth = 0;
                for (NSInteger i = self.minimumIndex; i <= index; i++) {
                    
                    itemWidth += [self itemWidthAtIndex:i];
                }
                
                return itemWidth + spacing;
            }
                break;
        }
    }
}

- (NSInteger) minimumIndex{
    
    return 0;
}

- (NSInteger) maximumIndex{
    
    if (self.items.count == 0) return self.minimumIndex;
    
    return self.items.count - 1;
}

- (NSInteger) validIndexAt:(NSInteger) index{
    
    if (self.items.count == 0) return self.minimumIndex;
    
    if (index < self.minimumIndex) {
        
        index = self.minimumIndex;
    }else if (index > self.maximumIndex){
        
        index = self.maximumIndex;
    }
    
    return index;
}

- (BOOL) isValidIndex:(NSInteger) index{
    
    if (self.items.count == 0) return NO;
    
    if (index < self.minimumIndex || index > self.maximumIndex) {
        
        return NO;
    }
    return YES;
}

- (NSInteger) frontIndex:(NSInteger) theIndex another:(NSInteger) otherIndex{
    
    NSInteger frontIndex = theIndex;
    if (frontIndex > otherIndex) {
        
        frontIndex = otherIndex;
    }
    
    return [self validIndexAt:frontIndex];
}

- (NSInteger) backIndex:(NSInteger) theIndex another:(NSInteger) otherIndex{
    
    NSInteger backIndex = theIndex;
    if (backIndex < otherIndex) {
        
        backIndex = otherIndex;
    }
    
    return [self validIndexAt:backIndex];
}

- (CGFloat) minimunOffset{
    
    return 0.f;
}

- (CGFloat) maximumOffset{
    
    return MAX(self.minimunOffset, self.contentView.contentSize.width - CGRectGetWidth(self.contentView.frame));
}

- (CGFloat) validOffsetAt:(CGFloat) offSet{
    
    if (offSet < self.minimunOffset) {
        
        offSet = self.minimunOffset;
    }else if (offSet > self.maximumOffset){
        
        offSet = self.maximumOffset;
    }
    
    return offSet;
}
@end
