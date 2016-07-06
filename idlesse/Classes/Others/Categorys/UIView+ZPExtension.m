//
//  UIView+ZPExtension.m
//  budejie
//
//  Created by 胡知平 on 16/5/21.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "UIView+ZPExtension.h"

@implementation UIView (ZPExtension)

- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size ;
    self.frame = frame;
    
}

- (CGSize)size {
    
    return self.frame.size;
}


- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}

- (void)setY:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (CGFloat)x {
    
    return self.frame.origin.x;
}

- (CGFloat)y {
    
    return self.frame.origin.y;
}

@end
