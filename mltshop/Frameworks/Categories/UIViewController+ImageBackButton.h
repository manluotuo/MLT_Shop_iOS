//
//  UIViewController+ImageBackButton.h
//  bitmedia
//
//  Created by meng qian on 14-3-19.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ImageBackButton)

- (void)setUpImageBackButton;
- (void)setUpImageDownButton:(NSInteger)position;
- (void)setUpImageCloseButton;
- (void)navigationGreenStyle;
- (void)navigationGrayStyle;
@end
