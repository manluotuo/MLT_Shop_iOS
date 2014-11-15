//
//  SoundEffect.h
//  merchant
//
//  Created by mactive.meng on 31/7/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>

@interface SoundEffect : NSObject
{
    SystemSoundID soundID;
}

- (id)initWithSoundNamed:(NSString *)filename;
- (void)play;

@end