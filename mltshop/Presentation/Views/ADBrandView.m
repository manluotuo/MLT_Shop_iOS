//
//  ADBrandView.m
//  mltshop
//
//  Created by mactive.meng on 9/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "ADBrandView.h"
#import <SDWebImage/UIButton+WebCache.h>

#define PRELINE     3

@implementation ADBrandView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithData:(NSArray *)listData
{
    for (int i = 0; i < [listData count]; i++) {
        NSDictionary *brand  = listData[i];
        CGRect rect = [DataTrans calcRect:i preLine:PRELINE withRect:CGRectMake(0, 0, TOTAL_WIDTH/PRELINE, BRAND_FIX_HEIGHT)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:rect];
        [button sd_setImageWithURL:[NSURL URLWithString:[BASE_API stringByAppendingString:brand[@"logo"]]]
                          forState:UIControlStateNormal
                  placeholderImage:PLACEHOLDERIMAGE];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    
}


@end
