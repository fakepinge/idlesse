//
//  ZPMusicNewsModel.h
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPNewMessage;
@interface ZPMusicNewsModel : NSObject <YYModel, NSCoding>


@property (nonatomic, assign) NSInteger TYPESETTING;

@property (nonatomic, assign) NSInteger liked;

@property (nonatomic, strong) NSArray *talks;

@property (nonatomic, assign) BOOL PUBLISH;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *CTIME;

@property (nonatomic, copy) NSString *imglink;

@property (nonatomic, assign) NSInteger talkcount;

@property (nonatomic, assign) NSInteger readarts;

@property (nonatomic, assign) BOOL DELFLAG;

@property (nonatomic, strong) ZPNewMessage *_id;

@property (nonatomic, copy) NSString *sourcename;

@property (nonatomic, assign) NSInteger likecount;

@property (nonatomic, assign) BOOL OPENSOURCE;

@property (nonatomic, assign) NSInteger SORT;

@property (nonatomic, assign) NSInteger recommond;

@property (nonatomic, copy) NSString *content168;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) NSInteger faved;

@property (nonatomic, copy) NSString *TYPE;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *videolink;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, copy) NSString *titlespelling;


@end
@interface ZPNewMessage : NSObject

@property (nonatomic, assign) BOOL new;

@property (nonatomic, assign) NSInteger timeSecond;

@property (nonatomic, assign) NSInteger inc;

@property (nonatomic, assign) NSInteger machine;

@property (nonatomic, assign) long long time;

@end

