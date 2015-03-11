//
//  CommentTableViewCell.h
//  mltshop
//
//  Created by 小新 on 15/3/10.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell

- (void)setCellData:(CommentModel *)model;

- (CGFloat)setCellHeight;

@end
