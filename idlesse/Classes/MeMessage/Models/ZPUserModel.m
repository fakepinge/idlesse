//
//  ZPUserModel.m
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPUserModel.h"

@implementation ZPUserModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self yy_modelEncodeWithCoder:aCoder];
}

@end
@implementation UserTableModel

@end


