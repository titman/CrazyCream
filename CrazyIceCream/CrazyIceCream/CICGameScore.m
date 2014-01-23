//
//  CICGameScore.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-23.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGameScore.h"

@implementation CICGameScore
{
    SPTextField * _textField;
}

+(id) build
{
    return LC_AUTORELEASE([[CICGameScore alloc] init]);
}

-(id) init
{
    LC_SUPER_INIT({
        
        [self initSelf];
        
    });
}

-(void) initSelf
{
    NSString * bmpFontName = [SPTextField registerBitmapFontFromFile:@"desyrel.fnt"];
    
    _textField = [SPTextField textFieldWithWidth:320 height:46 text:@"0"];
    _textField.x = 0;
    _textField.y = 0;
    _textField.fontSize = 35;
    _textField.fontName = bmpFontName;
    _textField.color = SP_WHITE;
    [self addChild:_textField];
}

-(double) score
{
    return [_textField.text doubleValue];
}

-(void) addScore:(double)score
{
    _textField.text = LC_NSSTRING_FORMAT(@"%d",(int)([_textField.text doubleValue] + score));
}

@end
