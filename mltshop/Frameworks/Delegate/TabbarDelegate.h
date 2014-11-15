//
//  TabbarDelegate.h
//  bitmedia
//
//  Created by meng qian on 14-3-4.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabbarDelegate <NSObject>

@optional

-(void)viewCommentActionDelegate;
-(void)commentActionDelegate;
-(void)shareActionDelegate;
-(void)moreActionDelegate;

-(void)postActionDelegate;
-(void)cancelActionDelegate;

@end
