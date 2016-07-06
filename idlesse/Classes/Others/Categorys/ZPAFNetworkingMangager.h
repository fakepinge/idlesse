//
//  ZPAFNetworkingMangager.h
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@interface ZPAFNetworkingMangager : NSObject

/**数据请求对象*/
@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (instancetype) manager;



@end
