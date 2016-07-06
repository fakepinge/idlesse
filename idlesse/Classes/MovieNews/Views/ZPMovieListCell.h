//
//  ZPMovieListCell.h
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPMovieListModel;

@interface ZPMovieListCell : UITableViewCell

/**模型*/
@property (nonatomic, strong) ZPMovieListModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
