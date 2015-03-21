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
@property(nonatomic, strong)NSString *title;

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
    CGFloat offsetY = 0.0f;
    if (StringHasValue(oneArea[@"title"])) {
        self.title = oneArea[@"title"];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_15, 0, H_280, H_30)];
        titleLabel.text = oneArea[@"title"];
        titleLabel.font = FONT_12;
        titleLabel.textColor = DARKCOLOR;
        offsetY = H_30;
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TOTAL_WIDTH, 1)];
        lineView1.backgroundColor = GRAYEXLIGHTCOLOR;

        [self addSubview:lineView1];
        [self addSubview:titleLabel];
    }
    
    if ([oneArea[@"template"] isEqualToString:@"L1R2"]) {
        ADAreaOneHeightView *leftView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(0, offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [leftView initWithItemData:self.items[0]];
        
        ADAreaHalfHeightView *rightView1 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [rightView1 initWithItemData:self.items[1] andPositon:@"top"];

        ADAreaHalfHeightView *rightView2 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2+offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [rightView2 initWithItemData:self.items[2] andPositon:@"bottom"];

        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, offsetY, 1, AREA_FIX_HEIGHT)];
        lineView1.backgroundColor = GRAYEXLIGHTCOLOR;

        [self addSubview:leftView];
        [self addSubview:rightView1];
        [self addSubview:rightView2];
        [self addSubview:lineView1];
        
        leftView.tag = 0;
        rightView1.tag = 1;
        rightView2.tag = 2;
        [leftView addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightView1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightView2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([oneArea[@"template"] isEqualToString:@"L2R1"]){
        
        ADAreaOneHeightView *rightView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [rightView initWithItemData:self.items[2]];
        
        ADAreaHalfHeightView *leftView1 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(0, offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [leftView1 initWithItemData:self.items[0] andPositon:@"top"];
        
        ADAreaHalfHeightView *leftView2 = [[ADAreaHalfHeightView alloc]initWithFrame:CGRectMake(0, AREA_FIX_HEIGHT/2+offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT/2)];
        [leftView2 initWithItemData:self.items[1] andPositon:@"bottom"];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, offsetY, 1, AREA_FIX_HEIGHT)];
        lineView1.backgroundColor = GRAYEXLIGHTCOLOR;
        
        [self addSubview:leftView1];
        [self addSubview:leftView2];
        [self addSubview:rightView];
        [self addSubview:lineView1];
        
        rightView.tag = 2;
        leftView1.tag = 0;
        leftView2.tag = 1;
        [rightView addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftView1 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftView2 addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else if ([oneArea[@"template"] isEqualToString:@"L1R1"]){
        ADAreaOneHeightView *leftView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(0, offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [leftView initWithItemData:self.items[0]];
        

        ADAreaOneHeightView *rightView = [[ADAreaOneHeightView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, offsetY, TOTAL_WIDTH/2, AREA_FIX_HEIGHT)];
        [rightView initWithItemData:self.items[1]];

        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(TOTAL_WIDTH/2, offsetY, 1, AREA_FIX_HEIGHT)];
        lineView1.backgroundColor = GRAYEXLIGHTCOLOR;
        
        [self addSubview:leftView];
        [self addSubview:rightView];
        [self addSubview:lineView1];
        
        rightView.tag = 1;
        leftView.tag = 0;
        [rightView addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];

    }else{
        // 同上
    }
}

- (void)tapAction:(UIButton *)sender
{
    NSDictionary *item = self.items[sender.tag];
    if (StringHasValue(item[@"type"]) && [item[@"type"] isEqualToString:@"goods"]) {
        NSString *url = [NSString stringWithFormat:@"http://www.manluotuo.com/goods-%@.html",item[@"id"]];
        [self.passDelegate passSignalValue:SIGNAL_MAIN_PAGE_TAPPED andData:url];
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
    [titleLabel setText:[DataTrans getSepString:item[@"name"]]];
    [titleLabel setFont:FONT_12];
    [titleLabel setTextColor:DARKCOLOR];
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
    
    CGSize titleSize = [[DataTrans getSepString:item[@"name"]] sizeWithWidth:H_70 andFont:FONT_12];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_80, H_16, H_80, titleSize.height)];
    [titleLabel setText:[DataTrans getSepString:item[@"name"]]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [titleLabel setTextColor:DARKCOLOR];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    titleLabel.numberOfLines = 0;
    
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(H_80, H_16+titleSize.height, TOTAL_WIDTH/2, H_14)];
    [priceLabel setText:[item[@"price"] stringByAppendingString:@"元"]];
    [priceLabel setFont:LITTLECUSTOMFONT];
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
