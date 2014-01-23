//
//  CICIce.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-22.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICIce.h"
#import "CICGameSoundManager.h"
#import "SPAVSound.h"

static float rLeftPadding = 10;
static float yLeftPadding = 113;
static float bLeftPadding = 214;

static float iceRLeftPadding = 3;
static float iceYLeftPadding = 107;
static float iceBLeftPadding = 210;

@interface CICIce()

@property(nonatomic,retain) NSMutableArray * iceImages;
@property(nonatomic,retain) NSMutableArray * existingIce;

@property(nonatomic,assign) int rIceNumber;
@property(nonatomic,assign) int yIceNumber;
@property(nonatomic,assign) int bIceNumber;

@property(nonatomic,assign) BOOL rComplete;
@property(nonatomic,assign) BOOL yComplete;
@property(nonatomic,assign) BOOL bComplete;

@property(nonatomic,retain) NSData * clickSoundData;
@property(nonatomic,retain) AVAudioPlayer * soundPlayer;

@end

@implementation CICIce

-(void) dealloc
{
    [_existingIce release];
    [_iceImages release];
    [_clickSoundData release];
    
    [_soundPlayer stop];
    [_soundPlayer release];
    
    self.passedBlock = nil;
    self.faildBlock = nil;
    
    [super dealloc];
}

+(id) build
{
    return LC_AUTORELEASE([[CICIce alloc] init]);
}

-(id) init
{
    LC_SUPER_INIT({
        
        [self initSelf];
        
    });
}

-(void) initSelf
{
    // 框架的播放器太蛋疼,不能播mp3,而且还是即时加载的,太卡了.
    NSString * fullPath = [SPUtils absolutePathToFile:@"03_fall.mp3"];
    self.clickSoundData = [[[NSData alloc] initWithContentsOfMappedFile:fullPath] autorelease];
    
    _gameOver = NO;
    
    self.width = 320;
    self.height = 480 - 195;
    
    self.iceImages = [NSMutableArray array];
    
    [self.iceImages addObject:@"03_ice01-iphone4.png"];
    [self.iceImages addObject:@"03_ice02-iphone4.png"];
    [self.iceImages addObject:@"03_ice03-iphone4.png"];
    [self.iceImages addObject:@"03_ice04-iphone4.png"];
    [self.iceImages addObject:@"03_ice05-iphone4.png"];
    [self.iceImages addObject:@"03_ice06-iphone4.png"];
    
    self.existingIce = [NSMutableArray array];
    
    [self.existingIce addObject:[NSMutableArray array]];
    [self.existingIce addObject:[NSMutableArray array]];
    [self.existingIce addObject:[NSMutableArray array]];

}

-(void) startNewMission
{
    self.rIceNumber = 0;
    self.yIceNumber = 0;
    self.bIceNumber = 0;
    
    self.rComplete = NO;
    self.yComplete = NO;
    self.bComplete = NO;


    for (NSMutableArray * subArray in self.existingIce) {
        [subArray removeAllObjects];
    }
    
    [self removeAllChildren];
    
    self.rIceNumber = [SPUtils randomIntBetweenMin:1 andMax:6];
    self.yIceNumber = [SPUtils randomIntBetweenMin:1 andMax:6];
    self.bIceNumber = [SPUtils randomIntBetweenMin:1 andMax:6];

    [self buildDottedLine:self.rIceNumber index:0];
    [self buildDottedLine:self.yIceNumber index:1];
    [self buildDottedLine:self.bIceNumber index:2];

}

-(void) buildDottedLine:(int)iceNumber index:(int)index
{
    float x = 0;
    
    switch (index) {
        case 0:
            x = rLeftPadding;
            break;
        case 1:
            x = yLeftPadding;
            break;
        case 2:
            x = bLeftPadding;
            break;
    }
    
    for (int i = 0; i < iceNumber; i++) {
        
        SPImage * downIce = nil;
        
        if (i == iceNumber - 1) {
            downIce = [SPImage imageWithContentsOfFile:@"03_dashed01-iphone4.png"];
        }else{
            downIce = [SPImage imageWithContentsOfFile:@"03_dashed02-iphone4.png"];
        }
        
        downIce.y = (480 - 180) - 54 * (i + 1);
        downIce.x = x;
        downIce.width = 90;
        downIce.height = 54;
        [self addChild:downIce];
    }
}

-(void) addIceAtIndex:(int)index
{
    LC_GCD_ASYNCHRONOUS(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
        
        self.soundPlayer = [[[AVAudioPlayer alloc] initWithData:self.clickSoundData error:nil] autorelease];
        [self.soundPlayer play];
        
    });
    
    float x = 0;
    
    switch (index) {
        case 0:
            x = iceRLeftPadding;
            break;
        case 1:
            x = iceYLeftPadding;
            break;
        case 2:
            x = iceBLeftPadding;
            break;
    }
    
    NSMutableArray * subArray = self.existingIce[index];
    
    SPImage * randomImage = [SPImage imageWithContentsOfFile:self.iceImages[[SPUtils randomIntBetweenMin:0 andMax:6]]];
    
    
    randomImage.x = x;
    randomImage.y = -86;
    randomImage.width = 102;
    randomImage.height = 86;
    
    [self addChild:randomImage];
    
    {
        SPTween * tween = [SPTween tweenWithTarget:randomImage time:0.3 transition:SP_TRANSITION_EASE_IN];
        [tween animateProperty:@"y" targetValue:(480 - 180) - 54 * (subArray.count + 1)];
        [self.stage.juggler addObject:tween];
    }
    
    [subArray addObject:randomImage];
    
    
    int iceMaxNumber = 0;
    
    switch (index) {
        case 0:
            iceMaxNumber = self.rIceNumber;
            
            if (iceMaxNumber == subArray.count) {
                self.rComplete = YES;
            }else{
                self.rComplete = NO;
            }
            
            break;
        case 1:
            iceMaxNumber = self.yIceNumber;
            
            if (iceMaxNumber == subArray.count) {
                self.yComplete = YES;
            }else{
                self.yComplete = NO;
            }
            
            break;
        case 2:
            iceMaxNumber = self.bIceNumber;
            
            if (iceMaxNumber == subArray.count) {
                self.bComplete = YES;
            }else{
                self.bComplete = NO;
            }
            
            break;
    }
    
    // 过关
    if (self.rComplete && self.yComplete && self.bComplete) {
        
        if (self.passedBlock) {
            self.passedBlock(nil);
        }
        return;
    }
    
    // 判断
    if (subArray.count > iceMaxNumber) {
        
        [CICGameSoundManager playSoundFileName:@"09_wrong.mp3"];
        
        _gameOver = YES;
        
        if (self.faildBlock) {
            self.faildBlock(nil);
        }
    }
}

@end
