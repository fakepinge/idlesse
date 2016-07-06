//
//  ZPMovieListModel.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMovieListModel.h"

@implementation ZPMovieListModel

+ (NSDictionary *) modelCustomPropertyMapper {
    
    return @{@"movieId":@"id"};
}

- (NSString *)scoretime {
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 评分日期
    NSDate *createDate = [fmt dateFromString:_scoretime];
    
    if ([createDate isAfterSomeDays]){
        return @"等候评分";
    }
    return @"显示分数";
}

@end
