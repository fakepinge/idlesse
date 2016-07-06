//
//  ZPMusicRequestManager.m
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMusicRequestManager.h"
#import "ZPMusicNewsModel.h"
#import "ZPMusicNewsDetailModel.h"

@interface ZPMusicRequestManager ()

/**总数*/
@property (nonatomic, assign) NSInteger count;
/**数组元素*/
@property (nonatomic, strong) NSMutableArray *firstArray;
/**数组元素*/
@property (nonatomic, strong) NSMutableArray *secondArray;
/**数组元素*/
@property (nonatomic, strong) NSMutableArray *thirdArray;

@end
@implementation ZPMusicRequestManager

#pragma mark - 懒加载
- (NSMutableArray *)firstArray{
    
    if(!_firstArray) {
        
        _firstArray  = [NSMutableArray array];
    }
    
    return _firstArray;
}
#pragma mark - 懒加载
- (NSMutableArray *) secondArray {
    
    if(!_secondArray) {
        
        _secondArray = [NSMutableArray array];
    }
    
    return _secondArray;
}
#pragma mark - 懒加载
- (NSMutableArray *) thirdArray {
    
    if(!_thirdArray) {
        
        _thirdArray = [NSMutableArray array];
    }
    
    return _thirdArray;
}

#pragma mark - 单例初始化
+ (instancetype)manager {
    
    static ZPMusicRequestManager *instance = nil;
    
    if (!instance) {
        
        instance = [[ZPMusicRequestManager alloc] initPrivate];
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
- (void) requestDataPage:(NSInteger) page type:(NSString *) type complete:(void(^)(NSArray *modelArray, NSInteger count, BOOL isSuccess))complete{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"npc"] = @(page);
    parameter[@"opc"] = @(20);
    parameter[@"type"] = type;
    __weak typeof(self) weakSelf = self;
    
    [[ZPAFNetworkingMangager manager].manager GET:ZPMusicNews parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([type isEqualToString:musicNewsType]) {
            
            weakSelf.count = [responseObject[@"root"][@"count"] integerValue];
            NSArray *modelArray = [NSArray yy_modelArrayWithClass:[ZPMusicNewsModel class] json:responseObject[@"root"][@"list"]];

            
            [weakSelf.firstArray addObjectsFromArray:modelArray];
            complete(weakSelf.firstArray, weakSelf.count, YES);
        } else if ([type isEqualToString:musicEquipmentType]) {
            
            weakSelf.count = [responseObject[@"root"][@"count"] integerValue];
            NSArray *modelArray = [NSArray yy_modelArrayWithClass:[ZPMusicNewsModel class] json:responseObject[@"root"][@"list"]];
            [weakSelf.secondArray addObjectsFromArray:modelArray];
            complete(weakSelf.secondArray, weakSelf.count, YES);
        } else {
            
            weakSelf.count = [responseObject[@"root"][@"count"] integerValue];
            NSArray *modelArray = [NSArray yy_modelArrayWithClass:[ZPMusicNewsModel class] json:responseObject[@"root"][@"list"]];
            [weakSelf.thirdArray addObjectsFromArray:modelArray];
            complete(weakSelf.thirdArray, weakSelf.count, YES);
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        });
    }];
}

- (void) requestMusicDetialId:(NSString *)musicDetialId complete:(void(^)(ZPMusicNewsDetailModel *model, BOOL isSuccess))complete {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"id"] = musicDetialId;
    
    [[ZPAFNetworkingMangager manager].manager GET:ZPMusicNewsDetial parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        
        ZPMusicNewsDetailModel *model = [ZPMusicNewsDetailModel yy_modelWithDictionary:responseObject[@"root"]];
        complete(model, YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"加载文章失败"];
    }];
    
}


- (void) requestMusicDetialId:(NSString *)musicDetialId commentText:(NSString *) text complete:(void(^)(BOOL isSuccess))complete {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"id"] = musicDetialId;
    parameter[@"text"] = text;
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    [requestManager GET:ZPMusicNewsCommentUp parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ZPLog(@"获取服务器响应出错");
    }];


    
}


- (void) cancelAllRequest {
    
    [[[ZPAFNetworkingMangager manager].manager operationQueue] cancelAllOperations];
}

@end
