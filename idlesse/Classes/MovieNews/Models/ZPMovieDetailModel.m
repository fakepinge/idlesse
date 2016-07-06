//
//  ZPMovieDetailModel.m
//  idlesse
//
//  Created by 胡知平 on 16/5/31.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMovieDetailModel.h"

@implementation ZPMovieDetailModel

+ (NSDictionary *) modelCustomPropertyMapper {
    
    return @{@"ID":@"id"};
}

- (NSString *)scoretime {

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 评分日期
    NSDate *createDate = [fmt dateFromString:_scoretime];
    
    if ([createDate isAfterSomeDays]){
        
        if ([createDate isTomorrow]) {
            
            return @"等候评分";
        }
        return @"即将上映";
    }
    return @"显示分数";
}

@end
