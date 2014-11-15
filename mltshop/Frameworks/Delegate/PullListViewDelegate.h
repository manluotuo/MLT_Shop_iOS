//
//  PullListViewDelegate.h
//  bitmedia
//
//  Created by meng qian on 14-4-2.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PullListViewDelegate <NSObject>

@optional
- (void)setupDataSource;
- (void)recomendNewItems;
- (void)recomendOldItems;

//- (void)actionWithSignal:(NSString *)signal andString:(NSString *)string;

@end
