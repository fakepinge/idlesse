//
//  ZPTextField.m
//  budejie
//
//  Created by 胡知平 on 16/5/26.
//  Copyright © 2016年 fakepinge. All rights reserved.
//

#import "ZPTextField.h"
#import <objc/runtime.h>

NSString *const placeholderLabelPath = @"_placeholderLabel.textColor";

@implementation ZPTextField

#pragma mark - 获取私有成员变量
//+ (void)initialize {
//    
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([UITextField class], &count);
//    
//    for (int i = 0; i < count; i++) {
//        
//        Ivar ivar = *(ivars + i);
//        ZPLog(@"%s", ivar_getName(ivar));
//        
//    }
//    
//    
//}


- (void)awakeFromNib {
    // ----设置光标颜色
    self.tintColor = self.textColor;
    
    self.placeholderColor = [UIColor grayColor];
    self.placeholderSelectedColor = [UIColor whiteColor];
    [self resignFirstResponder];
}

/**
 *  设置未选中的占位符颜色
 *
 *  @return
 */
- (BOOL)resignFirstResponder {
    
    //[self setValue:self.placeholderColor forKeyPath:placeholderLabelPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = self.placeholderColor;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    self.attributedPlaceholder = str;
    
    return [super resignFirstResponder];
}

/**
 *  设置选中的占位符颜色
 *
 *  @return
 */
- (BOOL)becomeFirstResponder {
    
    //[self setValue:self.placeholderSelectedColor forKeyPath:placeholderLabelPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = self.placeholderSelectedColor;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    self.attributedPlaceholder = str;
    return [super becomeFirstResponder];
}

@end
