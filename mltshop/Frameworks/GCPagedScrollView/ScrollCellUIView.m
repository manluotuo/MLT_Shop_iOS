//
//  ScrollCellUIView.m
//  tyresize
//
//  Created by meng qian on 13-8-30.
//  Copyright (c) 2013年 thinktube. All rights reserved.
//

#import "ScrollCellUIView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ScrollCellUIView ()
@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UILabel *descLabel;

@end

#define SCROLL_Y    (IS_IPHONE_5 ? 165.0f : 120.0f)
#define SCROLL_HEIGHT    24.0f


@implementation ScrollCellUIView

@synthesize bgImage;
@synthesize titleString;
@synthesize descString;
@synthesize bgImageView;
@synthesize titleLabel;
@synthesize descLabel;
@synthesize imageUrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
        self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.bgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.bgImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - SCROLL_HEIGHT*2.5, SCROLL_HEIGHT*0.5, SCROLL_HEIGHT*2, SCROLL_HEIGHT)];
        self.titleLabel.font = FONT_14;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.titleLabel.layer setCornerRadius:H_5];
        [self.titleLabel.layer setMasksToBounds:YES];
        
        self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - H_30, frame.size.width,H_30)];
        self.descLabel.font = FONT_14;
        self.descLabel.textColor = WHITECOLOR;
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        self.descLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.descLabel];
        
        [self.layer setMasksToBounds:YES];

    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.bgImageView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.titleLabel setFrame:CGRectMake(frame.size.width - SCROLL_HEIGHT*2.5, SCROLL_HEIGHT*0.5, SCROLL_HEIGHT*2, SCROLL_HEIGHT)];
    [self.descLabel setFrame:CGRectMake(0, frame.size.height - H_30, frame.size.width, H_30)];
}

- (void)setBgImage:(UIImage *)bgImage
{
    [self.bgImageView setImage:bgImage];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    [self.bgImageView setImage:[UIImage imageNamed:@"640480"]];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self.bgImageView setImage:image];
        
    }];
//    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setTitleString:(NSString *)_titleString
{
    [self.titleLabel setText:_titleString];
}

- (void)setDescString:(NSString *)_descString
{
    [self.descLabel setText:[NSString stringWithFormat:@"  %@", _descString]];
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
