//
//  NSDate+timesince.h
//  youpinapp
//
//  Created by Zhicheng Wei on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Utilities.h"

@interface NSDate (timesince)

-(NSString *)timesince;
-(NSString *)timesinceAgo;
-(NSString *)timesinceWithDepth:(int)depth;
-(NSString *)timesinceWithHuman;
- (NSString *)horoscope;

@end
