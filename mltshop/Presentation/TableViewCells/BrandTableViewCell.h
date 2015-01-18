//
//  BrandTableViewCell.h
//  mltshop
//
//  Created by mactive.meng on 18/1/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface BrandTableViewCell : UITableViewCell

- (void)setNewData:(BrandModel *)_newData;
@property (nonatomic, weak) id<PassValueDelegate> passDelegate;


@end
