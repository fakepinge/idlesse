//
//  ZPMusicNewsCell.m
//  idlesse
//
//  Created by 胡知平 on 16/6/3.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPMusicNewsCell.h"
#import "ZPMusicNewsModel.h"

@implementation ZPMusicNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setModel:(ZPMusicNewsModel *)model {
    
    _model = model;
    
    _musicNewsTitleLabel.text = _model.title;
    
    NSArray *strArray = [_model.content168 componentsSeparatedByString:@"\n"];
    NSString *str = [strArray componentsJoinedByString:@" "];
    _musicNewsContentLabel.text = str;
    
    _authorlabel.text = _model.author;
    _readnumberLabel.text = [NSString stringWithFormat:@"阅读 %ld", _model.readarts];
    
    
    _timeLabel.text = _model.date;
    
    
    _musicNewsImageView.contentMode = UIViewContentModeScaleToFill;
//    //_musicNewsImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _musicNewsImageView.clipsToBounds = YES;
    [_musicNewsImageView sizeToFit];
   // [_musicNewsImageView setContentScaleFactor:[UIScreen mainScreen].scale];
    //UIImageView *imageView = [[UIImageView alloc] init];
    [_musicNewsImageView sd_setImageWithURL:[NSURL URLWithString:_model.imglink]];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//       UIImage *image = [self clipImageFromImage:imageView.image Rect: CGRectMake(0, 0,SCREEN_WIDTH - 20, 200)];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            _musicNewsImageView.image = image;
//        });
//    });
}




//-(UIImage *) clipImageFromImage:(UIImage *)orgImage Rect:(CGRect)clipRect{
//    
//    CGImageRef imageRef = orgImage.CGImage;
//    
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, clipRect);
//    
//    CGSize size;
//    
//    size = clipRect.size;
//    
//    UIGraphicsBeginImageContext(size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextDrawImage(context, clipRect, subImageRef);
//    
//    UIImage* clipImage = [UIImage imageWithCGImage:subImageRef];
//    
//    CGImageRelease(subImageRef);
//    
//    UIGraphicsEndImageContext();
//    
//    return clipImage;
//    
//}



    
@end
