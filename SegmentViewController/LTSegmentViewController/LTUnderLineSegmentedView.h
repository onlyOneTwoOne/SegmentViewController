//
//  LTUnderLineSegmentedView.h
//  LTSegmentedViewController
//
//  Created by hsw on 15/10/11.
//  Copyright © 2015年 hsw. All rights reserved.
//

#import "LTSegmentedView.h"

@interface LTUnderLineSegmentedView : LTSegmentedView
//{underline style
@property (nonatomic, assign) CGFloat underLineheight;/**< 下划线高度，default 2*/
@property (nonatomic, strong) UIColor *underLineColor;/**< 下划线颜色，default [UIColor colorWithRed:0.f green:(160.f / 255.f) blue:(255.f / 255.f) alpha:1.f]*/
@property (nonatomic, assign) CGFloat underLineBottomSpace;/**< 下划线与底部的间隔, default 1*/
@property (nonatomic, assign) BOOL underLineWidthFlexible;/**< 下划线宽度是否根据内容变化，YES且item需要实现`LTUnderLineSegmentedViewProtocol`的方法， NO：固定与Item宽度一致*/
@property (nonatomic, assign) CGFloat underLineWidthOffset;/**< 如果underLineWidthFlexible为YES会忽略此属性，default 0*/
//}
@end
