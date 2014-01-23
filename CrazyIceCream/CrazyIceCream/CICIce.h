//
//  CICIce.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-22.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "SPSprite.h"

@interface CICIce : SPSprite


@property(nonatomic,copy) CICGameFaildBlock faildBlock;
@property(nonatomic,copy) CICGamePassedBlock passedBlock;
@property(nonatomic,readonly) BOOL gameOver;


+(id) build;

-(void) startNewMission;

-(void) addIceAtIndex:(int)index;

@end
