//
//  GoodsOneTableViewCell.h
//  mltshop
//
//  Created by mactive.meng on 14/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface GoodsOneTableViewCell : UITableViewCell

- (void)setNewData:(GoodsModel *)_newData;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
