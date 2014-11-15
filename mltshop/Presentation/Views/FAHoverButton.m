//
//  FAHoverButton.m
//  bitmedia
//
//  Created by meng qian on 14-3-3.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "FAHoverButton.h"

@interface FAHoverButton()

@property(nonatomic, strong)UILabel *bubbleLabel;

@end

@implementation FAHoverButton

@synthesize iconColor;
@synthesize iconString;
@synthesize bubbleString;
@synthesize bubbleLabel;
@synthesize iconFont;
@synthesize signal;
@synthesize indexPath;
#define BUBBLE_H 15.0f
#define BUBBLE_W 20.0f


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        [self.titleLabel setFont:FONT_AWESOME_24];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [self setTitleColor:WHITECOLOR forState:UIControlStateNormal];
        [self setTitleColor:WHITECOLOR forState:UIControlStateHighlighted];
        
        self.bubbleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 , 0, BUBBLE_W, BUBBLE_H)];
        [self.bubbleLabel setBackgroundColor:DARKCOLOR];
        [self.bubbleLabel setTextColor:WHITECOLOR];
        [self.bubbleLabel setFont:FONT_12];
        [self.bubbleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.bubbleLabel setHidden:YES];
        self.bubbleLabel.backgroundColor = [UIColor clearColor];

        [self addSubview:self.bubbleLabel];

//        UIImage *highlightBG = [FAHoverButton imageWithColor:DARKGREENCOLOR size:frame.size];
//        [self setBackgroundImage:highlightBG forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setBubbleString:(NSString *)_bubbleString
{
    if (StringHasValue(_bubbleString)) {
        [self.bubbleLabel setHidden:NO];
        self.bubbleLabel.text = _bubbleString;
    }
}

- (void)setIconImage:(UIImage *)iconImage
{
    [self setImage:iconImage forState:UIControlStateNormal];
    [self setImage:iconImage forState:UIControlStateHighlighted];
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 20)];
}

- (void)setIconColor:(UIColor *)_iconColor
{
    [self setTitleColor:_iconColor forState:UIControlStateNormal];
    [self setTitleColor:_iconColor forState:UIControlStateHighlighted];

}

- (void)setIconString:(NSString *)_iconString
{
    [self setTitle:_iconString forState:UIControlStateNormal];
    [self setTitle:_iconString forState:UIControlStateHighlighted];
}

- (void)setIconFont:(UIFont *)_iconFont
{
    [self.titleLabel setFont:_iconFont];
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
