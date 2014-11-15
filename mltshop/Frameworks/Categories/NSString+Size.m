//
//  NSString+Size.m
//  bitmedia
//
//  Created by meng qian on 14-3-4.
//  Copyright (c) 2014年 thinktube. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize) sizeWithWidth:(float)width andFont:(UIFont *)font {
    
    CGSize returnSize = CGSizeMake(width, 0);
    CGSize maxSize = CGSizeMake(width, 999);
    CGRect rect = CGRectZero;

    // iOS 7
    if (OSVersionIsAtLeastiOS7()) {

        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
//        paragraphStyle.lineSpacing = H_5;
        rect = [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraphStyle}
                                  context:nil];
        returnSize.height  = rect.size.height+LEFT_PADDING;
        returnSize.width  = rect.size.width;
        
//        NSLog(@"contentString size W: %f H: %f",returnSize.width, returnSize.height);

    }
    // iOS other
    else{
        returnSize = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return returnSize;
}

- (CGSize) sizeWithWidth:(float)width andFont:(UIFont *)font andLineSpaceing:(CGFloat)height
{
    CGSize returnSize = CGSizeMake(width, 0);
    CGSize maxSize = CGSizeMake(width, 999);
    CGRect rect = CGRectZero;
    
    // iOS 7
    if (OSVersionIsAtLeastiOS7()) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = height;

        rect = [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraphStyle}
                                  context:nil];
        returnSize.height  = rect.size.height+LEFT_PADDING;
        returnSize.width  = rect.size.width;
        
//        NSLog(@"contentString size W: %f H: %f",returnSize.width, returnSize.height);
        
    }
    else{
        returnSize = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return returnSize;
}


- (CGSize) sizeWithHeight:(float)height andFont:(UIFont *)font
{
    CGSize returnSize = CGSizeMake(0, height);
    CGSize maxSize = CGSizeMake(999, height);
    CGRect rect = CGRectZero;
    
    // iOS 7
    if (OSVersionIsAtLeastiOS7()) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        rect = [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraphStyle}
                                  context:nil];
        returnSize.width  = rect.size.width;
        returnSize.height  = rect.size.height;
        
        //        NSLog(@"contentString size W: %f H: %f",returnSize.width, returnSize.height);
        
    }
    // iOS other
    else{
        returnSize = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return returnSize;
}

@end
