//
//  CICGameScore.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-23.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "SPSprite.h"

@interface CICGameScore : SPSprite

@property(readonly)double score;

+(id) build;

-(void) addScore:(double)score;

@end
