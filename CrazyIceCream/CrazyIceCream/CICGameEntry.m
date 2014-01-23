//
//  CICGameEntry.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-7.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGameEntry.h"
#import "CICGameMainMenu.h"

@implementation CICGameEntry

-(void) dealloc
{
    [_gameMenu release];
    [super dealloc];
}

+(id) build
{
    return LC_AUTORELEASE([[CICGameEntry alloc] initWithWidth:LC_DEVICE_WIDTH height:480]);
}

-(id) initWithWidth:(float)width height:(float)height
{
    if (self = [super initWithWidth:width height:height]) {
        
        [self initMainUI];
    }
    
    return self;
}

-(void) initMainUI
{
    LC_GCD_SYNCHRONOUS(^{
    
        self.gameMenu = [CICGameMainMenu build];
        
        [self addChild:self.gameMenu];
    });
}

@end
