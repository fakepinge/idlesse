//
//  ZPMovieCommentCell.h
//  idlesse
//
//  Created by 胡知平 on 16/5/31.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPMovieCommentModel;

@protocol ZPMovieCommentCellDalegate <NSObject>

- (void) pushOtherUserMessage:(NSString *) userId;
@end

@interface ZPMovieCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumberlabel;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
/**model*/
@property (nonatomic, strong) ZPMovieCommentModel *model;

/**代理*/
@property (nonatomic, weak) id<ZPMovieCommentCellDalegate> delegate;

- (IBAction)likeAction:(UIButton *)sender;



@end
