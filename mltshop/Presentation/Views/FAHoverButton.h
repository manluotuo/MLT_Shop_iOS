//
//  FAHoverButton.h
//  bitmedia
//
//  Created by meng qian on 14-3-3.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAHoverButton : UIButton

@property (nonatomic, strong) NSString *iconString;
@property (nonatomic, strong) UIColor *iconColor;
@property (nonatomic, strong) UIFont *iconFont;
@property (nonatomic, strong) NSString *bubbleString;
@property (nonatomic, strong) NSString *signal;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
