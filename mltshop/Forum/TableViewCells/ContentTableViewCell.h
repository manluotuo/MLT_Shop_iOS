//
//  ContentTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/4/18.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentModel;
@interface ContentTableViewCell : UITableViewCell

- (void)setNewData:(ContentModel *)data;

@end
