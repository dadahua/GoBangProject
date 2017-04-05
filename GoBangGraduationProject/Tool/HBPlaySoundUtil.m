//
//  HBPlaySoundUtil.m
//  wq8
//
//  Created by weqia on 13-10-16.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "HBPlaySoundUtil.h"
#import "DHNSUserdefault.h"

@implementation HBPlaySoundUtil
-(id)initForPlayingVibrate
{
    self=[super init];
    if(self){
         soundID = kSystemSoundID_Vibrate; 
    }
    return self;
}
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    self=[super init];
    _type=1;
    if(self){
        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        if (path) {
            SystemSoundID theSoundID;
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}
-(id)initForPlayingSoundEffectWith:(NSString *)filename
{
    self=[super init];
    _type=2;
    if(self){
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL != nil)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError){
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}

-(void)play
{
    if ([DHNSUserdefault getTheIsSounds]) {
        AudioServicesPlaySystemSound(soundID);
    };
}

+(id)shareForPlayingVibrate
{
    static HBPlaySoundUtil * util=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util=[[HBPlaySoundUtil alloc]initForPlayingVibrate];
    });
    return util;
}
+(id)sharePlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    static HBPlaySoundUtil * util=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util=[[HBPlaySoundUtil alloc]initForPlayingSystemSoundEffectWith:resourceName ofType:type];
    });
    return util;
}
+(id)shareForPlayingSoundEffectWith:(NSString *)filename;
{
    if (filename==nil) {
        return nil;
    }
    static NSMutableDictionary * dic=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic=[NSMutableDictionary dictionary];
    });
    HBPlaySoundUtil * util=[dic objectForKey:filename];
    if (util==nil) {
        util=[[HBPlaySoundUtil alloc]initForPlayingSoundEffectWith:filename];
        [dic setObject:util forKey:filename];
    }
    return util;
}
@end
