//
//  Header.h
//  budejie
//
//  Created by 胡知平 on 16/5/21.
//  Copyright © 2016年 fakepinge. All rights reserved.
//




#ifndef Header_h
#define Header_h

#pragma mark - 类别
#import <Social/Social.h>
#import "UIBarButtonItem+ZPExtension.h"
#import "UIView+ZPExtension.h"
#import "ZPAFNetworkingMangager.h"
#import "XLPromptController.h"
#import "NSDate+Extension.h"


#pragma mark - 接口文件
#import "Define.h"


#pragma mark - NSLog
#ifdef DEBUG
#define ZPLog(...) NSLog(__VA_ARGS__)
#else
#define ZPLog(...)
#endif

#define ZPLogFunc ZPLog(@"%s", __func__)

#pragma mark - 屏幕尺寸
#define SCREEN_FRAME [UIScreen mainScreen].bounds
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#pragma mark - 缓存路径
#define localCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define localDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


#pragma mark - color
#define ZPRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define ZPGlobalBgcolor ZPRGBColor(223, 223, 223)

#pragma mark - 字体
static NSString *const movieScoreListFont = @"ArensdorffInk-Regular";
static NSString *const movieScoreDetailFont = @"Cruickshank";


#pragma mark - APPKey
// ----友盟
//static NSString *const UMAPPKey = @"574fde9e67e58ee9fe001913";
// ----SMS
//static NSString *const SMSAPPKey = @"138a0068dc6dc";
//static NSString *const SMSAPPSecret = @"d884f3d9cfda62558d4ece0cbb482dee";

// ----LeanCloud
static NSString *const AVCloudAppId = @"fv7h4R7QixGR1CL10rozIEAp-gzGzoHsz";
static NSString *const AVCloudAppKey = @"niQfaYqliNx1jxzkx5ka7ekw";
// ----QQ
static NSString *const QQAppId = @"1105471146";
static NSString *const QQAppKey = @"jqcpVCVPppFFk9mt";
// ----weibo
//static NSString *const weiboAppId = @"965863242";
//static NSString *const weiboAppSecret = @"68b6da761a246d1271fecaed89164700";

#endif /* Header_h */
