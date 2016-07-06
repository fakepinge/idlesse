//
//  ZPArticleListCell.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPArticleListCell.h"
#import "ZPReadArticleModel.h"


@implementation ZPArticleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigImage:)];
    
    [self.articleImageView addGestureRecognizer:tap];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

#pragma mark - 跳转到大图模式
- (void) bigImage:(UITapGestureRecognizer *) tap {
    
    [self.delegate presentBigImage:_articleModel.RealUrl value:_articleModel.Height / _articleModel.Width * 1.0f];
    
}

#pragma mark - cell赋值
- (void)setArticleModel:(ZPReadArticleModel *)articleModel {
    
    _articleModel = articleModel;
    _titleLabel.text = _articleModel.Title;
    
    _favoritesButton.selected = _articleModel.isFavorite;
    
    [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:_articleModel.ImgUrl] placeholderImage:[UIImage imageNamed:@"default"]];
}



#pragma mark - 按钮点击事件
- (IBAction)copyButton:(UIButton *)sender {
    
    [[UIPasteboard generalPasteboard] setString:self.titleLabel.text];
    [self.delegate showremind];
}

- (IBAction)likeButton:(UIButton *)sender {
    
    if (sender.selected == NO) {
        
        sender.selected = YES;
        [self.delegate addArticleModel:self.articleModel];
        self.articleModel.isFavorite = YES;
    } else {
        
        sender.selected = NO;
        [self.delegate removeArticleModel:self.articleModel];
        self.articleModel.isFavorite = NO;
    }
}

- (IBAction)shareButton:(UIButton *)sender {
    
    [self.delegate shareContentText:self.titleLabel.text image:self.articleImageView.image];
}

- (IBAction)reportAction:(UIButton *)sender {
    
    [self.delegate reportMessageModel:self.articleModel];
}



@end
