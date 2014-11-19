//
//  NoDataView.m
//  bitmedia
//
//  Created by meng qian on 14-3-18.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "NoDataView.h"
#import "NSString+Size.h"

@interface NoDataView()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *subTitleLabel;

@end

@implementation NoDataView
@synthesize titleString;
@synthesize titleLabel;
@synthesize subTitleLabel;
@synthesize subTitleString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView:frame];
    }
    return self;
}

- (void)initView:(CGRect)frame
{
    
//    self.layer.borderColor = GRAYCOLOR.CGColor;
//    self.layer.borderWidth = 1.0;
    self.backgroundColor = GREENLIGHTCOLOR;
    self.layer.cornerRadius = LEFT_PADDING;
    [self.layer setMasksToBounds:YES];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    titleLabel.numberOfLines = 0;
    [titleLabel setFont:FONT_20];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:WHITECOLOR];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
//    [titleLabel setShadowColor:WHITECOLOR];
//    [titleLabel setShadowOffset:CGSizeMake(0, -1)];
    
    self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.subTitleLabel.numberOfLines = 0;
    [subTitleLabel setFont:FONT_12];
    [subTitleLabel setTextColor:WHITECOLOR];
    [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [subTitleLabel setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.titleLabel];

}

- (void)setTitleString:(NSString *)_titleString
{
    self.titleLabel.text  = _titleString;
    
//    CGSize size = [_titleString sizeWithWidth:self.frame.size.width andFont:FONT_20];
//    [self.titleLabel setFrame:CGRectMake((self.frame.size.width-size.width)/2, (self.frame.size.height - size.height) /2, size.width, size.height)];
    
}

- (void)setSubTitleString:(NSString *)_subTitleString
{
    self.subTitleLabel.text = _subTitleString;
    [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.7)];
    [self.subTitleLabel setFrame:CGRectMake(0, self.frame.size.height*0.6, self.frame.size.width, self.frame.size.height*0.3)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
