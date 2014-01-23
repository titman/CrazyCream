//
//  CICGameResult.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-22.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGameResult.h"
#import "CICGameEntry.h"
#import "CICGameMainMenu.h"
#import "CICGameScoreLocalCache.h"
#import "AppDelegate.h"

@interface CICGameResult ()

@property(nonatomic,assign) CICGameResultType type;
@property(nonatomic,assign) double score;
@property(nonatomic,retain) NSMutableArray * willRemoveChildren;

@end

@implementation CICGameResult

-(void) dealloc
{
    [_willRemoveChildren release];
    [super dealloc];
}

+(id) buildWithType:(CICGameResultType)type score:(double)score
{
    return LC_AUTORELEASE([[CICGameResult alloc] initWithType:type score:score]);
}

-(id) initWithType:(CICGameResultType)type score:(double)score
{
    LC_SUPER_INIT({

        self.willRemoveChildren = [NSMutableArray array];
        
        self.type = type;
        self.score = score;
        
        [self initSelf];
        
        if([CICGameScoreLocalCache addNewScore:score]){
            [LC_UIAlertView showMessage:@"您创造了新记录！" cancelTitle:@"ok"];
        }
        
    });
}

-(void) initSelf
{
    if (self.type == CICGameResultTypeWrong) {
        
        [self showWrongTips];
        
        [self performSelector:@selector(buildScore) withObject:nil afterDelay:2];
        
    }else{
        
        [self buildScore];
        
    }
}

-(void) insertWillRemoveChildren:(id)object
{
    for (SPDisplayObject * aObject in self.willRemoveChildren) {
        if (object == aObject) {
            return;
        }
    }
    
    [self.willRemoveChildren addObject:object];
}

-(void) buildScore
{
    [self removeAllChildren];
    
    SPImage * backgroundImage = [SPImage imageWithContentsOfFile:@"02_background01-iphone4.jpg"];
    backgroundImage.y = 0;
    backgroundImage.x = -20;
    backgroundImage.width = 360;
    backgroundImage.height = 480;
    [self addChild:backgroundImage];
    
    NSString * bmpFontName = [SPTextField registerBitmapFontFromFile:@"desyrel.fnt"];
    
    SPTextField * textField = [SPTextField textFieldWithWidth:320 height:60 text:LC_NSSTRING_FORMAT(@"Score : %d",(int)self.score)];
    textField.x = 0;
    textField.y = 150;
    textField.fontSize = 35;
    textField.fontName = bmpFontName;
    textField.color = SP_WHITE;
    [self addChild:textField];
    
    //
    SPTexture * backTexture = [SPTexture textureWithContentsOfFile:@"bt_home-iphone4.png"];
    SPButton * backButton = [SPButton buttonWithUpState:backTexture];
    backButton.x = 320/2 - 68/2;
    backButton.y = 480 - 200;
    backButton.width = 68;
    backButton.height = 84;
    [backButton addEventListener:@selector(backButtonTriggered:) atObject:self
                         forType:SP_EVENT_TYPE_TRIGGERED];
    [self addChild:backButton];
}

-(void) showWrongTips
{
    SPImage * redBack = [SPImage imageWithContentsOfFile:@"Instant_red-iphone4.png"];
    redBack.y = 50;
    redBack.x = 320;
    redBack.width = 320;
    redBack.height = 270;
    [self addChild:redBack];
    
    SPImage * wrongOut = [SPImage imageWithContentsOfFile:@"Instant_out-iphone4.png"];
    wrongOut.y = 100;
    wrongOut.x = 320;
    wrongOut.width = 183;
    wrongOut.height = 150;
    [self addChild:wrongOut];
    
    SPImage * referee = [SPImage imageWithContentsOfFile:@"Instant_referee01-iphone4.png"];
    referee.y = 0;
    referee.x = 400;
    referee.width = 243;
    referee.height = 400;
    [self addChild:referee];
    
    LC_GCD_SYNCHRONOUS(^{
    
        SPTween * tween = [SPTween tweenWithTarget:redBack time:0.5 transition:SP_TRANSITION_EASE_IN];
        [tween animateProperty:@"x" targetValue:0];
        [self.stage.juggler addObject:tween];
        
        SPTween * tween1 = [SPTween tweenWithTarget:wrongOut time:0.8 transition:SP_TRANSITION_EASE_IN];
        [tween1 animateProperty:@"x" targetValue:0];
        [self.stage.juggler addObject:tween1];
        
        SPTween * tween2 = [SPTween tweenWithTarget:referee time:1 transition:SP_TRANSITION_EASE_IN];
        [tween2 animateProperty:@"x" targetValue:100];
        [self.stage.juggler addObject:tween2];
    
    });
    
    [self performSelector:@selector(buildScore) withObject:nil afterDelay:2];
}


-(void) backButtonTriggered:(SPEvent *)event
{
    for (SPDisplayObject * object in self.willRemoveChildren) {
        [object removeFromParent];
    }
}

@end
