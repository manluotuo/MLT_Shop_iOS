//
//  CartTableViewCell.h
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface CartTableViewCell : UITableViewCell

- (void)setNewData:(CartModel *)_newData;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
