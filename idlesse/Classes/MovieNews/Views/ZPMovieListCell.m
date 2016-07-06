//
//  ZPMovieListCell.m
//  idlesse
//
//  Created by 胡知平 on 16/5/30.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMovieListCell.h"
#import "ZPMovieListModel.h"

@implementation ZPMovieListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - cell之间的间隙
- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 5;
    [super setFrame:frame];
}


- (void)setModel:(ZPMovieListModel *)model {
    
    _model = model;
    
    // ----处理图片
    UIImageView *imageView = [[UIImageView alloc] init];
    __weak typeof(self) weakSelf = self;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:[UIImage imageNamed:@"default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //NSMutableDictionary *imagePathMessage = [NSMutableDictionary dictionary];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.5);
//            NSString *savePath = [localCachePath stringByAppendingPathComponent:@"movieListImage.data"];
//            [imageData writeToFile:savePath atomically:YES];
//            imagePathMessage[_model.cover] = savePath;
            dispatch_async(dispatch_get_main_queue(), ^{
               
                weakSelf.coverImageView.image = [UIImage imageWithData: imageData];
            });
        });

    }];
    
//    NSArray *fontFamilies = [UIFont familyNames];
//    for (int i = 0; i < [fontFamilies count]; i++)
//    {
//        NSString *fontFamily = [fontFamilies objectAtIndex:i];
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
//        ZPLog (@"%@: %@", fontFamily, fontNames);
//    }
    
    // ----处理分数
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = [UIFont fontWithName:movieScoreListFont size:40];
    attri[NSForegroundColorAttributeName] = [UIColor redColor];
    attri[NSUnderlineStyleAttributeName] = @(50);
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", _model.score] attributes:attri];
    
    if ([_model.scoretime isEqualToString:@"显示分数"]) {
        
        _scoreLabel.attributedText = attriStr;
    } else {
        
        _scoreLabel.text = _model.scoretime;
    }
}



@end
