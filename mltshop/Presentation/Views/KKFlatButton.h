//
//  KKFlatButton.h
//  merchant
//
//  Created by mactive.meng on 5/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,KKFlatButtonStyle)
{
    KKFlatButtonStyleLight      = 0,
    KKFlatButtonStyleColored    = 1,
    KKFlatButtonStyleGray       = 2,
    KKFlatButtonStyleBordered       = 3
};

@interface KKFlatButton : UIButton

@property(nonatomic,assign)NSUInteger buttonStyle;

- (void)setTitleColor:(UIColor *)color andStyle:(KKFlatButtonStyle)style;

@end
