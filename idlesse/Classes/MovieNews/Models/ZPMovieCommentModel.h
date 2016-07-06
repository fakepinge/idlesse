//
//  ZPMovieCommentModel.h
//  idlesse
//
//  Created by 胡知平 on 16/5/31.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentUser;
@interface ZPMovieCommentModel : NSObject <YYModel>


@property (nonatomic, copy) NSString *touser;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger praisenum;

@property (nonatomic, strong) CommentUser *user;

@property (nonatomic, copy) NSString *input_date;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *quote;


@end
@interface CommentUser : NSObject

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *web_url;

@end

