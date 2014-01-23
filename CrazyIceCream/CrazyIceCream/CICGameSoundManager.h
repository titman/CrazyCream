//
//  CICGameSoundManager.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-9.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import <Foundation/Foundation.h>

#define CI_SOUND_NEW_SCORE @"normalScore.mp3"
#define CI_SOUND_BUTTON_TOUCH @"000-click.mp3"

@interface CICGameSoundManager : NSObject

+(CICGameSoundManager *) sharedInstance;

+(BOOL) playSoundFileName:(NSString *)fileName;

@end
