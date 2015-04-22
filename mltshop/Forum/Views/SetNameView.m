//
//  SetNameView.m
//  mltshop
//
//  Created by 小新 on 15/4/20.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "SetNameView.h"

@interface SetNameView ()
/** 提示文字 */
@property (nonatomic, strong) UILabel *titleLable;
/** 输入昵称 */
@property (nonatomic, strong) UITextField *nameField;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 确认按钮 */
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation SetNameView

- (void)initView {
    /** 设置提示文字 */
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(H_0, H_0, self.width, H_20)];
    [self.titleLable setText:T(@"首次登陆请设置昵称")];
    [self.titleLable setFont:FONT_12];
    [self addSubview:self.titleLable];
    
    /** 设置textField */
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(H_10, H_25, self.width-H_20, H_20)];
    [self.nameField setFont:FONT_12];
    [self.nameField setPlaceholder:T(@"输入昵称")];
    [self addSubview:self.nameField];
    
    /** 设置按钮 */
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.cancelBtn setFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
}

@end
