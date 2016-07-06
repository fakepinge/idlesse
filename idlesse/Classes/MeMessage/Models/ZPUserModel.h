//
//  ZPUserModel.h
//  idlesse
//
//  Created by 胡知平 on 16/6/7.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserTableModel;
@interface ZPUserModel : NSObject <YYModel, NSCoding>


@property (nonatomic, copy) NSString *score;

@property (nonatomic, assign) NSInteger isauthor;

@property (nonatomic, strong) UserTableModel *permission;

@property (nonatomic, copy) NSString *web_url;

@property (nonatomic, assign) NSInteger isdisabled;

@property (nonatomic, copy) NSString *background;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *desc;


@end
@interface UserTableModel : NSObject

@property (nonatomic, assign) NSInteger diary;

@property (nonatomic, assign) NSInteger music;

@property (nonatomic, assign) NSInteger other;

@end

