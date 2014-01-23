//
//  CICGameConfig.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-9.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#define INITIAL_TIME 30
#define INITIAL_ADD_TIME 0.2

#define BAD_SCORE 2000
#define GOOD_SCORE 3000
#define GREAT_SCORE 4000
#define PERFECT_SCORE 5000

#define TIME_SCORE_BASE 10000 // 每一关分数会增加 : TIME_SCORE_BASE - (关卡开始时间 - 关卡结束时间)

typedef void (^CICGameFaildBlock) (id value);
typedef void (^CICGamePassedBlock) (id value);