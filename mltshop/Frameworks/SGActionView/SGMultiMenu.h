//
//  SGMultiMenu.h
//  merchant
//
//  Created by mactive.meng on 25/6/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "SGBaseMenu.h"

@interface SGMultiMenu : SGBaseMenu

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles;
//- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles;

@property (nonatomic, strong) NSMutableArray* selectedItems;

- (void)triggerSelectedAction:(void(^)(NSMutableArray *))actionHandle;


@end
