//
//  CICGameScoreLocalCache.m
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-23.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import "CICGameScoreLocalCache.h"

#define CACHE_PATH LC_NSSTRING_FORMAT(@"%@/score.txt",[LC_Sanbox docPath])

@implementation CICGameScoreLocalCache

+(void) touch
{
    NSString * filePath = CACHE_PATH;
    
    if(![LC_FileManager fileExistsAtPath:filePath]){
        [[NSMutableArray array] writeToFile:filePath atomically:YES];
    }
}

+(NSMutableArray *) scoreCache
{
    [CICGameScoreLocalCache touch];
    
    return [NSMutableArray arrayWithContentsOfFile:CACHE_PATH];
}

+(BOOL) addNewScore:(double)score
{
    if (score <= 0) {
        return NO;
    }
    
    NSMutableArray * scoreCache = [CICGameScoreLocalCache scoreCache];
    [scoreCache addObject:[NSNumber numberWithDouble:score]];
    
    [scoreCache sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending ;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    if (scoreCache.count > 20) {
        scoreCache = [NSMutableArray arrayWithArray:[scoreCache subarrayWithRange:NSMakeRange(0, 20)]];
    }
    
    [scoreCache writeToFile:CACHE_PATH atomically:YES];
    
    if (score == [scoreCache[0] doubleValue]) {
        return YES;
    }else{
        return NO;
    }
}

@end
