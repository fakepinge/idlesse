//
//  Define.h
//  TestDemo
//
//  Created by 胡知平 on 16/5/29.
//  Copyright © 2016年 fakepinge. All rights reserved.
//


/**
 *  API接口
 */

#ifndef define_h
#define define_h


#pragma mark - 美文专题接口 POST请求 text/html
/**
 *  美文列表接口
 */
#define ZPEnjoyReading @"http://hl.51wnl.com/upgrade/dayword/getdayword.ashx"
// --参数列表
/**
 * daystr = @"2014-05-02" 文章时间 下拉刷新随机换日期
 * count = @(20); 文章个数
 */
#define enjoyReadingDayStr [NSString stringWithFormat:@"20%02d-%02d-%02d", arc4random() % 2?14:15, arc4random() % 12 + 1, arc4random() % 30 + 1]



#pragma mark - 音乐专题接口 GET请求 application/json
/**
 *  音讯列表接口
 */
#define ZPMusicNews @"http://api.music.app887.com/api/Articles.action"
// --参数列表
/**
 *  npc = @(0); 页码 上拉刷新 页码递增
 *  opc = @(20); 每页个数
 *  type =  @"乐坛资讯", @"装备评测", @"攻略知识"
 */

static NSString *const musicNewsType = @"乐坛资讯";
static NSString *const musicEquipmentType = @"装备评测";
static NSString *const musicStrategyType = @"攻略知识";

/**
 *  文章详情
 */
#define ZPMusicNewsDetial @"http://api.music.app887.com/api/Contents.action"
// --参数列表
/**
 * id = @"956134393"; 文章id
 */

/**
 *  文章评论
 */
// ----读取接口
#define ZPMusicNewsComment @"http://api.music.app887.com/api/Talks.action?id=%@&opc=10&npc=%@"
// ----上传接口
#define ZPMusicNewsCommentUp @"http://api.music.app887.com/api/Talk.action"
// --参数列表
/**
 * id = @"956134393"; 文章id
 * opc = @(10); 显示评论个数
 * npc = @(0); 页码 上拉刷新 页码递增
 * text 上传的参数
 */



#pragma mark - 影讯专题接口  GET请求 text/html
/**
 *  电影列表接口
 */
#define ZPMoiveList @"http://v3.wufazhuce.com:8000/api/movie/list/%@"
// ----参数
/**
 *  第一页加载传入@"0"，默认从最大id开始加载
 *  上拉加载更多时,参数传入上一页请求到的数据最后的id
 */


/**
 *  电影详情接口
 */
#define ZPMoiveDetail @"http://v3.wufazhuce.com:8000/api/movie/detail/%@"
// ----参数
/**
 *  参数传入电影的id
 */


/**
 *  电影详情页面的显示的第一个故事的内容
 */
#define ZPMovieOneStory @"http://v3.wufazhuce.com:8000/api/movie/%@/story/1/0"
// ----参数
/**
 *  参数传入电影的id
 */


/**
 *  电影详情页面点击全部故事的接口
 */
#define ZPMovieAllStory @"http://v3.wufazhuce.com:8000/api/movie/%@/story/0/%@"
/**
 *  参数传入电影的id
 *  参数传入默认是0 请求第一页的电影故事 加载更多是传入上一页最后一个故事的id
 */





/**
 *  电影详情页面的评论列表
 */
#define ZPMovieComment @"http://v3.wufazhuce.com:8000/api/comment/praiseandtime/movie/%@/%@"
// ----参数
/**
 *  1.参数传入电影的id
 *  2.传入页数 默认是0 上拉刷新是页参数上一次请求最后参数的id
 */

#pragma mark - 我的专题接口
// ----GET
#define ZPMeLoginId @"http://v3.wufazhuce.com:8000/api/user/info/6878021"
// ----POST
#define ZPMeLoginToken @"http://v3.wufazhuce.com:8000/api/user/login"
/**
 *  reg_type 3
 *  sex 0
 *  uid 4398048059697
 *  user_name 手机用户
 *  web_url
 */
// ----GET
#define ZPMeCollection @"http://v3.wufazhuce.com:8000/api/collection/newer/4/0"
/**
 jwt = eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE0NjUxMjk5NDYsInVzZXJpZCI6IjY4NzgwMjEifQ.8ckJrQZW3euNtMFNgI6JJyn2Yux2AirOz1rBA5EtBgE
 */
// ----用户id
#define ZPOtherUserMessage @"http://v3.wufazhuce.com:8000/api/user/info/%@"

 
#endif /* define_h */
