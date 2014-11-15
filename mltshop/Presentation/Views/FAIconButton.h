//
//  FAIconButton.h
//  bitmedia
//
//  Created by meng qian on 14-2-21.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAIconButton : UIButton

@property (nonatomic, strong) NSString *iconString;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, assign) BOOL isON;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)changeRightIcon;
- (void)changeCenterIcon;
- (void)setBorder:(BOOL)border;
- (void)changeLightStyle;
- (void)changeGreenLightStyle;

@end
