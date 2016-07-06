//
//  ZPEquipmentOrStrategyCell.m
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPEquipmentOrStrategyCell.h"
#import "ZPMusicNewsModel.h"

@implementation ZPEquipmentOrStrategyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(ZPMusicNewsModel *)model {
    
    _model = model;
    NSArray *strArray = [_model.title componentsSeparatedByString:@"——"];
    _titleLabel.text = [strArray componentsJoinedByString:@"\n——"];
    _readLabel.text = [NSString stringWithFormat:@"%ld人阅读", _model.readarts];
    _timeLabel.text = _model.date;
    
    [_musicImageView sd_setImageWithURL:[NSURL URLWithString:_model.imglink]];
}

@end
