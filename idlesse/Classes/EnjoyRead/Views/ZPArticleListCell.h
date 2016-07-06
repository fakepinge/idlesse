//
//  ZPArticleListCell.h
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPReadArticleModel;

@protocol ZPArticleListCellDelegate <NSObject>


@optional
- (void) showremind;

- (void) shareContentText:(NSString *) text image:(UIImage *) image;
- (void) removeArticleModel:(ZPReadArticleModel *) model;
- (void) presentBigImage:(NSString *) realUrl value:(CGFloat) value;
- (void) addArticleModel:(ZPReadArticleModel *) model;
- (void) reportMessageModel:(ZPReadArticleModel *) model;

@end

@interface ZPArticleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

/**文章模型*/
@property (nonatomic, strong) ZPReadArticleModel *articleModel;

/**代理*/
@property (nonatomic, weak) id<ZPArticleListCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *articleImageViewHieghtConstraints;


@end
