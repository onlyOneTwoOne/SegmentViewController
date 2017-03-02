//
//  LTSegmentedViewController.h
//  LTSegmentedViewController
//
//  Created by 胡胜武 on 15/10/10.
//  Copyright © 2015年 hsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSegmentedViewProtocol.h"
#import "LTPageViewController.h"

@class LTSegmentedViewController;
@protocol LTSegmentedViewControllerDataSource <NSObject>

- (UIViewController*) segmentedViewController:(LTSegmentedViewController*) segmentedViewController viewControllerAtIndex:(NSInteger) index;
- (NSInteger) segmentedViewController:(LTSegmentedViewController*) segmentedViewController indexAtViewController:(UIViewController*) viewController;

@end

@protocol LTSegmentedViewControllerDelegate <NSObject>

@optional
- (void) segmentedViewController:(LTSegmentedViewController*) segmentedViewController didTransitionToViewController:(UIViewController*) viewController transitionMode:(LTPageViewControllerTransitionMode) transitionMode;

@end

@interface LTSegmentedViewController : UIViewController
@property (nonatomic, weak) id<LTSegmentedViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<LTSegmentedViewControllerDelegate> delegate;
@property (nonatomic, assign) CGFloat segmentViewHeight;/**< default 44.f*/
@property (nonatomic, assign, getter=isEmbedSegmentedView) BOOL embedSegmentedView;/**< 是否将segmentedView嵌入到LTSegmentedViewController.view中, default YES*/
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, weak, readonly) UIViewController *currentViewController;
/**
 *  跳转至指定页
 *
 *  @param pageIndex pageIndex
 */
- (void) jumpToPage:(NSInteger) pageIndex;
/**
 *  解决ContentScrollView的滑动手势与其他手势的冲突(eg.UINavigationController的右滑返回手势)
 */
- (void) fixContentScrollGestureConflictWith:(UIGestureRecognizer*) otherGestureRecognizer;
/**
 *  dataSource不为nil
 */
- (instancetype) initWithSegmentedView:(UIView<LTSegmentedViewProtocol>*) segmentedView dataSource:(id<LTSegmentedViewControllerDataSource>) dataSource initialSelectedIndex:(NSInteger) initialSelectedIndex NS_DESIGNATED_INITIALIZER;
- (instancetype) initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
/**
 *  dataSource不为nil
 */
- (instancetype) initWithDataSource:(id<LTSegmentedViewControllerDataSource>) dataSource;
- (instancetype) initWithSegmentedView:(UIView<LTSegmentedViewProtocol>*) segmentedView dataSource:(id<LTSegmentedViewControllerDataSource>) dataSource;

- (instancetype) init  __attribute__((unavailable("Invoke the designated initalizer")));
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("Invoke the designated initalizer")));
@end
