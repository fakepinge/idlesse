//
//  ZPVertialButton.m
//  budejie
//
//  Created by 胡知平 on 16/5/26.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPVertialButton.h"

@implementation ZPVertialButton

- (void) setup {
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)awakeFromNib {
    
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    // ----图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    // ----文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
}


@end
