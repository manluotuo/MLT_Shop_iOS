//
//  RoundedAvatarButton.m
//  bitmedia
//
//  Created by meng qian on 14-2-17.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "RoundedAvatarButton.h"

@interface RoundedAvatarButton()

@end

@implementation RoundedAvatarButton

@synthesize avatarImage;
@synthesize avatarImageView;

#define BORDER_WIDTH 2.0f


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat imageWidth = frame.size.width;
        
        CGRect imageFrame = CGRectMake(BORDER_WIDTH, BORDER_WIDTH, imageWidth, imageWidth);
        
        self.avatarImageView = [[UIImageView alloc]initWithFrame:imageFrame];
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;

        [[self.avatarImageView layer] setCornerRadius:imageWidth/2];
        [[self.avatarImageView layer] setBorderColor:WHITECOLOR.CGColor];
        [[self.avatarImageView layer] setBorderWidth:BORDER_WIDTH];
        self.avatarImageView.layer.masksToBounds = YES;
        
        [self addSubview:avatarImageView];
    }
    return self;
}

- (void)setAvatarImage:(UIImage *)avatarImage
{
    [self.avatarImageView setImage:avatarImage];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
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
