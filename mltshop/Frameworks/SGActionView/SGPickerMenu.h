//
//  SGPickerMenu.h
//  merchant
//
//  Created by mactive.meng on 10/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "SGBaseMenu.h"

@interface SGPickerMenu : SGBaseMenu

- (id)initWithTitle:(NSString *)title pickerMode:(UIDatePickerMode)pickerMode date:(NSDate *)theDate;

- (void)triggerSelectedAction:(void(^)(NSDate *))actionHandle;

@end
