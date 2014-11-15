//
//  ScrollCellUIView.h
//  tyresize
//
//  Created by meng qian on 13-8-30.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollCellUIView : UIView

@property(strong, nonatomic)NSString *titleString;
@property(strong, nonatomic)NSString *descString;
@property(strong, nonatomic)UIImage *bgImage;
@property(strong, nonatomic)NSString *imageUrl;
@property(strong, nonatomic)UIImageView *bgImageView;

@end
