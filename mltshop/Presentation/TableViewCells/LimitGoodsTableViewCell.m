//
//  LimitGoodsTableViewCell.m
//  mltshop
//
//  Created by 小新 on 15/3/21.
//  Copyright (c) 2015年 manluotuo. All rights reserved.
//

#import "LimitGoodsTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "LimitModel.h"

@interface LimitGoodsTableViewCell()

/** 图片 */
@property (nonatomic, strong) UIImageView *iconImage;
/** 价格 */
@property (nonatomic, strong) UILabel *goodsPrice;
/** 商品名称 */
@property (nonatomic, strong) UILabel *goodsName;
/** 倒计时 */
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) NSTimer *timer;

@end
@implementation LimitGoodsTableViewCell {
    NSInteger day;
    NSInteger hour;
    NSInteger m;
    NSInteger s;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCellView];
    }
    return self;
}

- (void)initCellView {
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = TOTAL_WIDTH;
    CGFloat H = W;
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, W, H)];
    
    self.goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImage.height+H_20, W, H_20)];
    self.goodsPrice.textColor = REDCOLOR;
    [self.goodsPrice setFont:[UIFont boldSystemFontOfSize:14.0f]];
    self.goodsPrice.textAlignment = UIBaselineAdjustmentAlignCenters;
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodsPrice.y+self.goodsPrice.height, W, H_20)];
    [self.goodsName setFont:FONT_14];
    self.goodsName.textAlignment = UIBaselineAdjustmentAlignCenters;
    
    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(TOTAL_WIDTH-H_150-H_5, H-H_20, H_150, H_40)];
    self.timeLable.font = FONT_16;
    self.timeLable.textColor = WHITECOLOR;
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(self.timeLable.x-10, H-H_15, H_150+H_10, H_30)];
    [timeView setBackgroundColor:[UIColor grayColor]];
    
    
    [self addSubview:self.iconImage];
    [self addSubview:self.goodsPrice];
    [self addSubview:self.goodsName];
    [self addSubview:timeView];
    [self addSubview:self.timeLable];
    
}

- (void)setCellData:(LimitModel *)model {
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.img[@"goods"]]];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@元", model.promote_price];
    
    self.goodsName.text = model.goods_name;

    if (!self.timer) {
        NSInteger time = [model.promote_date_time integerValue];
        day = time/(60*60*24);
        hour = (time - (day*24*3600))/3600;
        m = (time - (day*24*3600) - (hour*3600))/60;
        s = (time - (day*24*3600) - (hour*3600) - (m*60));
        self.timeLable.text = [NSString stringWithFormat:@"%d天%d小时%d分%d秒", day, hour, m, s];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        self.timeLable.text = [NSString stringWithFormat:@"%d天%d小时%d分%d秒", day, hour, m, s];
    }
    
}

/** 定时器触发事件 */
- (void)timerClick {
    --s;
    if (s<0) {
        --m;
        s = 59;
    }
    if (m<0) {
        m = 59;
        --hour;
    }
    if (hour < 0) {
        hour = 23;
        --day;
    }
    self.timeLable.text = [NSString stringWithFormat:@"%d天%d小时%d分%d秒", day, hour, m, s];
    if (s == 0&&m==0&&hour==0&&hour==0) {
        self.timeLable.text = [NSString stringWithFormat:@"活动已结束"];
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
