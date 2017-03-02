//
//  LTSegmentedView.h
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 16/4/27.
//  Copyright © 2016年 Formax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSegmentedViewProtocol.h"
#import "LTDataDefine.h"
@interface LTSegmentedView : UIView<LTSegmentedViewProtocol>
//{layout
/**
 *  default: LTSegmentedViewDistributionFillEqually
 *
 *  当distribution为FillEqually时，item的宽度由`numberOfItemsPerScreen`决定，且会忽略`spacing`参数
 *
 *  当distribution为EqualSpacing时，item的宽度由`- (CGFloat)segmentedView:(UIView*) segmentedView itemWidthForItem:(UIView<LTSegmentedViewItemProtocol>*) item`或`- (CGSize)intrinsicContentSize`决定，如果两个都没有实现，item的宽度将被设置为contentView的宽度
 */
@property (nonatomic, assign) LTSegmentedViewDistribution distribution;
@property (nonatomic, assign) CGFloat numberOfItemsPerScreen;///< default 4，当distribution为EqualSpacing将忽略
@property (nonatomic, assign) CGFloat spacing;///< default 15，当distribute为FillEqually将忽略
//}

@property (nonatomic, copy, readonly) NSArray<__kindof UIView*> *items;
@property (nonatomic, strong) UICollectionView *contentView;
@property (nonatomic, assign) NSInteger selectedIndex;

//{edge mask layer
@property (nonatomic, assign, getter=isNeedDisplayEdgeMask) BOOL needDisplayEdgeMask;///< 是否需要展示边缘的遮罩层, default NO
@property (nonatomic, strong) UIColor *edgeMaskLayerColor;///< default whiteColor
@property (nonatomic, assign) CGFloat edgeMaskLayerWidth;///< default 15
//}

//{items operation
- (instancetype)initWithItems:(NSArray<__kindof UIView *>*) items;
- (void)insertItem:(UIView *)item atIndex:(NSUInteger) index;
- (void)removeItemAtIndex:(NSUInteger) index;
- (void)replaceItemsAtItems:(NSArray<__kindof UIView*> *)items;
- (void)reloadItems;
//}
@end
