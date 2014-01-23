//
//  CICGameTimeProgress.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-9.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGameTimeProgress.h"
#import "CICGameConfig.h"

@interface CICGameTimeProgress()
{
    SPTextField * _textField;
}

@property(nonatomic,assign) int time;

@end

@implementation CICGameTimeProgress

-(void) dealloc
{
    self.faildBlock = nil;
    [super dealloc];
}

+(id) build
{
    return LC_AUTORELEASE([[CICGameTimeProgress alloc] init]);
}

-(id) init
{
    LC_SUPER_INIT({
        
        [self initSelf];
        
    });
}

-(void) initSelf
{
    self.rotation = 0.1;
    
    SPImage * backgroundImage = [SPImage imageWithContentsOfFile:@"stage_word-iphone4.png"];
    backgroundImage.y = 0;
    backgroundImage.x = 0;
    backgroundImage.width = 277;
    backgroundImage.height = 46;
    [self addChild:backgroundImage];
    
    NSString * bmpFontName = [SPTextField registerBitmapFontFromFile:@"desyrel.fnt"];
    
    _textField = [SPTextField textFieldWithWidth:277 height:46 text:@""];
    _textField.x = 50;
    _textField.y = -20;
    _textField.fontSize = 40;
    _textField.fontName = bmpFontName;
    _textField.color = SP_WHITE;
    [self addChild:_textField];
    
    self.time = INITIAL_TIME * 10;
}

-(void) addTime:(int)time
{
    _time += time * 10;
}

-(void) start
{
    [self timer:0.1 repeat:YES name:@"UpdateTimer"];
}

-(void) stop
{
    [self cancelAllTimers];
}

-(void) removeFromParent
{
    [self stop];

    [super removeFromParent];
}

-(void) setTime:(int)time
{
    _time = time;
    
    _textField.text = [NSString stringWithFormat:@"%d : %d",_time/10,_time%10];
}

-(void) handleTimer:(NSTimer *)timer
{
    if ([timer is:@"UpdateTimer"]) {
        
        self.time -= 1;
        
        if (self.time <= 0) {
            [self stop];
            if (self.faildBlock) {
                self.faildBlock(nil);
            }
        }
    }
}


@end
