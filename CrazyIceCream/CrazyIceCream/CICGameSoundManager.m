//
//  CICGameSoundManager.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-9.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGameSoundManager.h"

@implementation CICGameSoundManager

+(LC_AppVersion *) sharedInstance
{
    static dispatch_once_t once;
    static LC_AppVersion * __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } );
    return __singleton__;
}

+(BOOL) playSoundFileName:(NSString *)fileName
{
    SPSound * sound = [SPSound soundWithContentsOfFile:fileName];
    [sound play];
    
    return YES;
}

@end
