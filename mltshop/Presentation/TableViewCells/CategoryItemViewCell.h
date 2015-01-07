//
//  CategoryItemViewCell.h
//  remote
//
//  Created by Mactive on 3/18/14.
//  Copyright (c) 2014 wukongtv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "PassValueDelegate.h"
@interface CategoryItemViewCell : UICollectionViewCell

- (void)setRowData:(CategoryModel *)_rowData;

@property (nonatomic, weak) id<PassValueDelegate> passDelegate;

@end
