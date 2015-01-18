//
//  ScanOverlayView.m
//  merchant
//
//  Created by mactive.meng on 30/7/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "ScanOverlayView.h"

@implementation ScanOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;


    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#define COR 30.0f

- (void)drawRect:(CGRect)rect
{
    CGFloat ratio;
    if (OSVersionIsAtLeastiOS7()) {
        ratio = 0.98;
    }else{
        ratio = 0.94;
    }
    // TODO ios6
    CGRect holeRect = CGRectMake(H_20, TOTAL_HEIGHT/2-H_280/2, H_280, H_280);
    UIColor *alphaColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];

    // Start by filling the area with the blue color
    [alphaColor setFill];
    UIRectFill( rect );
    
    // Assume that there's an ivar somewhere called holeRect of type CGRect
    // We could just fill holeRect, but it's more efficient to only fill the
    // area we're being asked to draw.
    CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
    
    [[UIColor clearColor] setFill];
    UIRectFill( holeRectIntersection );
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // and now draw the Path!
    CGContextStrokePath(context);
    
    
    CGContextSetStrokeColorWithColor(context, GRAYCOLOR.CGColor);
    CGContextSetLineWidth(context, 5.0f);
    
    
    CGContextMoveToPoint(context, H_10, H_160); //start at this point
    CGContextAddLineToPoint(context, H_10, H_160 - COR); //draw to this point
    CGContextAddLineToPoint(context, H_10+COR, H_160 - COR); //start at this point
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, H_310-COR, H_130); //start at this point
    CGContextAddLineToPoint(context, H_310, H_130); //draw to this point
    CGContextAddLineToPoint(context, H_310, H_130+COR); //start at this point
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, H_10, TOTAL_HEIGHT*ratio-H_120-COR); //start at this point
    CGContextAddLineToPoint(context, H_10, TOTAL_HEIGHT*ratio - H_120); //draw to this point
    CGContextAddLineToPoint(context, H_10+COR, TOTAL_HEIGHT*ratio - H_120); //start at this point
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, H_310-COR, TOTAL_HEIGHT*ratio-H_120); //start at this point
    CGContextAddLineToPoint(context, H_310, TOTAL_HEIGHT*ratio-H_120); //draw to this point
    CGContextAddLineToPoint(context, H_310, TOTAL_HEIGHT*ratio-COR-H_120); //start at this point
    CGContextStrokePath(context);
    
    
}

@end
