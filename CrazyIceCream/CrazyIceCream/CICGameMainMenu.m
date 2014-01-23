//
//  CICGameMainMenu.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-7.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGameMainMenu.h"
#import "CICGameButton.h"
#import "CICGameSoundManager.h"
#import "CICGamePlayScene.h"
#import "CICGameScoreLocalCache.h"

@implementation CICGameMainMenu
{
    SPSprite * _iconImage;
    CICGameButton * _playButton;
    CICGameButton * _rankButton;
}

+(id) build
{
    return LC_AUTORELEASE([[CICGameMainMenu alloc] init]);
}

-(id) init
{
    LC_SUPER_INIT({
        
        [self initMenu];
    
    });
}

-(void) initMenu
{

    //
    SPImage * backgroundImage = [SPImage imageWithContentsOfFile:@"02_background01-iphone4.jpg"];
    backgroundImage.y = 0;
    backgroundImage.x = -20;
    backgroundImage.width = 360;
    backgroundImage.height = 480;
    [self addChild:backgroundImage];
    
    //
    _iconImage = [SPSprite sprite];
    _iconImage.x = 320/2 - 149/2;
    _iconImage.y = 0;
    _iconImage.width = 149;
    _iconImage.height = 127;
    _iconImage.alpha = 0;
    
    
    SPImage * logo = [SPImage imageWithContentsOfFile:@"select_image03-iphone4.png"];
    logo.x = 149/2 - 127/2;
    logo.y = 127/2 - 103/2;
    logo.width = 127;
    logo.height = 103;
    
    
    SPImage * logoBackImage = [SPImage imageWithContentsOfFile:@"select_stage01-iphone4.png"];
    logoBackImage.x = 0;
    logoBackImage.y = 0;
    logoBackImage.width = 149;
    logoBackImage.height = 127;
    
    
    [_iconImage addChild:logo];
    [_iconImage addChild:logoBackImage];
    [self addChild:_iconImage];
    
    //
    SPTexture * rankTexture = [SPTexture textureWithContentsOfFile:@"fail_button02-iphone4.png"];

    _rankButton = [[CICGameButton alloc] initWithUpState:rankTexture];
    _rankButton.x = 320/2 - 62/2 - 62*0.5;
    _rankButton.y = 480;
    _rankButton.width = 62;
    _rankButton.height = 57;
    _rankButton.alpha = 0;
    [_rankButton addEventListener:@selector(rankButtonTriggered:) atObject:self
                          forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_rankButton];
    [_rankButton release];
    
    //
    SPTexture * playTexture = [SPTexture textureWithContentsOfFile:@"title_btplay-iphone4.png"];
    
    _playButton = [[CICGameButton alloc] initWithUpState:playTexture];
    _playButton.x = 320/2 - 62/2 + 62*0.5;
    _playButton.y = 480;
    _playButton.width = 62;
    _playButton.height = 57;
    _playButton.alpha = 0;
    [_playButton addEventListener:@selector(playButtonTriggered:) atObject:self
                          forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_playButton];
    [_playButton release];
    
    
    //
    [self iconAnimateStart];
    [self welcomeSoundStart];
}

-(void) iconAnimateStart
{
    LC_GCD_SYNCHRONOUS(^{
    
        SPTween * tween = [SPTween tweenWithTarget:_iconImage time:3.5f transition:SP_TRANSITION_EASE_OUT_ELASTIC];
        
        [tween animateProperty:@"y" targetValue:480/2 - 127/2];
        [tween animateProperty:@"alpha" targetValue:1];

        [self.stage.juggler addObject:tween];
        
        
        SPTween * tween1 = [SPTween tweenWithTarget:_playButton time:2.0f transition:SP_TRANSITION_EASE_OUT_BOUNCE];
        
        [tween1 animateProperty:@"y" targetValue:480 - 70];
        [tween1 animateProperty:@"alpha" targetValue:1];
        
        [self.stage.juggler addObject:tween1];
        
        
        SPTween * tween2 = [SPTween tweenWithTarget:_rankButton time:2.0f transition:SP_TRANSITION_EASE_OUT_BOUNCE];
        
        [tween2 animateProperty:@"y" targetValue:480 - 70];
        [tween2 animateProperty:@"alpha" targetValue:1];
        
        [self.stage.juggler addObject:tween2];
    
    });

}

-(void) welcomeSoundStart
{
    [CICGameSoundManager playSoundFileName:CI_SOUND_NEW_SCORE];
}

-(void) rankButtonTriggered:(SPEvent *)event
{
    NSMutableString * content = [[NSMutableString alloc] init];
    NSArray * scoreArray = [CICGameScoreLocalCache scoreCache];
    
    for (NSNumber * score in scoreArray) {
        [content appendFormat:@"%@\n",score];
    }
    
    [LC_UIAlertView showMessage:content cancelTitle:@"ok"];
    [content release];
}

-(void) playButtonTriggered:(SPEvent *)event
{
    [self addChild:[CICGamePlayScene build]];
}


@end
