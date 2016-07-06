//
//  ZPReadArticleModel.h
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPReadArticleModel : NSObject <YYModel, NSCoding>

/** 图片宽度 */
@property (nonatomic, assign) CGFloat Width;
/** 高度 */
@property (nonatomic, assign) CGFloat Height;
/**ItemID*/
@property (nonatomic, copy) NSString *ItemID;
/**真实图片链接*/
@property (nonatomic, copy) NSString *RealUrl;
/**Title*/
@property (nonatomic, copy) NSString *Title;
/**图片链接*/
@property (nonatomic, copy) NSString *ImgUrl;

/** 是否收藏 */
@property (nonatomic, assign) BOOL isFavorite;

/**cell的位置*/
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
