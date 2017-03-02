//
//  FMNewsItem.h
//  FormaxCopyMaster
//
//  Created by 胡胜武 on 15/11/11.
//  Copyright © 2015年 Formax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTDataDefine.h"
@interface FMNewsItem : UIControl
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *bubbleLabel;

@property (nonatomic, assign) LTColor titleNormalColor;
@property (nonatomic, assign) LTColor titleSelectedColor;

@property (nonatomic, assign) CGFloat minimumScale;
@property (nonatomic, assign) CGFloat maximumScale;

@property (nonatomic, assign) UIControlState fmState;

@property (nonatomic, assign) CGSize contentInsets;

@property (nonatomic, strong) NSString *bubbleText;
@end
