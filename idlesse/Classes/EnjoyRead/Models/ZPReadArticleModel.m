//
//  ZPReadArticleModel.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPReadArticleModel.h"

@implementation ZPReadArticleModel
///*
// /** 图片宽度 */
//@property (nonatomic, assign) CGFloat Width;
///** 高度 */
//@property (nonatomic, assign) CGFloat Height;
///**ItemID*/
//@property (nonatomic, copy) NSString *ItemID;
///**真实图片链接*/
//@property (nonatomic, copy) NSString *RealUrl;
///**Title*/
//@property (nonatomic, copy) NSString *Title;
///**图片链接*/
//@property (nonatomic, copy) NSString *ImgUrl;
//
///** 是否收藏 */
//@property (nonatomic, assign) BOOL isFavorite;
//
///**cell的位置*/
//@property (nonatomic, strong) NSIndexPath *indexPath;
//
// */

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_ItemID forKey:@"ItemId"];
    [aCoder encodeObject:_RealUrl forKey:@"RealUrl"];
    [aCoder encodeObject:_Title forKey:@"Title"];
    [aCoder encodeObject:_ImgUrl forKey:@"ImgUrl"];
    [aCoder encodeBool:_isFavorite forKey:@"isFavorite"];
    [aCoder encodeObject:_indexPath forKey:@"indexPath"];
    [aCoder encodeDouble:_Width forKey:@"Width"];
    [aCoder encodeDouble:_Height forKey:@"Height"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        _ItemID = [aDecoder decodeObjectForKey:@"ItemId"];
        _RealUrl = [aDecoder decodeObjectForKey:@"RealUrl"];
        _Title = [aDecoder decodeObjectForKey:@"Title"];
        _ImgUrl = [aDecoder decodeObjectForKey:@"ImgUrl"];
        _isFavorite = [aDecoder decodeBoolForKey:@"isFavorite"];
        _indexPath = [aDecoder decodeObjectForKey:@"indexPath"];
        _Width = [aDecoder decodeDoubleForKey:@"Width"];
        _Height = [aDecoder decodeDoubleForKey:@"Height"];
    }
    return self;
}

@end
