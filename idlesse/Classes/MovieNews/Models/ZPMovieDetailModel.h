//
//  ZPMovieDetailModel.h
//  idlesse
//
//  Created by 胡知平 on 16/5/31.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPMovieDetailModel : NSObject <YYModel>


@property (nonatomic, copy) NSString *review;

@property (nonatomic, assign) NSInteger servertime;

@property (nonatomic, copy) NSString *maketime;

@property (nonatomic, copy) NSString *movie_id;

@property (nonatomic, assign) NSInteger sharenum;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *last_update_date;

@property (nonatomic, copy) NSString *releasetime;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *push_id;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *scoretime;

@property (nonatomic, copy) NSString *keywords;

@property (nonatomic, copy) NSString *video;

@property (nonatomic, copy) NSString *web_url;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, assign) NSInteger praisenum;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger commentnum;

@property (nonatomic, copy) NSString *read_num;

@property (nonatomic, copy) NSString *verse;

@property (nonatomic, copy) NSString *officialstory;

@property (nonatomic, copy) NSString *charge_edt;

@property (nonatomic, strong) NSArray<NSString *> *photo;

@property (nonatomic, copy) NSString *revisedscore;

@property (nonatomic, copy) NSString *verse_en;

@property (nonatomic, copy) NSString *detailcover;

@property (nonatomic, copy) NSString *indexcover;


@end
