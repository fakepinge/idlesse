//
//  ZPMeRequestManager.h
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPUserModel;
@interface ZPMeRequestManager : NSObject


+ (instancetype) manager;


- (void) requestUserId:(NSString *)userId complete:(void(^)(ZPUserModel *model, BOOL isSuccess)) complete;

- (void) requestLogincomplete:(void(^)(NSString *token ,BOOL isSuccess))complete;

- (void) cancelAllRequest;

@end
