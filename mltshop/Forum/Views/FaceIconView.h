//
//  FaceIconView.h
//  NSStringEmojize
//
//  Created by 小新 on 15/4/11.
//  Copyright (c) 2015年 DIY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceIconDelegate

-(void)selectedFacialView:(NSString*)str;

@end

@interface FaceIconView : UIView

- (void)initView;

@property(nonatomic,assign)id<FaceIconDelegate>delegate;

@end
