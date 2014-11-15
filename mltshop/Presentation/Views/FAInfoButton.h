//
//  FAInfoButton.h
//  bitmedia
//
//  Created by meng qian on 14-3-3.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAInfoButton : UIButton

@property (nonatomic, strong) NSString *iconString;
@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, strong) UIFont *titleColor;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *subTitleString;

- (void)setIcon:(NSString *)icon andTitle:(NSString *)title andSubTitle:(NSString *)subTitle;

@end
