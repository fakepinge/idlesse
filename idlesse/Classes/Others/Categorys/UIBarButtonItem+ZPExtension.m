//
//  UIBarButtonItem+ZPExtension.m
//  budejie
//
//  Created by 胡知平 on 16/5/21.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "UIBarButtonItem+ZPExtension.h"

@implementation UIBarButtonItem (ZPExtension)


+ (instancetype)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id) target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[self alloc] initWithCustomView:button];
}

@end
