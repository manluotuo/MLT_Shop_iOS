//
//  ListViewController.h
//  merchant
//
//  Created by mactive.meng on 13/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "CommonListViewController.h"

@interface ListViewController : CommonListViewController

@property(nonatomic, strong)SearchModel *search;
@property(nonatomic, strong)NSNumber *categoryId;



- (void)setUpDownButton:(NSInteger)position;

@end
