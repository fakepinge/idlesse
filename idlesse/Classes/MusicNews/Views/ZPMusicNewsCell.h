//
//  ZPMusicNewsCell.h
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPMusicNewsModel;

@interface ZPMusicNewsCell : UITableViewCell

/**模型*/
@property (nonatomic, strong) ZPMusicNewsModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *musicNewsImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicNewsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *musicNewsContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorlabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *readnumberLabel;

@end
