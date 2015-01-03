//
//  BonusTableViewCell.h
//  mltshop
//
//  Created by mactive.meng on 3/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
@interface BonusTableViewCell : UITableViewCell


- (void)setNewData:(BonusModel *)_newData;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end

