//
//  SegmentDemoViewController.m
//  SegmentViewController
//
//  Created by 胡胜武 on 2017/3/2.
//  Copyright © 2017年 hsw. All rights reserved.
//

#import "SegmentDemoViewController.h"
#import "LTSegmentedViewController.h"
#import "LTUnderLineSegmentedView.h"
#import "FMNewsItem.h"
#import "ViewController.h"

@interface SegmentDemoViewController ()<LTSegmentedViewControllerDelegate,LTSegmentedViewControllerDataSource>
@property (nonatomic, strong) LTSegmentedViewController *containerViewController;/**< 容器VC*/
@property (nonatomic, strong) LTUnderLineSegmentedView *segmentedView;/**< 指示器*/
@property (nonatomic, strong) NSMutableArray *viewControllers;/**< 列表vc*/

@end

@implementation SegmentDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Demo";
    [self initViewController];
}

- (void)initViewController{
    
    NSArray *titleArr = @[
                          @"热门",
                          @"要闻",
                          @"体育",
                          @"资讯",
                          @"娱乐",
                          @"NBA",
                          @"彩票"
                          ];
    
    NSMutableArray *items = @[].mutableCopy;
    
    [titleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.viewControllers addObject:[self createNewsViewControllerAtTitle:obj]];
        [items addObject:[self createSegmentedItemAtTypeInfo:titleArr[idx] pageIndex:idx]];
    }];
    
    self.segmentedView = ({
        
        LTUnderLineSegmentedView *segmentedView = [[LTUnderLineSegmentedView alloc] initWithItems:[items copy]];
        segmentedView.underLineColor = [UIColor whiteColor];//UIColorRGB(0x00A0FF);
        segmentedView.underLineWidthFlexible = YES;
        segmentedView.backgroundColor = [UIColor redColor];
        segmentedView.numberOfItemsPerScreen = 4;
        segmentedView.needDisplayEdgeMask = YES;
        segmentedView.edgeMaskLayerColor = [UIColor whiteColor];
        segmentedView.edgeMaskLayerWidth = 20.f;
        segmentedView;
    });
    
    self.containerViewController = [[LTSegmentedViewController alloc] initWithSegmentedView:self.segmentedView dataSource:self];
    self.containerViewController.delegate = self;
    self.containerViewController.segmentViewHeight = 44.f;
    [self addChildViewController:self.containerViewController];
    [self.view addSubview:self.containerViewController.view];
    [self.containerViewController didMoveToParentViewController:self];
    
    self.containerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self.view addConstraint:leading];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [self.view addConstraint:trailing];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:top];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.containerViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint:bottom];
}

#pragma mark -Private Methods
- (UIViewController*) createNewsViewControllerAtTitle:(NSString *)title{
    ViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewControllerID"];
    viewController.title = title;
    return viewController;
    
}

- (FMNewsItem*) createSegmentedItemAtTypeInfo:(NSString*) navigation pageIndex:(NSInteger) pageIndex{
    
    FMNewsItem*(^createSegmentedItem)(NSString *title, NSInteger tag) = ^(NSString *title, NSInteger tag){
        
        FMNewsItem *item = (FMNewsItem*)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FMNewsItem class]) owner:nil options:nil] lastObject];
        item.textLabel.text = title;
        item.tag = tag;
        
        item.titleNormalColor = LTColorFromRGBHex(0xb1d3f6);
        item.titleSelectedColor = LTColorFromRGBHex(0xffffff);
        item.textLabel.font = [UIFont boldSystemFontOfSize:17.f];
        item.minimumScale = 1.f;
        item.maximumScale = 1.f;
        item.backgroundColor = [UIColor redColor];
        item.fmState = UIControlStateNormal;
        
        [item addTarget:self action:@selector(onClickNewsItem:) forControlEvents:UIControlEventTouchUpInside];
        return item;
    };
    
    return createSegmentedItem(navigation, pageIndex);
}

- (void) onClickNewsItem:(FMNewsItem*) item{
    
    [self.containerViewController jumpToPage:item.tag];
}

#pragma mark -Protocol
#pragma mark LTSegmentedViewControllerDataSource <NSObject>
- (UIViewController*) segmentedViewController:(LTSegmentedViewController*) segmentedViewController viewControllerAtIndex:(NSInteger) index{
    
    if (index >= 0 && index < self.viewControllers.count) {
        UIViewController *vc = self.viewControllers[index];
        return vc;
    }
    return nil;
}

- (NSInteger) segmentedViewController:(LTSegmentedViewController*) segmentedViewController indexAtViewController:(UIViewController*) viewController{
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    return (index == NSNotFound ? 0 : index);
}

#pragma mark LTSegmentedViewControllerDelegate <NSObject>
- (void) segmentedViewController:(LTSegmentedViewController*) segmentedViewController didTransitionToViewController:(UIViewController*) viewController transitionMode:(LTPageViewControllerTransitionMode)transitionMode{
    
}


#pragma mark -Accessor
- (NSMutableArray*) viewControllers{
    
    if (!_viewControllers) {
        
        _viewControllers = @[].mutableCopy;
    }
    
    return _viewControllers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
