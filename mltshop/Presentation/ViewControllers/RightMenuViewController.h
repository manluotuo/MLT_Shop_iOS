//
//  RightMenuViewController.h
//  bitmedia
//
//  Created by meng qian on 14-1-20.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "MMViewController.h"
#import "PassValueDelegate.h"
@interface RightMenuViewController : MMViewController
@property(nonatomic, assign) NSObject<PassValueDelegate> *passDelegateForDetailVC;
- (void)changeVehicleCloudStatus:(NSInteger)vehicleCloudStatus;
@end
