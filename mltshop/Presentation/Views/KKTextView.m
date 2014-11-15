//
//  KKTextView.m
//  merchant
//
//  Created by mactive.meng on 5/5/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "KKTextView.h"

@interface KKTextView()
@property(nonatomic, strong)UILabel *iconLabel;

@end

@implementation KKTextView
@synthesize iconLabel;

#define FONTAWESOME_OFFSET_Y -0.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        [self initIconLabel];
    }
    return self;
}



- (void)initView
{
    self.font = FONT_16;
    self.textColor = GRAYCOLOR;
//    UIEdgeInsets textInsets = UIEdgeInsetsMake( (self.frame.size.height-H_20) /2, self.frame.size.height, 0, 0);
//    self.textContainerInset = textInsets;
    
    [self.layer setCornerRadius:H_5];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor:GRAYEXLIGHTCOLOR.CGColor];
    [self.layer setBorderWidth:1.0f];


    if (OSVersionIsAtLeastiOS7()) {
//        [self setContentInset:UIEdgeInsetsMake(-IOS7_CONTENT_OFFSET_Y, 0, 0, 0)];
    }
}

- (void)initIconLabel
{
    self.iconLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_PADDING, self.frame.size.height/2 - H_15, H_30, H_30)];
    self.iconLabel.font = FONT_AWESOME_20;
    self.iconLabel.textColor = GRAYLIGHTCOLOR;
    self.iconLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.iconLabel];
}

- (void)setIconString:(NSString *)iconString
{
    [self.iconLabel setText:iconString];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    if (self.textIndent == 0) {
        self.textIndent = self.frame.size.height;
    }
    return CGRectInset( bounds , self.textIndent, (self.frame.size.height-H_20) /2 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (self.textIndent == 0) {
        self.textIndent = self.frame.size.height;
    }
    
    return CGRectInset( bounds , self.textIndent, (self.frame.size.height-H_20) /2 );
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
