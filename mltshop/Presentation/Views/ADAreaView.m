//
//  ADAreaView.m
//  mltshop
//
//  Created by mactive.meng on 9/12/14.
//  Copyright (c) 2014 manluotuo. All rights reserved.
//

#import "ADAreaView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Size.h"
@interface ADAreaView()

@property(nonatomic, strong)NSArray *items;

@end

@implementation ADAreaView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithData:(NSDictionary *)oneArea
{
    if (ArrayHasValue(oneArea[@"items"])) {
        self.items = oneArea[@"items"];
    }
    self.backgroundColor = WHITECOLOR;
    
    if ([oneArea[@"template"] isEqualToString:@"L1R2"]) {
        ADAreaOneHeightView *leftView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [leftView initWithItemData:self.items[0]];
        
        ADAreaHalfHeightView *rightView1 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [rightView1 initWithItemData:self.items[1] andPositon:@"top"];

        ADAreaHalfHeightView *rightView2 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [rightView2 initWithItemData:self.items[2] andPositon:@"bottom"];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, 1, AREA_FIX_HEIGHT)];
        lineView1.backgroundColor = GRAYEXLIGHTCOLOR;

        [self addSubview:leftView];
        [self addSubview:rightView1];
        [self addSubview:rightView2];
        [self addSubview:lineView1];
        
        
    }else if ([oneArea[@"template"] isEqualToString:@"L2R1"]){
        
        ADAreaOneHeightView *rightView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [rightView initWithItemData:self.items[2]];
        
        ADAreaHalfHeightView *leftView1 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [leftView1 initWithItemData:self.items[0] andPositon:@"top"];
        
        ADAreaHalfHeightView *leftView2 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(0, AREA_FIX_HEIGHT/2, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [leftView2 initWithItemData:self.items[1] andPositon:@"bottom"];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, 1, AREA_FIX_HEIGHT)];
        lineView1.backgroundColor = GRAYEXLIGHTCOLOR;
        
        [self addSubview:leftView1];
        [self addSubview:leftView2];
        [self addSubview:rightView];
        [self addSubview:lineView1];
        
        
    }else if ([oneArea[@"template"] isEqualToString:@"L1R1"]){
        ADAreaOneHeightView *leftView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [leftView initWithItemData:self.items[0]];
        

        ADAreaOneHeightView *rightView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [rightView initWithItemData:self.items[0]];

        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, 0, 1, AREA_FIX_HEIGHT)];
        lineView1.backgroundColor = GRAYEXLIGHTCOLOR;
        
        [self addSubview:leftView];
        [self addSubview:rightView];
        [self addSubview:lineView1];

        
    }else{
        // 同上
    }
}


@end



/**
 全高区域
 
 :param: voidinitWithItemData 数据
 */
@implementation ADAreaOneHeightView

-(void)initWithItemData:(NSDictionary *)item
{
    UIImageView *goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(H_20, H_10, H_120, H_120)];
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:item[@"img"]] placeholderImage:PLACEHOLDERIMAGE];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, H_130, TOTAL_WIDTH/2, H_20)];
    [titleLabel setText:item[@"name"]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [titleLabel setTextColor:GRAYCOLOR];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];

    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, H_130+H_20, TOTAL_WIDTH/2, H_14)];
    [priceLabel setText:[item[@"price"] stringByAppendingString:@"元"]];
    [priceLabel setFont:LITTLECUSTOMFONT];
    [priceLabel setTextColor:GRAYLIGHTCOLOR];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];

    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, 1)];
    lineView1.backgroundColor = GRAYEXLIGHTCOLOR;

    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, AREA_FIX_HEIGHT-1, TOTAL_WIDTH/2, 1)];
    lineView2.backgroundColor = GRAYEXLIGHTCOLOR;
    
    [self addSubview:goodsImg];
    [self addSubview:titleLabel];
    [self addSubview:priceLabel];
    [self addSubview:lineView1];
    [self addSubview:lineView2];
    
}


@end


/**
 半高区域
 
 :param: voidinitWithItemData 数据
 */
@implementation ADAreaHalfHeightView

- (void)initWithItemData:(NSDictionary *)item andPositon:(NSString *)position
{
    UIImageView *goodsImg = [[UIImageView alloc]initWithFrame:CGRectMake(H_8, H_8, H_60, H_60)];
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:item[@"img"]] placeholderImage:PLACEHOLDERIMAGE];
    
    CGSize titleSize = [(NSString *)item[@"name"] sizeWithWidth:H_70 andFont:FONT_11];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_80, H_16, H_80, titleSize.height)];
    [titleLabel setText:item[@"name"]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [titleLabel setTextColor:GRAYCOLOR];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    titleLabel.numberOfLines = 0;
    
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_80, H_16+titleSize.height, TOTAL_WIDTH/2, H_14)];
    [priceLabel setText:[item[@"price"] stringByAppendingString:@"元"]];
    [priceLabel setFont:TINYCUSTOMFONT];
    [priceLabel setTextColor:GRAYLIGHTCOLOR];
    [priceLabel setTextAlignment:NSTextAlignmentLeft];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH/2, 1)];
    lineView1.backgroundColor = GRAYEXLIGHTCOLOR;
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, AREA_FIX_HEIGHT/2-1, TOTAL_WIDTH/2, 1)];
    lineView2.backgroundColor = GRAYEXLIGHTCOLOR;
    
    [self addSubview:goodsImg];
    [self addSubview:titleLabel];
    [self addSubview:priceLabel];
    if ([position isEqualToString:@"top"]) {
        [self addSubview:lineView1];
    }
    [self addSubview:lineView2];
}

@end
