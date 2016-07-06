//
//  ZPEquipmentOrStrategyCell.h
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPMusicNewsModel;

@interface ZPEquipmentOrStrategyCell : UITableViewCell


/**模型*/
@property (nonatomic, strong) ZPMusicNewsModel *model;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;

@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;

@end
