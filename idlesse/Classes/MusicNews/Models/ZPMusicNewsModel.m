//
//  ZPMusicNewsModel.m
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMusicNewsModel.h"


@implementation ZPMusicNewsModel


- (NSString *)date {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 创建日期
    NSDate *createDate = [fmt dateFromString:_date];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            if ((int)cmps.day >= 7) {
                return @"一周以前";
            }
            return [NSString stringWithFormat:@"%d天前", (int)cmps.day];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createDate];
    }

    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self yy_modelEncodeWithCoder:aCoder];
}

@end
@implementation ZPNewMessage

@end


