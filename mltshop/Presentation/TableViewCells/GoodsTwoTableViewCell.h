//
//  GoodsTwoTableViewCell.h
//  mltshop
//
//  Created by mactive.meng on 14/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface GoodsTwoTableViewCell : UITableViewCell

- (void)setNewData:(NSDictionary *)_newDataDict;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end


@interface GoodsHalfCell : UIView

- (void)setup:(GoodsModel *)theGoods;

@end

