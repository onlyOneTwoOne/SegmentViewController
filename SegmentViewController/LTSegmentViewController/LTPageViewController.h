//
//  LTPageViewController.h
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 15/9/14.
//  Copyright (c) 2015年 Formax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LTPageViewControllerScrollDirection) {
    LTPageViewControllerScrollDirectionLeft,
    LTPageViewControllerScrollDirectionRight,
};

typedef NS_ENUM(NSUInteger, LTPageViewControllerTransitionMode) {
    LTPageViewControllerTransitionModeInitial,
    LTPageViewControllerTransitionModeJump,
    LTPageViewControllerTransitionModeGestureDriven,
};

@class LTPageViewController;
@protocol  LTPageViewControllerDataSource<NSObject>

@required
- (UIViewController*) pageViewController:(LTPageViewController*) pageViewController viewControllerAtIndex:(NSInteger) index;
- (NSInteger) pageViewController:(LTPageViewController*) pageViewController indexAtViewController:(UIViewController*) viewController;
@end

@protocol LTPageViewControllerDelegate <NSObject>

@optional
- (void) pageViewController:(LTPageViewController *)pageViewController willTransitionToViewControllers:(NSArray/*<UIViewController *>*/ *)pendingViewControllers;
- (void) pageViewController:(LTPageViewController*) pageViewController didTransitionToViewController:(UIViewController*) viewController transitionMode:(LTPageViewControllerTransitionMode) transitionMode;
- (void) pageViewController:(LTPageViewController*) pageViewController currentIndex:(NSInteger) currentIndex scrollDirection:(LTPageViewControllerScrollDirection) direction didScrollToPercent:(CGFloat) percent;
@end

@interface LTPageViewController : UIViewController
@property (nonatomic, weak) id<LTPageViewControllerDataSource> dataSource; /**< dataSource*/
@property (nonatomic, weak) id<LTPageViewControllerDelegate> delegate; /**< delegate*/
@property (nonatomic, weak) UIViewController *currentViewController;
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;

- (instancetype)initWithInitialSelectedIndex:(NSInteger) initialSelectedIndex;
/**
 *  跳转至指定页
 *  当currentIndex和pageIndex相同时不会有任何动作
 *  @param pageIndex pageIndex
 */
- (void) jumpToPage:(NSInteger) pageIndex;

- (UIScrollView*) pageViewControllerContentScrollView;
@end
