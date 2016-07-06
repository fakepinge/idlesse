//
//  ZPMeRequestManager.m
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMeRequestManager.h"
#import "ZPUserModel.h"

@implementation ZPMeRequestManager

#pragma mark - 单例初始化
+ (instancetype)manager {
    
    static ZPMeRequestManager *instance = nil;
    
    if (!instance) {
        
        instance = [[ZPMeRequestManager alloc] initPrivate];
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

#pragma mark - 数据请求
- (void) requestUserId:(NSString *)userId complete:(void(^)(ZPUserModel *model, BOOL isSuccess)) complete {
    
    [[ZPAFNetworkingMangager manager].manager GET:ZPMeLoginId parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        ZPUserModel *model = [ZPUserModel yy_modelWithDictionary:responseObject[@"data"]];
        
        complete(model, YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void) requestLogincomplete:(void(^)(NSString *token ,BOOL isSuccess))complete {

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"reg_type"] = @"3";
    para[@"sex"] = @"0";
    para[@"uid"] = @"4398048059697";
    para[@"user_name"] = @"手机用户";
    para[@"web_url"] = nil;
    
    [[ZPAFNetworkingMangager manager].manager POST:ZPMeLoginToken parameters:para success:^(NSURLSessionDataTask *task, id responseObject) {
        ZPLog(@"%@", responseObject[@"data"][@"token"]);
        NSString *token = responseObject[@"data"][@"token"];
        complete(token, YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void) cancelAllRequest {
    
    [[[ZPAFNetworkingMangager manager].manager operationQueue] cancelAllOperations];
}




@end
