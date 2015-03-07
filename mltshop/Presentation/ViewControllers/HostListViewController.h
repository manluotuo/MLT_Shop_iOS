//
//  HostListViewController.h
//  mltshop
//
//  Created by mactive.meng on 7/3/15.
//  Copyright (c) 2015 manluotuo. All rights reserved.
//

#import "CommonListViewController.h"

@interface HostListViewController : CommonListViewController

@property(nonatomic, strong)SearchModel *search;
@property(nonatomic, strong)NSNumber *categoryId;



- (void)setUpDownButton:(NSInteger)position;

@end
