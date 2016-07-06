//
//  ZPMusicNewsDetailModel.h
//  idlesse
//
//  Created by 胡知平 on 16/6/4.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MusicNewsContent,MusicID;
@interface ZPMusicNewsDetailModel : NSObject <YYModel>


@property (nonatomic, strong) MusicNewsContent *content;

@property (nonatomic, assign) NSInteger likedcount;

@property (nonatomic, assign) NSInteger talkscount;

@property (nonatomic, assign) NSInteger favscount;

@property (nonatomic, assign) NSInteger melikecount;


@end
@interface MusicNewsContent : NSObject

@property (nonatomic, copy) NSString *surl;

@property (nonatomic, assign) NSInteger ARTICLES;

@property (nonatomic, copy) NSString *contentspelling;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *CTIME;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) MusicID *_id;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) BOOL DELFLAG;

@property (nonatomic, copy) NSString *content;

@end

@interface MusicID : NSObject

@property (nonatomic, assign) BOOL new;

@property (nonatomic, assign) NSInteger timeSecond;

@property (nonatomic, assign) NSInteger inc;

@property (nonatomic, assign) NSInteger machine;

@property (nonatomic, assign) long long time;

@end

