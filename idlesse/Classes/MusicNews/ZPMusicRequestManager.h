//
//  ZPMusicRequestManager.h
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZPMusicNewsDetailModel;
@interface ZPMusicRequestManager : NSObject



+ (instancetype) manager;

- (void) requestDataPage:(NSInteger) page type:(NSString *) type complete:(void(^)(NSArray *modelArray, NSInteger count, BOOL isSuccess))complete;

- (void) requestMusicDetialId:(NSString *)musicDetialId complete:(void(^)(ZPMusicNewsDetailModel *model, BOOL isSuccess))complete;

- (void) requestMusicDetialId:(NSString *)musicDetialId commentText:(NSString *) text complete:(void(^)(BOOL isSuccess))complete;

- (void) cancelAllRequest;

@end
