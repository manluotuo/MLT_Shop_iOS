//
//  ForumProfileController.h
//  个人中心
//
//  Created by Col on 15/4/26.
//  Copyright (c) 2015年 colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumProfileController : UIViewController

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
