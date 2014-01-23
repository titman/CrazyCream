//
//  CICGameEntry.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-7.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "SPStage.h"

@class CICGameMainMenu;

@interface CICGameEntry : SPStage

@property(nonatomic,retain) CICGameMainMenu * gameMenu;

+(id) build;

@end
