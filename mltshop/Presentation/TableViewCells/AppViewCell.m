//
//  AppViewCell.m
//  remote
//
//  Created by Mactive on 3/18/14.
//  Copyright (c) 2014 wukongtv. All rights reserved.
//

#import "AppViewCell.h"
#import "AppRequestManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface AppViewCell()
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UIImageView *iconView;
@property(nonatomic, strong)UIImageView *typeView;
@property(nonatomic, strong)NSDictionary *cellData;

@end

#define AVA_X 15.0f
#define AVA_Y 15.0f
#define AVA_W 50.0f
#define AVA_H 50.0f

@implementation AppViewCell

@synthesize nameLabel;
@synthesize iconView;
@synthesize typeView;
@synthesize cellData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

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
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:GRAYLIGHTCOLOR.CGColor];
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.iconView];
    [self addSubview:self.typeView];
    
}

- (void)setRowData:(NSDictionary *)_rowData
{
    
    self.cellData = _rowData;
    // title
    
    self.nameLabel.text = _rowData[@"name"];
//    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@",[DataTransformer getAppName:_rowData],[DataTransformer getAppSort:_rowData]];
    
    /**
     *  icon
     */
    [self.iconView setImage:nil];

    if (!StringHasValue(_rowData[@"name"])) {
        [self.layer setBorderWidth:0.0f];
        [self.layer setBorderColor:WHITECOLOR.CGColor];
    }

    // 一开始置空

    
    [self setNeedsDisplay];
    
}



@end
