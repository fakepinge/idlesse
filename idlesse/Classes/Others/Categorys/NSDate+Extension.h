//
//  NSDate+Extension.h
//  黑马微博2期
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

/**
 *  判断投个时间是否是未来几天包含今天
 */
- (BOOL) isAfterSomeDays;
/**
 *  判断某个时间是否为明天
 */
- (BOOL)isTomorrow;


@end
