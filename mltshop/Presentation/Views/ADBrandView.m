//
//  ADBrandView.m
//  mltshop
//
//  Created by mactive.meng on 9/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "ADBrandView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define PRELINE     3

@interface ADBrandView()
@property(nonatomic, strong)NSArray *dataSource;
@end

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
    self.dataSource = [[NSArray alloc]init];
    self.dataSource = listData;
    for (int i = 0; i < [listData count]; i++) {
        NSDictionary *brand  = listData[i];
        CGRect rect = [DataTrans calcRect:i preLine:PRELINE withRect:CGRectMake(0, 0, TOTAL_WIDTH/PRELINE, BRAND_FIX_HEIGHT)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:WHITECOLOR];
        [button setFrame:rect];
        button.tag = i;
        UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/PRELINE, BRAND_FIX_HEIGHT)];
        logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:[BASE_API stringByAppendingString:brand[@"logo"]]]
                         placeholderImage:PLACEHOLDERIMAGE];
        [button addSubview:logoImageView];
        


        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)sender
{
    NSDictionary *brand  = self.dataSource[sender.tag];
    [self.passDelegate passSignalValue:SIGNAL_MAIN_PAGE_TAPPED andData:brand[@"site_url"]];
}


@end
