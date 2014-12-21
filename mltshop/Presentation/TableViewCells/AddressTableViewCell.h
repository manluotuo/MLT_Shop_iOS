//
//  AddressTableViewCell.h
//  mltshop
//
//  Created by mactive.meng on 21/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface AddressTableViewCell : UITableViewCell

- (void)setNewData:(AddressModel *)_newData;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
