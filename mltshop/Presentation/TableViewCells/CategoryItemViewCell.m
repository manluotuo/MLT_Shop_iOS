//
//  CategoryItemViewCell.m
//  remote
//
//  Created by Mactive on 3/18/14.
//  Copyright (c) 2014 wukongtv. All rights reserved.
//

#import "CategoryItemViewCell.h"
#import "AppRequestManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FAHoverButton.h"

@interface CategoryItemViewCell()
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UIImageView *iconView;
@property(nonatomic, strong)UIImageView *typeView;
@property(nonatomic, strong)NSDictionary *cellData;
@property(nonatomic, strong)UIView *subView;


@end

#define AVA_X 15.0f
#define AVA_Y 20.0f
#define AVA_W 50.0f
#define AVA_H 50.0f

@implementation CategoryItemViewCell

@synthesize nameLabel;
@synthesize iconView;
@synthesize typeView;
@synthesize cellData;
@synthesize subView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

#define ITEM_PER_LINE 3


- (void)initView
{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, AVA_Y, CELL_WIDTH, LABEL_HEIGHT)];
    [self.nameLabel setTextColor:DARKCOLOR];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.nameLabel setFont:FONT_12];
    [self.nameLabel setBackgroundColor:[UIColor clearColor]];
    
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(AVA_X, AVA_Y, AVA_W, AVA_H)];
    [self.iconView setContentMode:UIViewContentModeScaleAspectFill];
    [self.iconView.layer setCornerRadius:5.0f];
    [self.iconView.layer setMasksToBounds:YES];
    
    self.typeView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_PADDING/2, TOP_PADDING, AVA_X, AVA_X)];
    [self.typeView setHidden:YES];
    [self.layer setBorderWidth:0.5f];
    [self.layer setBorderColor:GRAYEXLIGHTCOLOR.CGColor];
    
    self.subView = [[UIView alloc]initWithFrame:CGRectMake(0, CELL_HEIGHT, TOTAL_WIDTH, H_150)];
    self.subView.backgroundColor = DARKCOLOR;
    [self.subView setHidden:YES];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconView];
    [self addSubview:self.typeView];
    [self addSubview:self.subView];
    
}

- (void)setRowData:(CategoryModel *)_rowData
{
    
    [self setBackgroundColor:WHITECOLOR];

    self.nameLabel.text = _rowData.catName;
    if (_rowData.isPicked) {
        self.backgroundColor = GREENLIGHTCOLOR2;
        [self.layer setBorderWidth:0.0f];
        [self showSubBrand:_rowData];
    }else{
        [self.subView setHidden:YES];
        self.backgroundColor = [UIColor clearColor];
        [self.layer setBorderWidth:0.5f];
        [self.layer setBorderColor:GRAYEXLIGHTCOLOR.CGColor];
    }
    
    /**
     *  icon
     */
    [self.iconView setImage:nil];

    if (!StringHasValue(_rowData.catName)) {
        [self.layer setBorderWidth:0.0f];
        [self.layer setBorderColor:WHITECOLOR.CGColor];
    }else{
        [self.layer setBorderWidth:0.5f];
        [self.layer setBorderColor:GRAYEXLIGHTCOLOR.CGColor];
    }
    

    // 一开始置空
    [self setNeedsDisplay];
    
}

#define VIEW_WIDTH  TOTAL_WIDTH/3
#define VIEW_HEIGHT 50
#define X_OFFSET    0
#define Y_OFFSET    0

- (CGRect)calcRect:(NSInteger)index preLine:(NSInteger)preLine
{
    CGFloat x = X_OFFSET * (index % preLine * 2 + 1) + VIEW_WIDTH * (index % preLine) ;
    CGFloat y = Y_OFFSET * (floor(index / preLine) * 2 + 1) + VIEW_HEIGHT * floor(index / preLine);
    return  CGRectMake( x, y, VIEW_WIDTH, VIEW_HEIGHT);
}

- (void)showSubBrand:(CategoryModel *)catData
{
    self.subView.x = - catData.indexPath.row * TOTAL_WIDTH/ITEM_PER_LINE;
    for (UIView *view in self.subView.subviews) {
        [view removeFromSuperview];
    }
    [self.subView setHidden:NO];

    
    for (int i = 0; i< [catData.subBrands count]; i++) {
        NSDictionary *brand = catData.subBrands[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = FONT_12;
        [button setTitle:brand[@"brandName"] forState:UIControlStateNormal];
        [button setFrame:[self calcRect:i preLine:ITEM_PER_LINE]];
        [self.subView addSubview:button];
    }
    
}



@end
