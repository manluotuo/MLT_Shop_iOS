//
//  CheckOrderAddressCell.h
//  mltshop
//
//  Created by Col on 15/5/13.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
@interface CheckOrderAddressCell : UITableViewCell
- (void)setNewData:(AddressModel *)_newData;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
