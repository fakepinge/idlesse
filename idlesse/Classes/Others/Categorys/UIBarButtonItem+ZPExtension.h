//
//  UIBarButtonItem+ZPExtension.h
//  budejie
//
//  Created by 胡知平 on 16/5/21.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ZPExtension)

+ (instancetype) itemWithImageName:(NSString *)imageName highImageName:(NSString *) highImageName target:(id) target action:(SEL) action;

@end
