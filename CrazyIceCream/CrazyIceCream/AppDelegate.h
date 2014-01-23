//
//  AppDelegate.h
//  CrazyIceCream
//
//  Created by 郭历成 ( titm@tom.com ) on 14-1-7.
//  Copyright (c) 2014年 Wuxiantai Developer ( http://www.wuxiantai.com ). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sparrow.h"

@class CICGameEntry;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain,nonatomic) CICGameEntry * gameEntry;
@property (strong, nonatomic) UIWindow * window;

@end
