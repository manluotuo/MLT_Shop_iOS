//
//  OrderTableViewCell.h
//  mltshop
//
//  Created by mactive.meng on 13/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKFlatButton.h"

@interface OrderTableViewCell : UITableViewCell

- (void)setNewData:(OrderModel *)_newData;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;
@property (nonatomic, strong)KKFlatButton *actionBtn;


@end
