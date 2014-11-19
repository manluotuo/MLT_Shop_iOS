//
//  ModelHelper.h
//  bitmedia
//
//  Created by meng qian on 13-12-31.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Me.h"
#import "PassValueDelegate.h"

@interface ModelHelper : NSObject

@property(nonatomic, assign)NSObject<PassValueDelegate> *modelHelperDelegateForLeftMenuVC;
@property(nonatomic, assign)NSObject<PassValueDelegate> *modelHelperDelegateForHostVC;
@property(nonatomic, assign)NSObject<PassValueDelegate> *modelHelperDelegateForSNSLoginVC;

+ (ModelHelper *)sharedHelper;


- (Me *)findOnlyMe;
- (void)updateMeWithJsonData:(id)json;
- (void)meLogoutWithBlock:(void (^)(BOOL exeStatus))block;




@end
