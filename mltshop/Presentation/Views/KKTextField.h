//
//  KKTextField.h
//  merchant
//
//  Created by mactive.meng on 5/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKTextField : UITextField
@property(nonatomic, strong)NSString *iconString;
@property(nonatomic, assign)NSInteger textIndent;

- (void)showRightButton;

@end

