//
//  LTSegmentedBaseView.m
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 16/4/27.
//  Copyright © 2016年 Formax. All rights reserved.
//

#import "LTSegmentedView.h"
#import "LTSegmentedViewItemProtocol.h"
#import "LTSegmentedView+private.h"

static CGFloat const kLTSegmentedViewEdgeMaskLayerDefaultWidth = 15;

@interface LTSegmentedView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray<__kindof UIView*> *items;
@property (nonatomic, strong) NSMutableArray <__kindof UIView*> *p_mItems;

@property (nonatomic, strong) CAGradientLayer *leftMaskLayer;
@property (nonatomic, strong) CAGradientLayer *rightMaskLayer;
@end

@implementation LTSegmentedView

- (instancetype)initWithItems:(NSArray<__kindof UIView *> *)items{
    
    self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50.f)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _distribution = LTSegmentedViewDistributionFillEqually;
        _numberOfItemsPerScreen = 4;
        _spacing = 15;
        
        _items = items.copy;
        _p_mItems = items.mutableCopy;
        _contentView = ({
        
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.minimumLineSpacing = 0;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
            collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.scrollsToTop = NO;
            [self addSubview:collectionView];
            
            collectionView;
        });
        
        _edgeMaskLayerColor = [UIColor whiteColor];
        _edgeMaskLayerWidth = kLTSegmentedViewEdgeMaskLayerDefaultWidth;
        _leftMaskLayer = ({
            
            CAGradientLayer *layer = [CAGradientLayer layer];
            layer.frame = CGRectMake(0, 0, _edgeMaskLayerWidth, CGRectGetHeight(self.bounds));
            layer.startPoint = CGPointMake(0, 0.5);
            layer.endPoint = CGPointMake(1, 0.5);
            layer.hidden = YES;
            [self.layer addSublayer:layer];
            
            layer;
        });
        
        _rightMaskLayer = ({
            
            CAGradientLayer *layer = [CAGradientLayer layer];
            layer.frame = CGRectMake(CGRectGetWidth(self.bounds) - _edgeMaskLayerWidth, 0, _edgeMaskLayerWidth+1, CGRectGetHeight(self.bounds));//width = _edgeMaskLayerWidth + 1解决右边maskLayer与contentView存在间隙的问题
            layer.startPoint = CGPointMake(0, 0.5);
            layer.endPoint = CGPointMake(1, 0.5);
            layer.hidden = YES;
            [self.layer addSublayer:layer];
            
            layer;
        });
        [self configureEdgeMaskLayer];
        
        [self addObserver:self forKeyPath:@"bounds" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        [self addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
    return self;
}

- (void)dealloc{
    
    [self removeObserver:self forKeyPath:@"bounds" context:nil];
    [self removeObserver:self forKeyPath:@"frame" context:nil];
}

#pragma mark -Override
- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.leftMaskLayer.frame = CGRectMake(0, 0, _edgeMaskLayerWidth, CGRectGetHeight(self.bounds));
    self.rightMaskLayer.frame = CGRectMake(CGRectGetWidth(self.bounds) - _edgeMaskLayerWidth, 0, _edgeMaskLayerWidth+1, CGRectGetHeight(self.bounds));
}

#pragma mark -KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"bounds"] || [keyPath isEqualToString:@"frame"]) {
        
        CGRect newRect = [change[@"new"] CGRectValue];
        CGRect oldRect = [change[@"old"] CGRectValue];
        if (!CGSizeEqualToSize(newRect.size, oldRect.size)) {
            
            [self layoutIfNeeded];
            [self reloadItems];
        }
    }
}

#pragma mark -Public Methods
- (void)insertItem:(UIView *)item atIndex:(NSUInteger) index{
    
    NSParameterAssert(item);
    NSParameterAssert(index <= self.p_mItems.count);
    if (item && index <= self.p_mItems.count) {
        
        [self.p_mItems insertObject:item atIndex:index];
        self.items = self.p_mItems.copy;
        [self reloadItems];
    }
}

- (void)removeItemAtIndex:(NSUInteger) index{
    
    NSParameterAssert(index < self.p_mItems.count);
    if (index < self.p_mItems.count) {
        
        [self.p_mItems removeObjectAtIndex:index];
        self.items = self.p_mItems.copy;
        [self reloadItems];
    }
}

- (void)replaceItemsAtItems:(NSArray<__kindof UIView*> *)items{

    self.p_mItems = items.mutableCopy;
    self.items = items;
    [self reloadItems];
}

- (void)reloadItems{
    
    [self.contentView reloadData];
    [self updateEdgeMaskLayerState];
    self.selectedIndex = self.selectedIndex;/*调整contentOffset*/
}

#pragma mark -Private Methods
- (void)adjustContentOffsetFrom:(NSInteger) fromIndex to:(NSInteger) curIndex{
    
    CGFloat curOffset = self.contentView.contentOffset.x;
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat fitOffset = curOffset;
    BOOL isNeedAdjust = NO;
    if (fromIndex > curIndex) {
        
        CGFloat preItemMinX = [self itemMinXInContentViewAtIndex:(curIndex - 1)];
        if ((preItemMinX < curOffset)) {
            
            isNeedAdjust = YES;
            fitOffset = preItemMinX;
        }
    }else if (fromIndex < curIndex){
        
        CGFloat lastItemMaxX = [self itemMaxXInContentViewAtIndex:(curIndex + 2)];
        if (lastItemMaxX > curOffset + width) {
            
            isNeedAdjust = YES;
            fitOffset = lastItemMaxX - width;
        }
    }
    
    if (!isNeedAdjust) {
        
        CGFloat lastItemMaxX = [self itemMaxXInContentViewAtIndex:(curIndex + 1)];
        if (lastItemMaxX > curOffset + width) {
            
            isNeedAdjust = YES;
            fitOffset = lastItemMaxX - width;
        }else{
            
            CGFloat itemMinX = [self itemMinXInContentViewAtIndex:curIndex];
            if (itemMinX < curOffset){
            
                isNeedAdjust = YES;
                fitOffset = itemMinX;
            }
        }
    }
    
    if (isNeedAdjust) {
        
        fitOffset = [self validOffsetAt:fitOffset];
        [self.contentView setContentOffset:CGPointMake(fitOffset, self.contentView.contentOffset.y) animated:YES];
    }
}

- (void)notifyItemSelectIndexWillChangeFrom:(NSInteger) preIndex to:(NSInteger) curIndex percent:(CGFloat) percent{
    
    if ((![self isValidIndex:curIndex]) || (preIndex == curIndex)) {
        
        return;
    }
    
    UIView *preItem = [self itemOfIndex:preIndex];
    UIView *curItem = [self itemOfIndex:curIndex];
    if (preItem && [preItem respondsToSelector:@selector(segmentedView:willDeselectItem:percent:)]) {
        
        CGFloat actualPercent = (preIndex > curIndex ? percent : (1 - percent));
        [(UIView<LTSegmentedViewItemProtocol>*)preItem segmentedView:self willDeselectItem:(UIView<LTSegmentedViewItemProtocol> *)preItem percent:actualPercent];
    }
    
    if (curItem && [curItem respondsToSelector:@selector(segmentedView:willSelectItem:percent:)]) {
        
        CGFloat actualPercent = (preIndex < curIndex ? percent : (1 - percent));
        [(UIView<LTSegmentedViewItemProtocol>*)curItem segmentedView:self willSelectItem:(UIView<LTSegmentedViewItemProtocol> *)curItem percent:actualPercent];
    }
}

- (void)notifyItemSelectIndexDidChangedFrom:(NSInteger) preIndex to:(NSInteger) curIndex{
    
    UIView *preItem = [self itemOfIndex:preIndex];
    UIView *curItem = [self itemOfIndex:curIndex];
    if (preItem && [preItem respondsToSelector:@selector(segmentedView:didDeselectItem:)]) {
        
        [(UIView<LTSegmentedViewItemProtocol>*)preItem segmentedView:self didDeselectItem:(UIView<LTSegmentedViewItemProtocol>*)preItem];
    }
    
    if (curItem && [curItem respondsToSelector:@selector(segmentedView:didSelectItem:)]) {
        
        [(UIView<LTSegmentedViewItemProtocol>*)curItem segmentedView:self didSelectItem:(UIView<LTSegmentedViewItemProtocol>*)curItem];
    }
}

- (void)updateEdgeMaskLayerState{
    
    if (!self.isNeedDisplayEdgeMask) return;
    if (!self.edgeMaskLayerColor) return;
    
    CGFloat contentOffsetX = self.contentView.contentOffset.x;
    self.leftMaskLayer.hidden = !(contentOffsetX > self.minimunOffset);
    self.rightMaskLayer.hidden = !(contentOffsetX < self.maximumOffset);
}

- (void)configureEdgeMaskLayer{
    
    if (!self.edgeMaskLayerColor) return;
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:50];
    for (NSUInteger i = 0; i < 50; i++) {
        
        [colors addObject:(id)[self.edgeMaskLayerColor colorWithAlphaComponent:i / 50.f].CGColor];
    }
    
    self.leftMaskLayer.colors = [colors reverseObjectEnumerator].allObjects;
    self.rightMaskLayer.colors = colors.copy;
}

#pragma mark -Protocol
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *item = self.items[indexPath.row];
    item.frame = cell.contentView.bounds;
    item.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:item];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = [self itemWidthAtIndex:indexPath.row];
    CGFloat height = CGRectGetHeight(collectionView.frame);
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    switch (self.distribution) {
        case LTSegmentedViewDistributionFillEqually:
        {
            return 0.f;
        }
            break;
            
        case LTSegmentedViewDistributionEqualSpacing:
        {
            return self.spacing;
        }
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    switch (self.distribution) {
        case LTSegmentedViewDistributionFillEqually:
        {
            return UIEdgeInsetsZero;
        }
            break;
            
        case LTSegmentedViewDistributionEqualSpacing:
        {
            return UIEdgeInsetsMake(0, self.spacing, 0, self.spacing);
        }
            break;
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self updateEdgeMaskLayerState];
}

#pragma LTSegmentedViewProtocol <NSObject>
- (void)segmentedView:(UIView<LTSegmentedViewProtocol>*) segmentedView didSelectedItemAtIndex:(NSInteger) index{
    
    if (index != NSNotFound) {
        
        self.selectedIndex = index;
    }
}

- (void)segmentedView:(UIView<LTSegmentedViewProtocol>*) segmentedView willScrollToItemAtIndex:(NSInteger) index percent:(CGFloat) percent{
    
    if (index != self.selectedIndex) {
        
        [self notifyItemSelectIndexWillChangeFrom:self.selectedIndex to:index percent:percent];
    }
}

#pragma mark -Getter
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    
    selectedIndex = [self validIndexAt:selectedIndex];
    
    NSInteger preIndex = _selectedIndex;
    _selectedIndex = selectedIndex;
    
    [self adjustContentOffsetFrom:preIndex to:selectedIndex];
    [self notifyItemSelectIndexDidChangedFrom:preIndex to:selectedIndex];
}

- (void)setNumberOfItemsPerScreen:(CGFloat)numberOfItemsPerScreen{
    
    _numberOfItemsPerScreen = numberOfItemsPerScreen;
    [self reloadItems];
}

- (NSMutableArray*)p_mItems{
    
    if (!_p_mItems) {
        
        _p_mItems = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _p_mItems;
}

- (void)setEdgeMaskLayerColor:(UIColor *)edgeMaskLayerColor{
    
    if (_edgeMaskLayerColor != edgeMaskLayerColor) {
        
        _edgeMaskLayerColor = edgeMaskLayerColor;
        
        [self configureEdgeMaskLayer];
    }
}

- (void)setEdgeMaskLayerWidth:(CGFloat)edgeMaskLayerWidth{
    
    if (_edgeMaskLayerWidth != edgeMaskLayerWidth) {
        
        _edgeMaskLayerWidth = edgeMaskLayerWidth;
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}
@end
