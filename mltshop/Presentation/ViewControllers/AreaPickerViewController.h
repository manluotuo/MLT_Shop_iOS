//
//  AreaPickerViewController.h
//  merchant
//
//  Created by mactive.meng on 12/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface AreaPickerViewController : KKViewController
@property(nonatomic,assign) NSObject<PassValueDelegate> *passDelegate;
-(void)showDoneButton;
@end
