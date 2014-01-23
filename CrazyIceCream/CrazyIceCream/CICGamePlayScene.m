//
//  CICGamePlaySprite.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-9.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGamePlayScene.h"
#import "CICGameButton.h"
#import "CICGameMainMenu.h"
#import "CICGameTimeProgress.h"
#import "CICIce.h"
#import "CICGameResult.h"
#import "CICGameSoundManager.h"
#import "CICGameScore.h"

#pragma mark -

typedef enum _CICGameMissionRateType{
    
    CICGameMissionRateTypeBad = 0,
    CICGameMissionRateTypeGood,
    CICGameMissionRateTypeGreat,
    CICGameMissionRateTypePerfect,

} CICGameMissionRateType;

@interface CICGameMissionRate : NSObject



@end

@implementation CICGameMissionRate

+(CICGameMissionRateType)rateFrom:(double)fromTimeStamp toDate:(double)toTimeStamp distence:(NSNumber **)distence
{
    int m = ((toTimeStamp - fromTimeStamp) * 1000.0f);
    
    * distence = [NSNumber numberWithInteger:m];
    
    if (m <= 1000) {
        return CICGameMissionRateTypePerfect;
    }else if (m > 1000 && m <= 200){
        return CICGameMissionRateTypeGreat;
    }else if (m > 1500 && m <= 3000){
        return CICGameMissionRateTypeGood;
    }else{
        return CICGameMissionRateTypeBad;
    }
}

+(void) playRateSoundEffect:(CICGameMissionRateType)rate
{
    switch (rate) {
            
        case CICGameMissionRateTypePerfect:
            
            [CICGameSoundManager playSoundFileName:@"perfect.mp3"];
            
            break;
        case CICGameMissionRateTypeGreat:
            
            [CICGameSoundManager playSoundFileName:@"great.mp3"];

            break;
        case CICGameMissionRateTypeGood:
            
            [CICGameSoundManager playSoundFileName:@"good.mp3"];

            break;
        case CICGameMissionRateTypeBad:
            
            [CICGameSoundManager playSoundFileName:@"bad.mp3"];

            break;
    }
}

+(double) rateScore:(CICGameMissionRateType)rate
{
    switch (rate) {
            
        case CICGameMissionRateTypePerfect:
            
            return PERFECT_SCORE;
            
            break;
        case CICGameMissionRateTypeGreat:
            
            return GREAT_SCORE;
            
            break;
        case CICGameMissionRateTypeGood:
            
            return GOOD_SCORE;
            
            break;
        case CICGameMissionRateTypeBad:
            
            return BAD_SCORE;
            
            break;
    }
}

@end

#pragma mark -

@implementation CICGamePlayScene
{
    CICGameButton * _restartButton;  // 重新开始按钮
    CICGameButton * _pauseButton;   // 暂停按钮
    
    SPButton * _redButton;  // 红色按钮
    SPButton * _yellowButton;   // 黄色按钮
    SPButton * _blueButton; // 蓝色按钮
    
    CICIce * _iceMain;  // 冰激凌主界面
    
    CICGameTimeProgress * _timeProgress; // 时间进度
    
    double _startTimeStamp; // 每一关开始时间戳
    double _endTimeStamp;   // 每一关结束时间戳
    
    CICGameScore * _gameScore;  // 游戏分数

}

-(void) dealloc
{
    [_pauseButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_restartButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_redButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_yellowButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    [_blueButton removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
    [super dealloc];
}

+(id) build
{
    return LC_AUTORELEASE([[CICGamePlayScene alloc] init]);
}

-(id) init
{
    LC_SUPER_INIT({
        
        [self initSelf];
        
    });
}


// Build UI
-(void) initSelf
{
    __block CICGamePlayScene * nRetainSelf = self;

    
    
    SPImage * backgroundImage = [SPImage imageWithContentsOfFile:@"Default.png"];
    backgroundImage.y = 0;
    backgroundImage.x = 0;
    backgroundImage.width = 360;
    backgroundImage.height = 480;
    [self addChild:backgroundImage];
 
    
    {
        // Ice Main
        
        float inv = (320-90*3)/4;
        
        SPImage * downIce = [SPImage imageWithContentsOfFile:@"03_cones-iphone4.png"];
        downIce.y = 480 - 195;
        downIce.x = inv;
        downIce.width = 90;
        downIce.height = 189;
        [self addChild:downIce];
        
        SPImage * downIce1 = [SPImage imageWithContentsOfFile:@"03_cones-iphone4.png"];
        downIce1.y = 480 - 195;
        downIce1.x = 90 + inv * 2;
        downIce1.width = 90;
        downIce1.height = 189;
        [self addChild:downIce1];
        
        SPImage * downIce2 = [SPImage imageWithContentsOfFile:@"03_cones-iphone4.png"];
        downIce2.y = 480 - 195;
        downIce2.x = 90 * 2 + inv * 3;
        downIce2.width = 90;
        downIce2.height = 189;
        [self addChild:downIce2];
        
        _iceMain = [CICIce build];
        _iceMain.x = 0;
        _iceMain.y = 0;
        
        _iceMain.faildBlock = ^(id value){
            
            [nRetainSelf iceClickWrong];
        };
        
        _iceMain.passedBlock = ^(id value){
            
            [nRetainSelf missionPassed];
        };
        
        [self addChild:_iceMain];
    }
    
    
    SPTexture * restartTexture = [SPTexture textureWithContentsOfFile:@"stage_button02-iphone4.png"];
    
    _restartButton = [[CICGameButton alloc] initWithUpState:restartTexture];
    _restartButton.x = 320 - 50;
    _restartButton.y = 30;
    _restartButton.width = 107;
    _restartButton.height = 47;
    [_restartButton addEventListener:@selector(restartButtonTriggered:) atObject:self
                          forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_restartButton];
    [_restartButton release];

    
    SPTexture * pauseTexture = [SPTexture textureWithContentsOfFile:@"stage_button01-iphone4.png"];
    
    _pauseButton = [[CICGameButton alloc] initWithUpState:pauseTexture];
    _pauseButton.x = 320 - 50;
    _pauseButton.y = 30 + 47 + 10;
    _pauseButton.width = 107;
    _pauseButton.height = 47;
    [_pauseButton addEventListener:@selector(pauseButtonTriggered:) atObject:self
                             forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_pauseButton];
    [_pauseButton release];
    
    
    
    _gameScore = [CICGameScore build];
    _gameScore.x = 10;
    _gameScore.y = 0;
    _gameScore.width = 320;
    _gameScore.height = 46;
    [self addChild:_gameScore];
    
    
    
    _timeProgress = [CICGameTimeProgress build];
    _timeProgress.x = -50;
    _timeProgress.y = 50;
    _timeProgress.width = 277;
    _timeProgress.height = 46;
    [self addChild:_timeProgress];
    
    
    _timeProgress.faildBlock = ^(id value){
    
        [nRetainSelf gameOver];
    };
    
    
    //
    SPTexture * redTexture = [SPTexture textureWithContentsOfFile:@"00_Rbt-iphone4.png"];
    _redButton = [SPButton buttonWithUpState:redTexture];
    [_redButton setDownState:redTexture];
    _redButton.x = 0;
    _redButton.y = 480 - 104;
    _redButton.width = 107;
    _redButton.height = 104;
    [_redButton addEventListener:@selector(redButtonTriggered:) atObject:self
                             forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_redButton];
    
    SPImage * tip1 = [SPImage imageWithContentsOfFile:@"03_button-iphone4.png"];
    tip1.y = 104/2 - 49/2;
    tip1.x = 107/2 - 48/2;
    tip1.width = 48;
    tip1.height = 49;
    [_redButton addChild:tip1];
    
    
    
    
    SPTexture * yellowTexture = [SPTexture textureWithContentsOfFile:@"00_Ybt-iphone4.png"];
    _yellowButton = [SPButton buttonWithUpState:yellowTexture];
    [_yellowButton setDownState:yellowTexture];
    _yellowButton.x = 107;
    _yellowButton.y = 480 - 104;
    _yellowButton.width = 107;
    _yellowButton.height = 104;
    [_yellowButton addEventListener:@selector(yellowButtonTriggered:) atObject:self
                        forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_yellowButton];
    
    SPImage * tip2 = [SPImage imageWithContentsOfFile:@"03_button-iphone4.png"];
    tip2.y = 104/2 - 49/2;
    tip2.x = 107/2 - 48/2;
    tip2.width = 48;
    tip2.height = 49;
    [_yellowButton addChild:tip2];
    
    
    
    
    SPTexture * blueTexture = [SPTexture textureWithContentsOfFile:@"00_Bbt-iphone4.png"];
    _blueButton = [SPButton buttonWithUpState:blueTexture];
    [_blueButton setDownState:blueTexture];
    _blueButton.x = 107*2;
    _blueButton.y = 480 - 104;
    _blueButton.width = 107;
    _blueButton.height = 104;
    [_blueButton addEventListener:@selector(blueButtonTriggered:) atObject:self
                           forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:_blueButton];
    
    SPImage * tip3 = [SPImage imageWithContentsOfFile:@"03_button-iphone4.png"];
    tip3.y = 104/2 - 49/2;
    tip3.x = 107/2 - 48/2;
    tip3.width = 48;
    tip3.height = 49;
    [_blueButton addChild:tip3];
    
    
    
    
    [self preparePlay];
}


// 冰激凌超过
-(void) iceClickWrong
{
    [_timeProgress stop];
    
    CICGameResult * result = [CICGameResult buildWithType:CICGameResultTypeWrong score:_gameScore.score];
    result.x = 0;
    result.y = 0;
    result.width = 320;
    result.height = 480;
    
    [result insertWillRemoveChildren:self];

    [self addChild:result];
}

// 过了一关
-(void) missionPassed
{
    // 设置开始时间戳
    _endTimeStamp = CFAbsoluteTimeGetCurrent();
    
    {
        [self rate];
        [_iceMain startNewMission];
    }
        
    _startTimeStamp = CFAbsoluteTimeGetCurrent();
}

// 评价加分并播放音频
-(void) rate
{
    NSNumber * distence = @0;
    
    CICGameMissionRateType type = [CICGameMissionRate rateFrom:_startTimeStamp toDate:_endTimeStamp distence:&distence];
    
    // 播放音频
    [CICGameMissionRate playRateSoundEffect:type];
    
    // 加分
    [_gameScore addScore:[CICGameMissionRate rateScore:type]];
    
    // 时间加分
    [_gameScore addScore:(TIME_SCORE_BASE - [distence intValue])/10];
}

// Red button
-(void) redButtonTriggered:(SPEvent *)event
{
    [_iceMain addIceAtIndex:0];
}

// Yellow button
-(void) yellowButtonTriggered:(SPEvent *)event
{
    [_iceMain addIceAtIndex:1];
}

// Blue button
-(void) blueButtonTriggered:(SPEvent *)event
{
    [_iceMain addIceAtIndex:2];
}

// 重新开始
-(void) restartButtonTriggered:(SPEvent *)event
{
    ;
}

// 暂停
-(void) pauseButtonTriggered:(SPEvent *)event
{
    ;
}

// Time out
-(void) gameOver
{
    [_timeProgress stop];
    
    CICGameResult * result = [CICGameResult buildWithType:CICGameResultTypeTimeout score:_gameScore.score];
    result.x = 0;
    result.y = 0;
    result.width = 320;
    result.height = 480;
    
    [result insertWillRemoveChildren:self];

    [self addChild:result];
    
}





// -------
// 准备开始
-(void) preparePlay
{
    SPImage * prepareImage = [SPImage imageWithContentsOfFile:@"02-2-iphone4.png"];
    prepareImage.y = 480 - 568;
    prepareImage.x = -20;
    prepareImage.width = 360;
    prepareImage.height = 568;
    [self addChild:prepareImage];
    
    SPImage * prepareImage1 = [SPImage imageWithContentsOfFile:@"02-5-iphone4.png"];
    prepareImage1.y = 480 - 568;
    prepareImage1.x = -20;
    prepareImage1.width = 360;
    prepareImage1.height = 568;
    [self addChild:prepareImage1];
    
    [self performSelector:@selector(hidePrepareImage:) withObject:@[prepareImage,prepareImage1] afterDelay:1];
}

-(void) hidePrepareImage:(NSArray *)images
{
    {
        SPImage * image = images[1];
        [self removeChild:image];
        
        SPImage * image1 = images[0];
        [self performSelector:@selector(removeChild:) withObject:image1 afterDelay:1];
        
        [CICGameSoundManager playSoundFileName:@"readyGo.mp3"];
    }
        
    [_timeProgress start];
    [_iceMain startNewMission];
    
    // 设置开始时间戳
    _startTimeStamp = CFAbsoluteTimeGetCurrent();
}



@end
