//
//  CICGameTimeProgress.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-9.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "SPSprite.h"

#define CIC_TIME_OUT @"Timeout"

@interface CICGameTimeProgress : SPSprite

@property(nonatomic,copy) CICGameFaildBlock faildBlock;

+(id)build;

/* Second */
-(void) addTime:(int)time;
-(void) start;
-(void) stop;

@end
