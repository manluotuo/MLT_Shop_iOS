//
//  LMViewController.h
//  bitmedia
//
//  Created by meng qian on 14-2-21.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
@interface LMViewController : KKViewController

@property(nonatomic, assign) NSInteger leftMenuFunction;
@property(nonatomic, assign) NSObject<PassValueDelegate> *passDelegate;

- (void)doneAction;

@end
