//
//  AppDelegate.h
//  mltshop
//
//  Created by mactive.meng on 12/11/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Me.h"
#import "HostViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Me *me;
@property(nonatomic, assign)NSObject<PassValueDelegate> *passDelegate;
@property(nonatomic, strong)HostViewController *centerViewController;

- (NSURL *)applicationDocumentsDirectory;


@end

