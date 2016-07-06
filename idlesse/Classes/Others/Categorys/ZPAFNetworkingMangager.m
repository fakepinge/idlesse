//
//  ZPAFNetworkingMangager.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPAFNetworkingMangager.h"

@implementation ZPAFNetworkingMangager

#pragma mark - 懒加载
- (AFHTTPSessionManager *) manager {

    if(!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        _manager= [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"application/json", @"text/html"]];
    }
    
    return _manager;
}

#pragma mark - 单例初始化
+ (instancetype)manager {
    
    static ZPAFNetworkingMangager *instance = nil;
    
    if (!instance) {
        
        instance = [[ZPAFNetworkingMangager alloc] initPrivate];
    }

    return instance;
}


- (instancetype)initPrivate {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)init {
    
    @throw [NSException exceptionWithName:@"抛出异常" reason:@"单例类使用manager初始化" userInfo:nil];
}


@end
