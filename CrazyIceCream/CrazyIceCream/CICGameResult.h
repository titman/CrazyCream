//
//  CICGameResult.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-22.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "SPSprite.h"

typedef enum _CICGameResultType{
    
    CICGameResultTypeTimeout= 0,
    CICGameResultTypeWrong= 1,
    
} CICGameResultType;

@interface CICGameResult : SPSprite

+(id) buildWithType:(CICGameResultType)type score:(double)score;

-(void) insertWillRemoveChildren:(id)object;


@end
