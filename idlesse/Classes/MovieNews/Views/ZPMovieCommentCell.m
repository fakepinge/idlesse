//
//  ZPMovieCommentCell.m
//  idlesse
//
//  Created by 胡知平 on 16/5/31.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMovieCommentCell.h"
#import "ZPMovieCommentModel.h"

@implementation ZPMovieCommentCell



- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapHandel = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(userMessage)];
    [self.userIconImageView addGestureRecognizer:tapHandel];
    
}

- (void) userMessage {
    
    [self.delegate pushOtherUserMessage:self.model.user.user_id];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeAction:(UIButton *)sender {
    
    ZPLogFunc;
    if (sender.selected == NO) {
        
        sender.selected = YES;
        self.likeNumberlabel.text = [NSString stringWithFormat:@"%ld", [self.likeNumberlabel.text integerValue] + 1];
    } else {
        
        sender.selected = NO;
        self.likeNumberlabel.text = [NSString stringWithFormat:@"%ld", [self.likeNumberlabel.text integerValue] - 1];
    }
}


- (void)setModel:(ZPMovieCommentModel *)model {
    
    _model = model;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.user.web_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.5);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.userIconImageView.image = [UIImage imageWithData:imageData];
            });
        });
    }];

    self.userNameLabel.text = _model.user.user_name;
    self.likeNumberlabel.text = [NSString stringWithFormat:@"%ld", _model.praisenum];
    
    NSArray *strArray = [[[_model.input_date componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"];
    self.dateLabel.text = [strArray componentsJoinedByString:@"."];
    self.commentContentLabel.text = _model.content;
    
    if (_model.score) {
        
        self.scoreLabel.attributedText = [[self scorewithFontName:movieScoreDetailFont fontSize:20 isUnderlines:NO score:_model.score] copy];
    } else {
        
        self.scoreLabel.text = @"";
    }
    

}

#pragma mark - 富文本显示分数
- (NSMutableAttributedString *) scorewithFontName:(NSString *) fontName fontSize:(NSInteger) fontSize isUnderlines:(BOOL) isUnderlines score:(NSString *) score{
    
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = [UIFont fontWithName:fontName size:fontSize];
     attri[NSForegroundColorAttributeName] = [UIColor redColor];
    if (isUnderlines) {
        
       
        attri[NSUnderlineStyleAttributeName] = @(50);
    }
    
    return [[NSMutableAttributedString alloc] initWithString:score attributes:attri];
}


@end
