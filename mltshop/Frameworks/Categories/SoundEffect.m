//
//  SoundEffect.m
//  merchant
//
//  Created by mactive.meng on 31/7/14.
//  Copyright (c) 2014 kkche. All rights reserved.
//

#import "SoundEffect.h"

@implementation SoundEffect

- (id)initWithSoundNamed:(NSString *)filename
{
    if ((self = [super init]))
    {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:@"caf"];
        if (fileURL != nil)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError)
                soundID = theSoundID;
        }
    }
    return self;
}

- (void)dealloc
{
    // TODO: 如果有这一句 系统不会播放
//    AudioServicesDisposeSystemSoundID(soundID);
}

- (void)play
{
    AudioServicesPlaySystemSound(soundID);
    [self performSelector:@selector(stop) withObject:nil afterDelay:1.0f];
}
- (void)stop
{
    AudioServicesDisposeSystemSoundID(soundID);
}

@end